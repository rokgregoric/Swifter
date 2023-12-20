//
//  Log.swift
//
//  Created by Rok Gregorič
//  Copyright © 2018 Rok Gregorič. All rights reserved.
//

import Foundation
import OSLog
import SwifterJSON

class Log {
  static var shared = Log()

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

    var symbolValue: String { symbol ?? "🟣" }

    var name: String { "\(self)".uppercased() }

    var id: String { "[\(name)]" }
  }

  private class func stringify(_ messages: [Any?]) -> String {
    messages.flat.map {
      ($0 as? [Any]).flatMap { $0.isEmpty ? "[]" : JSON($0).rawString() } ??
        ($0 as? [String: Any]).flatMap { $0.isEmpty ? "{}" : JSON($0).rawString() } ??
        ($0 as? [CustomStringConvertible]).flatMap { $0.isEmpty ? "[]" : JSON($0.map { $0.description }).rawString() } ?? "\($0)"
    }.joined(" ")
  }

  var devLogging: Bool { AppEnvironment.isDebuggerAttached }

  class func dev(flag: Bool, level: Level = .verbose, _ message: Any?..., file: String = #file, function: String = #function, line: Int = #line, context: String? = nil) {
    guard flag else { return }
    dev(level: level, message, file: file, function: function, line: line, context: context)
  }

  class func dev(level: Level = .verbose, _ message: Any?..., file: String = #file, function: String = #function, line: Int = #line, context: String? = nil) {
    guard shared.devLogging else { return }
    custom(level: level, message: message, file: file, function: function, line: line, context: context)
  }

  class func verbose(_ message: Any?..., file: String = #file, function: String = #function, line: Int = #line, context: String? = nil) {
    custom(level: .verbose, message: message, file: file, function: function, line: line, context: context)
  }

  class func debug(_ message: Any?..., file: String = #file, _ function: String = #function, line: Int = #line, context: String? = nil) {
    custom(level: .debug, message: message, file: file, function: function, line: line, context: context)
  }

  class func info(_ message: Any?..., file: String = #file, _ function: String = #function, line: Int = #line, context: String? = nil) {
    custom(level: .info, message: message, file: file, function: function, line: line, context: context)
  }

  class func warning(_ message: Any?..., file: String = #file, _ function: String = #function, line: Int = #line, context: String? = nil) {
    custom(level: .warning, message: message, file: file, function: function, line: line, context: context)
  }

  class func error(_ message: Any?..., file: String = #file, _ function: String = #function, line: Int = #line, context: String? = nil) {
    custom(level: .error, message: message, file: file, function: function, line: line, context: context)
  }

  struct Filter {
    var levels: [Level]
    var contexts: [String]
    var messages: [String]
  }

  private var filter: Filter?

  class func filter(levels: [Level] = [], contexts: [String] = [], messages: [String] = []) {
    shared.filter = Filter(levels: levels, contexts: contexts.map { $0.lowercased() }, messages: messages.map { $0.lowercased() })
  }

  class func custom(level: Level, message: Any?..., file: String = #file, function: String = #function, line: Int = #line, context: String? = nil) {
    let msg = stringify(message)
    func logit() {
      shared.custom(level: level, messages: msg, file: file, function: function, line: line, context: context)
    }
    if let f = shared.filter {
      if f.levels.contains(level) { return logit() }
      f.messages.forEach { if msg.lowercased().contains($0) { return logit() } }
      if let c = context { f.contexts.forEach { if c.lowercased().contains($0) { return logit() } } }
    } else {
      logit()
    }
  }

  /// override endpoint
  func custom(level: Level, messages: String, file _: String, function _: String, line _: Int, context: String?) {
    let c = context?.uppercased()
    let msg = [c.map { "[\($0)]" }, messages].flatJoined(" ")
    let symbol = level.symbolValue
    if AppEnvironment.isDebuggerAttached {
      print(DateFormat.timeMili.currentString, symbol, msg)
    } else {
      let log = OSLog(subsystem: AppEnvironment.identifier, category: c ?? "")
      os_log("%{public}@ %{public}@", log: log, type: level.logType, symbol, msg)
    }
  }
}

// MARK: - Equatable

func == (lhs: Log.Level, rhs: Log.Level) -> Bool {
  lhs.rawValue == rhs.rawValue
}

func < (lhs: Log.Level, rhs: Log.Level) -> Bool {
  lhs.rawValue < rhs.rawValue
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
