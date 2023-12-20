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
    get { constant * mainScreenScale }
    set { constant = Double(newValue).pixelValue }
  }

  #if os(iOS)
    @IBInspectable var smallPhoneConstant: CGFloat {
      get { constant }
      set { if isSmallPhone { constant = newValue } }
    }

    @IBInspectable var normalPhoneConstant: CGFloat {
      get { constant }
      set { if isNormalPhone { constant = newValue } }
    }

    @IBInspectable var largePhoneConstant: CGFloat {
      get { constant }
      set { if isLargePhone { constant = newValue } }
    }

    @IBInspectable var tallPhoneConstant: CGFloat {
      get { constant }
      set { if isTallPhone { constant = newValue } }
    }

    @IBInspectable var normalTallPhoneConstant: CGFloat {
      get { constant }
      set { if isNormalTallPhone { constant = newValue } }
    }

    @IBInspectable var normalShortPhoneConstant: CGFloat {
      get { constant }
      set { if isNormalShortPhone { constant = newValue } }
    }

    @IBInspectable var largeTallPhoneConstant: CGFloat {
      get { constant }
      set { if isLargeTallPhone { constant = newValue } }
    }

    @IBInspectable var largeShortPhoneConstant: CGFloat {
      get { constant }
      set { if isLargeShortPhone { constant = newValue } }
    }

    @IBInspectable var iPadConstant: CGFloat {
      get { constant }
      set { if isIpad { constant = newValue } }
    }

    @IBInspectable var iPadMiniConstant: CGFloat {
      get { constant }
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
