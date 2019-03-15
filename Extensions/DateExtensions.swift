//
//  DateExtensions.swift
//
//  Created by Rok Gregorič
//  Copyright © 2018 Rok Gregorič. All rights reserved.
//

import Foundation

fileprivate var formatter: DateComponentsFormatter = {
  let formatter = DateComponentsFormatter()
  formatter.unitsStyle = .full
  formatter.maximumUnitCount = 1
  formatter.allowedUnits = [.year, .month, .day, .hour, .minute, .second]
  return formatter
}()

extension Date {
  func adding(days: Int) -> Date {
    return adding(days: Double(days))
  }

  func adding(days: Double) -> Date {
    return addingTimeInterval(3600*24*days)
  }

  var isToday: Bool {
    return Calendar.current.isDateInToday(self)
  }

  var isYesterday: Bool {
    return Calendar.current.isDateInYesterday(self)
  }

  var isTomorrow: Bool {
    return Calendar.current.isDateInTomorrow(self)
  }

  var isInLast7days: Bool {
    return Calendar.current.startOfDay(for: Date().adding(days: -7)) < self
  }

  var relativeString: String? {
    return formatter.string(from: self, to: Date()).map { "\($0) ago" }?.localized
  }
}
