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

  func scrollToTop(animated: Bool) {
    return scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: animated)
  }

  @IBInspectable var topContentInset: CGFloat {
    get { return contentInset.top }
    set { contentInset.top = newValue }
  }

  @IBInspectable var bottomContentInset: CGFloat {
    get { return contentInset.bottom }
    set { contentInset.bottom = newValue }
  }

  @IBInspectable var leftContentInset: CGFloat {
    get { return contentInset.left }
    set { contentInset.left = newValue }
  }

  @IBInspectable var rightContentInset: CGFloat {
    get { return contentInset.right }
    set { contentInset.right = newValue }
  }
}
