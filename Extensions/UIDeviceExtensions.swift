//
//  UIDeviceExtensions.swift
//
//  Created by Rok Gregorič
//  Copyright © 2018 Rok Gregorič. All rights reserved.
//

import UIKit

extension UIDevice {
  var sysVersion: Float {
    return Float(systemVersion) ?? 0
  }
}
