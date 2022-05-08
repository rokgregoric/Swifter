//
//  NotificationNameExtensions.swift
//
//  Created by Rok Gregorič
//  Copyright © 2021 Rok Gregorič. All rights reserved.
//

import UIKit

extension Notification.Name {

  // Application
  static let appDidEnterBackground = UIApplication.didEnterBackgroundNotification
  static let appWillEnterForeground = UIApplication.willEnterForegroundNotification
  static let appDidBecomeActive = UIApplication.didBecomeActiveNotification
  static let appWillResignActive = UIApplication.willResignActiveNotification
  static let appWillTerminate = UIApplication.willTerminateNotification

  // Keyboard
  static let keyboardWillChangeFrame = UIResponder.keyboardWillChangeFrameNotification

  // Orientation
  static let orientationDidChange = UIDevice.orientationDidChangeNotification
}
