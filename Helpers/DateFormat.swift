//
//  DateFormat.swift
//
//  Created by Rok Gregorič
//  Copyright © 2018 Rok Gregorič. All rights reserved.
//

import Foundation

enum DateFormat: String {
  case timeMili = "HH:mm:ss.SSS"
  case dateOnly = "yyyy-MM-dd"
  case dateTime = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
  case dateTimeFull = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
  case timestamp = "yyyyMMddHHmmss"

  /// true when the timezone is specified in the format
  var isUTC: Bool { [.dateTime, .dateTimeFull].contains(self) }

  func formatter(timeZone: TimeZone? = nil) -> DateFormatter {
    DateFormatter.iso8601(format: rawValue, timeZone: timeZone ?? (isUTC ? .UTC : nil))
  }

  func string(from date: Date) -> String { formatter().string(from: date) }
  func string(from date: Date, timeZone: TimeZone) -> String { formatter(timeZone: timeZone).string(from: date) }

  func date(from string: String) -> Date? { formatter().date(from: string) }
  func date(from string: String, timeZone: TimeZone) -> Date? { formatter(timeZone: timeZone).date(from: string) }

  static func date(from string: String) -> Date? {
    dateTime.date(from: string) ?? dateTimeFull.date(from: string) ?? dateOnly.date(from: string)
  }

  var currentString: String { string(from: Date()) }
  func currentString(timeZone: TimeZone) -> String { string(from: Date(), timeZone: timeZone) }
}
