//
//  UIColorExtensions.swift
//
//  Created by Rok Gregorič
//  Copyright © 2018 Rok Gregorič. All rights reserved.
//

import UIKit

extension UIColor {
  convenience init(red: Int, green: Int, blue: Int) {
    let newRed = CGFloat(red)/255
    let newGreen = CGFloat(green)/255
    let newBlue = CGFloat(blue)/255

    self.init(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
  }

  convenience init(hex: Int) {
    self.init(red:(hex >> 16) & 0xff, green:(hex >> 8) & 0xff, blue:hex & 0xff)
  }

  convenience init?(hexString: String) {
    if let hex = Int(hexString.remove("#"), radix: 16) {
      self.init(hex: hex)
    } else {
      return nil
    }
  }

  static var random: UIColor {
    return UIColor(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1))
  }

  var hex: Int {
    var r: CGFloat = 0
    var g: CGFloat = 0
    var b: CGFloat = 0
    var a: CGFloat = 0

    getRed(&r, green: &g, blue: &b, alpha: &a)

    let ri = Int(r*0xff)<<16
    let gi = Int(g*0xff)<<8
    let bi = Int(b*0xff)<<0

    return ri | gi | bi
  }

  var hexString: String {
    return String(format:"#%06x", hex)
  }

  static let colorChangeAmount: CGFloat = 0.25

  func lighter(_ amount: CGFloat = colorChangeAmount) -> UIColor {
    return colorWithBrightnessAmount(1 + amount)
  }

  func darker(_ amount: CGFloat = colorChangeAmount) -> UIColor {
    return colorWithBrightnessAmount(1 - amount)
  }

  func colorWithBrightnessAmount(_ amount: CGFloat) -> UIColor {
    var hue: CGFloat = 0
    var saturation: CGFloat = 0
    var brightness: CGFloat = 0
    var alpha: CGFloat = 0

    if getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
      return UIColor(hue: hue, saturation: saturation, brightness: brightness * amount, alpha: alpha)
    } else {
      return self
    }
  }

  var isLight: Bool {
    let components = cgColor.components ?? [0, 0, 0]
    let brightness = ((components[0] * 299) + (components[1] * 587) + (components[2] * 114)) / 500
    return brightness >= 1
  }
}
