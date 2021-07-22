//
//  CGRectExtensions.swift
//
//  Created by Rok Gregorič
//  Copyright © 2021 Rok Gregorič. All rights reserved.
//

import UIKit

extension CGRect {
  func inset(all val: CGFloat) -> CGRect {
    return inset(by: UIEdgeInsets(top: val, left: val, bottom: val, right: val))
  }

  func outset(all val: CGFloat) -> CGRect {
    return inset(all: -val)
  }

  func outset(by insets: UIEdgeInsets) -> CGRect {
    return inset(by: UIEdgeInsets(top: -insets.top, left: -insets.left, bottom: -insets.bottom, right: -insets.right))
  }
}
