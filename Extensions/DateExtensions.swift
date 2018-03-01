//
//  DateExtensions.swift
//
//  Created by Rok Gregoric on 20/03/2018.
//  Copyright © 2018 Riley Inc. All rights reserved.
//

import Foundation

extension Date {
  func adding(days: Int) -> Date {
    return adding(days: Double(days))
  }
  
  func adding(days: Double) -> Date {
    return addingTimeInterval(3600*24*days)
  }
}
