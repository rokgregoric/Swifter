//
//  Constants.swift
//
//  Created by Rok Gregorič
//  Copyright © 2018 Rok Gregorič. All rights reserved.
//

import UIKit

var mainScreenSize: CGSize { return UIScreen.main.bounds.size }

let isIpad = UIDevice.current.userInterfaceIdiom == .pad
let isIphone = UIDevice.current.userInterfaceIdiom == .phone
let isIphoneX = mainScreenSize.height > 800 && isIphone
let isIphoneSE = mainScreenSize.width == 320 && isIphone
let isNonPlusPhone = mainScreenSize.width == 375 && !isIphoneX
let isPlusPhone = mainScreenSize.width > 400 && !isIphoneX

var keyWindowSafeAreaInsets: UIEdgeInsets { return UIApplication.shared.keyWindow?.safeAreaInsets ?? .zero }
let isSafeAreaInset = keyWindowSafeAreaInsets != .zero

struct RawString {
  let rawValue: String

  init(_ value: String) {
    rawValue = value
  }
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

