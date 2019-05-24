//
//  UINavigationControllerExtensions.swift
//
//  Created by Rok Gregoric on 24/05/2019.
//  Copyright © 2019 Rok Gregoric. All rights reserved.
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
