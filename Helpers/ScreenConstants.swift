//
//  ScreenConstants.swift
//
//  Created by Rok Gregorič
//  Copyright © 2018 Rok Gregorič. All rights reserved.
//

#if os(iOS)

  import UIKit

  let mainScreenScale = UIScreen.main.scale // read only once since is expensive and impacts scrolling performance
  var mainScreenSize: CGSize { isMac ? keyWindow?.frame.size ?? .zero : UIScreen.main.bounds.size }

  #if EXTENSION
    let keyWindow: UIWindow? = nil
    let interfaceOrientation = UIInterfaceOrientation.unknown
  #else
    var keyWindow: UIWindow? {
      if #available(iOS 13.0, *) {
        return (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.keyWindow
      } else {
        return UIApplication.shared.keyWindow
      }
    }

    var interfaceOrientation: UIInterfaceOrientation {
      if #available(iOS 13.0, *) {
        return keyWindow?.windowScene?.interfaceOrientation ?? .unknown
      } else {
        return UIApplication.shared.statusBarOrientation
      }
    }
  #endif

  var isPortrait: Bool { isMac ? false : interfaceOrientation.isPortrait }

  let shorterScreenSide = min(mainScreenSize.width, mainScreenSize.height)
  let longerScreenSide = max(mainScreenSize.width, mainScreenSize.height)

  let isMac = AppEnvironment.isiOSAppOnMac || AppEnvironment.isMacCatalystApp
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

  let isIpadMini = isIpad && shorterScreenSide < 750

  private var _safeAreaInsets: UIEdgeInsets { keyWindow?.safeAreaInsets ?? .zero }
  private var _noTopSafeAreaInsets: UIEdgeInsets {
    var i = _safeAreaInsets
    i.top = 0
    return i
  }

  var keyWindowSafeAreaInsets: UIEdgeInsets { isMac ? _noTopSafeAreaInsets : _safeAreaInsets }
  var isSafeAreaInset: Bool { _noTopSafeAreaInsets != .zero }

#elseif os(OSX)

  import AppKit

  let isMac = true
  let isIpad = false
  let isIphone = false

  var keyWindow: NSWindow? { NSApplication.shared.keyWindow ?? NSApplication.shared.mainWindow }

  var mainScreenScale: CGFloat { keyWindow?.backingScaleFactor ?? 1 }
  var mainScreenSize: CGSize { NSScreen.main?.frame.size ?? .zero }

#endif

extension Double {
  var pixelValue: CGFloat { cgfloat / mainScreenScale }
}

extension CGFloat {
  var pixelRounded: CGFloat { (self * mainScreenScale).rounded() / mainScreenScale }
}
