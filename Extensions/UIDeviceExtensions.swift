//
//  UIDeviceExtensions.swift
//
//  Created by Rok Gregorič
//  Copyright © 2018 Rok Gregorič. All rights reserved.
//

import UIKit

extension UIDevice {
  var sysVersion: Float {
    let arr = systemVersion.components(separatedBy: ".")
    let major = arr.object(at: 0).flatMap(Int.init) ?? 0
    let minor = arr.object(at: 1).flatMap(Int.init) ?? 0
    let str = String(format: "%d.%d", major, minor)
    return Float(str) ?? 0
  }
}
