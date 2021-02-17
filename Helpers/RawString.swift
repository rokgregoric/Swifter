//
//  RawString.swift
//
//  Created by Rok Gregorič
//  Copyright © 2018 Rok Gregorič. All rights reserved.
//

import Foundation

struct RawString {
  let rawValue: String

  init(_ value: String) {
    rawValue = value
  }
}

// MARK: Equatable

func ==(lhs: RawString, rhs: RawString) -> Bool {
  return lhs.rawValue == rhs.rawValue
}


//extension Notification.Name {
//  static let loggedIn = Notification.Name("loggedIn")
//}
//
//extension UIStoryboard.Name {
//  static let main = UIStoryboard.Name("Main")
//}
//
//extension Defaults.Key {
//  static let loggedIn = Defaults.Key("loggedIn")
//}
