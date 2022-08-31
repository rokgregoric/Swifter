//
//  NotificationNameExtensions.swift
//
//  Created by Rok Gregorič
//  Copyright © 2021 Rok Gregorič. All rights reserved.
//

import Foundation

extension Notification.Name {
  static let appDidBecomeActive = Application.didBecomeActiveNotification
  static let appWillResignActive = Application.willResignActiveNotification
  static let appWillTerminate = Application.willTerminateNotification
}

#if os(iOS)

import UIKit

extension Notification.Name {

  // Application
  static let appDidEnterBackground = UIApplication.didEnterBackgroundNotification
  static let appWillEnterForeground = UIApplication.willEnterForegroundNotification

  // Keyboard
  static let keyboardWillChangeFrame = UIResponder.keyboardWillChangeFrameNotification

  // Orientation
  static let orientationDidChange = UIDevice.orientationDidChangeNotification
}

#endif
