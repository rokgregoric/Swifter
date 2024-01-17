//
//  UIResponderExtensions.swift
//
//  Created by Rok Gregorič
//  Copyright © 2022 Rok Gregorič. All rights reserved.
//

import UIKit

extension UIResponder {
  var parentViewController: UIViewController? {
    next as? UIViewController ?? next?.parentViewController
  }
}
