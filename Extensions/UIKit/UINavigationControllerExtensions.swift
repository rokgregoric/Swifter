//
//  UINavigationControllerExtensions.swift
//
//  Created by Rok Gregorič
//  Copyright © 2018 Rok Gregorič. All rights reserved.
//

import UIKit

extension UINavigationController {
  func setInteractivePopGestureRecognizer(enabled: Bool) {
    if isNavigationBarHidden || navigationBar.isHidden {
      isNavigationBarHidden = !enabled
      navigationBar.isHidden = true
    }
  }
}
