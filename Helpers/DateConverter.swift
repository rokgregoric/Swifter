//
//  DateConverter.swift
//
//  Created by Rok Gregorič
//  Copyright © 2018 Rok Gregorič. All rights reserved.
//

import Foundation

enum DateConverter: String {
  case dateTime = "yyyy-MM-dd'T'HH:mm:ssZ"
  case dateTimeMili = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
  case dateOnly = "yyyy-MM-dd"

  fileprivate var formatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateFormat = rawValue
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
    return dateTime.date(from: string) ?? dateTimeMili.date(from: string) ?? dateOnly.date(from: string)
  }
}
