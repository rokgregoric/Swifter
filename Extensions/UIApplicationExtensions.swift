//
//  UIApplicationExtensions.swift
//
//  Created by Rok Gregoric on 16/12/2019.
//  Copyright © 2019 Rok Gregoric. All rights reserved.
//

import UIKit

extension UIApplication {
  // https://rambo.codes/ios/quick-tip/2019/12/09/clearing-your-apps-launch-screen-cache-on-ios.html
  func clearLaunchScreenCache() {
    do {
      try FileManager.default.removeItem(atPath: NSHomeDirectory()+"/Library/SplashBoard")
    } catch {
      print("Failed to delete launch screen cache: \(error)")
    }
  }
}
