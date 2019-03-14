//
//  UIScrollViewExtensions.swift
//
//  Created by Rok Gregorič
//  Copyright © 2018 Rok Gregorič. All rights reserved.
//

import UIKit

extension UIScrollView {
  var isTouchDriven: Bool {
    return isTracking || isDragging || isDecelerating
  }
}
