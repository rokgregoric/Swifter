//
//  UIScrollViewExtensions.swift
//
//  Created by Rok Gregorič
//  Copyright © 2018 Rok Gregorič. All rights reserved.
//

import UIKit

extension UIScrollView {
  var isTouchDriven: Bool {
    isTracking || isDragging || isDecelerating
  }

  func scrollToTop(animated: Bool) {
    scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: animated)
  }

  @IBInspectable var topContentInset: CGFloat {
    get { contentInset.top }
    set { contentInset.top = newValue }
  }

  @IBInspectable var bottomContentInset: CGFloat {
    get { contentInset.bottom }
    set { contentInset.bottom = newValue }
  }

  @IBInspectable var leftContentInset: CGFloat {
    get { contentInset.left }
    set { contentInset.left = newValue }
  }

  @IBInspectable var rightContentInset: CGFloat {
    get { contentInset.right }
    set { contentInset.right = newValue }
  }
}
