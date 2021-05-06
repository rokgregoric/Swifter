//
//  Constants.swift
//
//  Created by Rok Gregorič
//  Copyright © 2018 Rok Gregorič. All rights reserved.
//

import UIKit

var mainScreenSize: CGSize { return UIScreen.main.bounds.size }

let shorterScreenSide = min(mainScreenSize.width, mainScreenSize.height)
let longerScreenSide = max(mainScreenSize.width, mainScreenSize.height)

let isIpad = UIDevice.current.userInterfaceIdiom == .pad
let isIphone = UIDevice.current.userInterfaceIdiom == .phone

let isSmallPhone = shorterScreenSide < 350 && isIphone
let isNormalPhone = shorterScreenSide > 350 && mainScreenSize.width < 400 && isIphone
let isLargePhone = shorterScreenSide > 400 && isIphone
let isTallPhone = longerScreenSide > 800 && isIphone

let isNormalShortPhone = isNormalPhone && !isTallPhone // 4.7" - 6, 6s, 7, 8
let isLargeShortPhone = isLargePhone && !isTallPhone // 5.5" - 6+, 6s+, 7+, 8+

let isNormalTallPhone = isNormalPhone && isTallPhone // 5.8" - X, Xs, 11
let isLargeTallPhone = isLargePhone && isTallPhone // 6.1" & 6.5" - Xs-max, Xr, 11-max, 11r

let isWidePad = (longerScreenSide / shorterScreenSide > 1.4) && isIpad // 11" -  non 4:3

let isIphoneX = isTallPhone // deprecated
let isIphoneSE = isSmallPhone // deprecated
let isNonPlusPhone = isNormalShortPhone // deprecated
let isPlusPhone = isLargeShortPhone // deprecated

var keyWindowSafeAreaInsets: UIEdgeInsets { return UIApplication.shared.keyWindow?.safeAreaInsets ?? .zero }
let isSafeAreaInset = keyWindowSafeAreaInsets != .zero
