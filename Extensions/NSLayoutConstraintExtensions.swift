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
  
  @IBInspectable var iPhoneXConstant: CGFloat {
    get { return constant }
    set { if isIphoneX { constant = newValue } }
  }

  @IBInspectable var iPhoneSEConstant: CGFloat {
    get { return constant }
    set { if isIphoneSE { constant = newValue } }
  }
}
