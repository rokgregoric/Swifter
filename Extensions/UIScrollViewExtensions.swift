//
//  UIScrollViewExtensions.swift
//
//  Created by Rok Gregoric on 02/03/2018.
//  Copyright © 2018 GFA. All rights reserved.
//

import UIKit

extension UIScrollView {
  var isTouchDriven: Bool {
    return isTracking || isDragging || isDecelerating
  }
}
