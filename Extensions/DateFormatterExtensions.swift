//
//  DateFormatterExtensions.swift
//
//  Created by Rok Gregorič
//  Copyright © 2018 Rok Gregorič. All rights reserved.
//

import Foundation

extension DateFormatter {
  convenience init(format: String) {
    self.init()
    self.dateFormat = format
  }

  convenience init(dateStyle: Style = .none, timeStyle: Style = .none) {
    self.init()
    self.dateStyle = dateStyle
    self.timeStyle = timeStyle
  }

  public static var iso8601: DateFormatter {
    let formatter = DateFormatter(format: "yyy-MM-dd'T'HH:mm:ss.SSSZZZZZ")
    formatter.calendar = Calendar(identifier: .iso8601)
    formatter.locale = Locale.current
    formatter.timeZone = TimeZone.current
    return formatter
  }
}
