//
//  NSLayoutConstraintExtensions.swift
//
//  Created by Rok Gregorič
//  Copyright © 2018 Rok Gregorič. All rights reserved.
//

#if os(iOS)
import UIKit
#endif

extension NSLayoutConstraint {
  @IBInspectable var pixelValue: CGFloat {
    get { return constant * mainScreenScale }
    set { constant = Double(newValue).pixelValue }
  }

#if os(iOS)
  @IBInspectable var smallPhoneConstant: CGFloat {
    get { return constant }
    set { if isSmallPhone { constant = newValue } }
  }

  @IBInspectable var normalPhoneConstant: CGFloat {
    get { return constant }
    set { if isNormalPhone { constant = newValue } }
  }

  @IBInspectable var largePhoneConstant: CGFloat {
    get { return constant }
    set { if isLargePhone { constant = newValue } }
  }

  @IBInspectable var tallPhoneConstant: CGFloat {
    get { return constant }
    set { if isTallPhone { constant = newValue } }
  }

  @IBInspectable var normalTallPhoneConstant: CGFloat {
    get { return constant }
    set { if isNormalTallPhone { constant = newValue } }
  }

  @IBInspectable var normalShortPhoneConstant: CGFloat {
    get { return constant }
    set { if isNormalShortPhone { constant = newValue } }
  }

  @IBInspectable var largeTallPhoneConstant: CGFloat {
    get { return constant }
    set { if isLargeTallPhone { constant = newValue } }
  }

  @IBInspectable var largeShortPhoneConstant: CGFloat {
    get { return constant }
    set { if isLargeShortPhone { constant = newValue } }
  }

  @IBInspectable var iPadConstant: CGFloat {
    get { return constant }
    set { if isIpad { constant = newValue } }
  }

  @IBInspectable var iPadMiniConstant: CGFloat {
    get { return constant }
    set { if isIpadMini { constant = newValue } }
  }
#endif

  @discardableResult
  func activate(priority: XLayoutPriority? = nil) -> Self {
    priority.map { self.priority = $0 }
    isActive = true
    return self
  }

  @discardableResult
  func deactivate() -> Self {
    isActive = false
    return self
  }
}
