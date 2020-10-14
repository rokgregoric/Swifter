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

let isSmallPhone = mainScreenSize.width < 350 && isIphone
let isNormalPhone = mainScreenSize.width > 350 && mainScreenSize.width < 400  && isIphone
let isLargePhone = mainScreenSize.width > 400 && isIphone
let isTallPhone = mainScreenSize.height > 800 && isIphone

let isNormalShortPhone = isNormalPhone && !isTallPhone // 4.7" - 6, 6s, 7, 8
let isLargeShortPhone = isLargePhone && !isTallPhone // 5.5" - 6+, 6s+, 7+, 8+

let isNormalTallPhone = isNormalPhone && isTallPhone // 5.8" - X, Xs, 11
let isLargeTallPhone = isLargePhone && isTallPhone // 6.1" & 6.5" - Xs-max, Xr, 11-max, 11r

let isIphoneX = isTallPhone // deprecated
let isIphoneSE = isSmallPhone // deprecated
let isNonPlusPhone = isNormalShortPhone // deprecated
let isPlusPhone = isLargeShortPhone // deprecated

var keyWindowSafeAreaInsets: UIEdgeInsets { return UIApplication.shared.keyWindow?.safeAreaInsets ?? .zero }
let isSafeAreaInset = keyWindowSafeAreaInsets != .zero

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
