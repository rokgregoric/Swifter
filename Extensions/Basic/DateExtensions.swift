//
//  DateExtensions.swift
//
//  Created by Rok Gregorič
//  Copyright © 2018 Rok Gregorič. All rights reserved.
//

import Foundation

private var componentsFormatter: DateComponentsFormatter = {
  let formatter = DateComponentsFormatter()
  formatter.unitsStyle = .full
  formatter.maximumUnitCount = 1
  formatter.allowedUnits = [.year, .month, .day, .hour, .minute, .second]
  return formatter
}()

extension Date {
  func adding(days: Int) -> Date { adding(days: Double(days)) }

  func adding(days: Double) -> Date { addingTimeInterval(3600 * 24 * days) }

  var isToday: Bool { Calendar.current.isDateInToday(self) }

  var isYesterday: Bool { Calendar.current.isDateInYesterday(self) }

  var isTomorrow: Bool { Calendar.current.isDateInTomorrow(self) }

  var isWeekend: Bool { Calendar.current.isDateInWeekend(self) }

  var startOfDay: Date { Calendar.current.startOfDay(for: self) }

  var isInLast7days: Bool { Date().adding(days: -7).startOfDay < self }

  var relativeString: String? {
    if self < Date() { return componentsFormatter.string(from: self, to: Date()) }
    return componentsFormatter.string(from: Date(), to: self)
  }

  var longRelativeString: String? {
    relativeString.map { self < Date() ? "\($0) ago" : "in \($0)" }?.localized
  }

  @available(iOS 10.0, *)
  func iso8601string(timeZone: TimeZone = .UTC) -> String {
    ISO8601DateFormatter.string(from: self, timeZone: timeZone, formatOptions: .withInternetDateTime)
  }

  var timeIntervalTillNow: TimeInterval { -timeIntervalSinceNow }
}
