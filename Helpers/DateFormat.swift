//
//  DateFormat.swift
//
//  Created by Rok Gregorič
//  Copyright © 2018 Rok Gregorič. All rights reserved.
//

import Foundation

enum DateFormat: String {
  case dateOnly = "yyyy-MM-dd"
  case dateTime = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
  case dateTimeFull = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"

  fileprivate var formatter: DateFormatter {
    let formatter = DateFormatter(format: rawValue)
    formatter.locale = Locale(identifier: "en_US_POSIX")
    return formatter
  }

  func string(from date: Date) -> String {
    return formatter.string(from: date)
  }

  func date(from string: String) -> Date? {
    return formatter.date(from: string)
  }

  static func date(from string: String) -> Date? {
    return dateTime.date(from: string) ?? dateTimeFull.date(from: string) ?? dateOnly.date(from: string)
  }
}
