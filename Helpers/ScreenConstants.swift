//
//  ScreenConstants.swift
//
//  Created by Rok Gregorič
//  Copyright © 2018 Rok Gregorič. All rights reserved.
//

#if os(iOS)

  import UIKit

  // Optionally register the app window before configuring its first root.
  // Without registration, global helpers use a foreground key window.
  // Multi-window views should still use their own window or local geometry.
  weak var sceneWindow: UIWindow?
  var mainScreen: UIScreen? {
    // Retain a fallback for app extensions, previews and legacy app lifecycles.
    keyWindow?.screen ?? UIScreen.main
  }
  var mainScreenScale: CGFloat { mainScreen?.scale ?? 1 }
  var mainScreenSize: CGSize {
    keyWindow?.bounds.size ?? (isMac ? .zero : mainScreen?.bounds.size ?? .zero)
  }

  #if EXTENSION
    let keyWindow: UIWindow? = nil
    let interfaceOrientation = UIInterfaceOrientation.unknown
  #else
    var keyWindow: UIWindow? {
      if let window = sceneWindow { return window }
      if #available(iOS 13.0, *) {
        let scenes = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }
        for state in [UIScene.ActivationState.foregroundActive, .foregroundInactive] {
          if let window = scenes.filter({ $0.activationState == state })
            .flatMap({ $0.windows }).first(where: { $0.isKeyWindow }) {
            return window
          }
        }
        // An app using the older app-delegate lifecycle has no window scene.
        guard scenes.isEmpty else { return nil }
      }
      return UIApplication.shared.keyWindow
    }

    var interfaceOrientation: UIInterfaceOrientation {
      if #available(iOS 13.0, *), let scene = keyWindow?.windowScene {
        return scene.interfaceOrientation
      }
      return UIApplication.shared.statusBarOrientation
    }
  #endif

  var isPortrait: Bool { isMac ? false : interfaceOrientation.isPortrait }

  var shorterScreenSide: CGFloat { min(mainScreenSize.width, mainScreenSize.height) }
  var longerScreenSide: CGFloat { max(mainScreenSize.width, mainScreenSize.height) }

  let isMac = AppEnvironment.isiOSAppOnMac || AppEnvironment.isMacCatalystApp
  let isIpad = UIDevice.current.userInterfaceIdiom == .pad
  let isIphone = UIDevice.current.userInterfaceIdiom == .phone

  var isSmallPhone: Bool { shorterScreenSide < 350 && isIphone }
  var isMiniPhone: Bool { shorterScreenSide > 350 && shorterScreenSide < 390 && isIphone }
  var isNormalPhone: Bool { shorterScreenSide > 350 && shorterScreenSide < 400 && isIphone }
  var isLargePhone: Bool { shorterScreenSide > 400 && isIphone }
  var isTallPhone: Bool { longerScreenSide > 800 && isIphone }

  // SE / mini-sized phones where large fonts overflow fixed layouts
  var isCompactPhone: Bool { (isSmallPhone || isMiniPhone) && isIphone }
  // iOS Display Zoom ("Zoomed") renders fewer points and upscales -> nativeScale > scale
  var isZoomedDisplay: Bool { isIphone && (mainScreen?.nativeScale ?? 1) > mainScreenScale }

  var isNormalShortPhone: Bool { isNormalPhone && !isTallPhone } // 4.7" - 6, 6s, 7, 8
  var isLargeShortPhone: Bool { isLargePhone && !isTallPhone } // 5.5" - 6+, 6s+, 7+, 8+

  var isNormalTallPhone: Bool { isNormalPhone && isTallPhone } // 5.8" - X, Xs, 11
  var isLargeTallPhone: Bool { isLargePhone && isTallPhone } // 6.1" & 6.5" - Xs-max, Xr, 11-max, 11r

  var isWidePad: Bool { shorterScreenSide > 0 && (longerScreenSide / shorterScreenSide > 1.4) && isIpad } // 11" -  non 4:3

  var isIpadMini: Bool { isIpad && shorterScreenSide < 750 }

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
