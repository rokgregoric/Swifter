//
//  Log.swift
//
//  Created by Rok Gregorič
//  Copyright © 2018 Rok Gregorič. All rights reserved.
//

import Foundation
import SwifterJSON
import OSLog

class Log {
  enum Level: Int {
    case verbose = 0
    case debug = 1
    case info = 2
    case warning = 3
    case error = 4

    var symbol: String? {
      switch self {
        case .verbose: return nil
        case .debug: return "🟢"
        case .info: return "🔵"
        case .warning: return "🟠"
        case .error: return "🔴"
      }
    }

    var name: String { "\(self)".uppercased() }

    var id: String { "[\(name)]" }
  }

  private class func stringify(_ messages: [Any?]) -> String {
    messages.flat.map {
      ($0 as? [String: Any]).flatMap { JSON($0).rawString() } ??
      ($0 as? [Any]).flatMap { JSON($0).rawString() } ??
      ($0 as? [CustomStringConvertible]).flatMap { $0.isEmpty ? "[]" : JSON($0.map { $0.description }).rawString() } ?? "\($0)"
    }.joined(" ")
  }

  class func dev(level: Level = .verbose, _ message: Any?..., file: String = #file, function: String = #function, line: Int = #line, context: String? = nil) {
    if !Environment.isDebuggerAttached { return }
    custom(level: level, message: stringify(message), file: file, function: function, line: line, context: context)
  }

  class func verbose(_ message: Any?..., file: String = #file, function: String = #function, line: Int = #line, context: String? = nil) {
    custom(level: .verbose, message: stringify(message), file: file, function: function, line: line, context: context)
  }

  class func debug(_ message: Any?..., file: String = #file, _ function: String = #function, line: Int = #line, context: String? = nil) {
    custom(level: .debug, message: stringify(message), file: file, function: function, line: line, context: context)
  }

  class func info(_ message: Any?..., file: String = #file, _ function: String = #function, line: Int = #line, context: String? = nil) {
    custom(level: .info, message: stringify(message), file: file, function: function, line: line, context: context)
  }

  class func warning(_ message: Any?..., file: String = #file, _ function: String = #function, line: Int = #line, context: String? = nil) {
    custom(level: .warning, message: stringify(message), file: file, function: function, line: line, context: context)
  }

  class func error(_ message: Any?..., file: String = #file, _ function: String = #function, line: Int = #line, context: String? = nil) {
    custom(level: .error, message: stringify(message), file: file, function: function, line: line, context: context)
  }

  private static let shared = Log()

  struct Filter {
    var level: Level?
    var lowestLevel: Level?
    var context: String?
    var message: String?
  }
  private var filter: Filter?

  class func filter(level: Level? = nil, lowestLevel: Level? = nil, context: String? = nil, message: String? = nil) {
    shared.filter = Filter(level: level, lowestLevel: lowestLevel, context: context, message: message)
  }

  class func custom(level: Level, message: Any?..., file: String = #file, function: String = #function, line: Int = #line, context: String? = nil) {
    let msg = stringify(message)
    if let f = shared.filter {
      if let l = f.level, level != l { return }
      if let l = f.lowestLevel, level < l { return }
      if let m = f.message?.lowercased(), msg.lowercased().contains(m) != true { return }
      if let c = f.context?.lowercased(), context?.lowercased().contains(c) != true { return }
    }
    shared.custom(type: level.logType, messages: msg, file: file, function: function, line: line, context: context)
  }

  /// swizzlable
  @objc dynamic func custom(type: OSLogType, messages: String, file: String, function: String, line: Int, context: String?) {
    let c = context?.uppercased()
    let msg = [c.map { "[\($0)]" }, type.logLevel.symbol, messages].flatJoined(" ")
    if Environment.isDebuggerAttached {
      print(DateFormat.timeMili.currentString, msg)
    } else {
      let log = OSLog(subsystem: Environment.identifier, category: c ?? "")
      os_log("%{public}@ %{public}@", log: log, type: type, msg)
    }
  }
}

// MARK: - Equatable

func ==(lhs: Log.Level, rhs: Log.Level) -> Bool {
  return lhs.rawValue == rhs.rawValue
}

func <(lhs: Log.Level, rhs: Log.Level) -> Bool {
  return lhs.rawValue < rhs.rawValue
}

// MARK: - Log.Level <> OSLogType

extension Log.Level {
  var logType: OSLogType {
    switch self {
      case .verbose: return .default
      case .debug: return .debug
      case .info: return .info
      case .warning: return .fault
      case .error: return .error
    }
  }
}

extension OSLogType {
  var logLevel: Log.Level {
    switch self {
      case .debug: return .debug
      case .info: return .info
      case .fault: return .warning
      case .error: return .error
      default: return .verbose
    }
  }
}
