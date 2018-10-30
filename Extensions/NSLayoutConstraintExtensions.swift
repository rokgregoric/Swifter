//
//  NSLayoutConstraintExtensions.swift
//
//  Created by Rok Gregorič
//  Copyright © 2018 Rok Gregorič. All rights reserved.
//

import UIKit

extension NSLayoutConstraint {
  @IBInspectable var pixelValue: CGFloat {
    get { return constant * mainScreenScale }
    set { constant = Double(newValue).pixelValue }
  }

  @IBInspectable var iPhoneSEConstant: CGFloat {
    get { return constant }
    set { if isIphoneSE { constant = newValue } }
  }

  @IBInspectable var nonPlusConstant: CGFloat {
    get { return constant }
    set { if isNonPlusPhone { constant = newValue } }
  }

  @IBInspectable var plusConstant: CGFloat {
    get { return constant }
    set { if isPlusPhone { constant = newValue } }
  }

  @IBInspectable var iPhoneXConstant: CGFloat {
    get { return constant }
    set { if isIphoneX { constant = newValue } }
  }
}
