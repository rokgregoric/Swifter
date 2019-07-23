//
//  DateFormatterExtensions.swift
//
//  Created by Rok Gregorič
//  Copyright © 2018 Rok Gregorič. All rights reserved.
//

import Foundation

extension DateFormatter {
  convenience init(timeZone: TimeZone? = nil, timeZoneID: String? = nil) {
    self.init()
    (timeZone ?? timeZoneID.flatMap(TimeZone.init(identifier:))).map { self.timeZone = $0 }
  }

  convenience init(format: String, timeZone: TimeZone? = nil, timeZoneID: String? = nil) {
    self.init(timeZone: timeZone, timeZoneID: timeZoneID)
    dateFormat = format
  }

  convenience init(dateStyle: Style = .none, timeStyle: Style = .none, relative: Bool = false, timeZone: TimeZone? = nil, timeZoneID: String? = nil) {
    self.init(timeZone: timeZone, timeZoneID: timeZoneID)
    self.dateStyle = dateStyle
    self.timeStyle = timeStyle
    doesRelativeDateFormatting = relative
  }

  public static func iso8601(format: String) -> DateFormatter {
    let formatter = DateFormatter(format: format, timeZone: .UTC)
    formatter.calendar = Calendar(identifier: .iso8601)
    formatter.locale = Locale(identifier: "en_US_POSIX")
    return formatter
  }

  public static var iso8601full: DateFormatter {
    return iso8601(format: DateFormat.dateTimeFull.rawValue)
  }

  public static var iso8601: DateFormatter {
    return iso8601(format: DateFormat.dateTime.rawValue)
  }

  func string(if date: Date?) -> String? {
    return date.map(string(from:))
  }
}

// MARK: -

extension TimeZone {
  static var UTC: TimeZone {
    return TimeZone(secondsFromGMT: 0)!
  }
}
