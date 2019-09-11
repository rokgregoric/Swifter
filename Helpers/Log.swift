//
//  Log.swift
//
//  Created by Rok Gregorič
//  Copyright © 2018 Rok Gregorič. All rights reserved.
//

import Foundation

class Log {

  enum Level: Int {
    case verbose = 0
    case debug = 1
    case info = 2
    case warning = 3
    case error = 4

    var symbol: String {
      switch self {
        case .verbose: return "💜"
        case .debug: return "💚"
        case .info: return "💙"
        case .warning: return "💛"
        case .error: return "❤️"
      }
    }

    var name: String {
      return "\(self)".uppercased()
    }

    var id: String {
      return "[\(name)]"
    }
  }

  fileprivate static func stringify(_ messages: [Any?]) -> String {
    return messages.flat.map { "\($0)" }.joined(separator: " ")
  }

  static func verbose(_ message: Any?..., file: String = #file, function: String = #function, line: Int = #line, context: String? = nil) {
    custom(level: .verbose, message: stringify(message), file: file, function: function, line: line, context: context)
  }

  static func debug(_ message: Any?..., file: String = #file, _ function: String = #function, line: Int = #line, context: String? = nil) {
    custom(level: .debug, message: stringify(message), file: file, function: function, line: line, context: context)
  }

  static func info(_ message: Any?..., file: String = #file, _ function: String = #function, line: Int = #line, context: String? = nil) {
    custom(level: .info, message: stringify(message), file: file, function: function, line: line, context: context)
  }

  static func warning(_ message: Any?..., file: String = #file, _ function: String = #function, line: Int = #line, context: String? = nil) {
    custom(level: .warning, message: stringify(message), file: file, function: function, line: line, context: context)
  }

  static func error(_ message: Any?..., file: String = #file, _ function: String = #function, line: Int = #line, context: String? = nil) {
    custom(level: .error, message: stringify(message), file: file, function: function, line: line, context: context)
  }

  static func custom(level: Level, message: Any?..., file: String = #file, function: String = #function, line: Int = #line, context: String? = nil) {
    let m = stringify(message)
    let c = context.map { "[\($0.uppercased())]" }
    if Environment.isDevelopment, !Environment.isSimulator {
      NSLog("DEBUG: %@ %@", level.symbol, [c, m].flatJoined(" "))
    } else {
      print(level.symbol, [c, m].flatJoined(" "))
    }
  }
}
