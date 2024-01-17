//
//  ColorExtensions.swift
//
//  Created by Rok Gregorič
//  Copyright © 2018 Rok Gregorič. All rights reserved.
//

import CoreGraphics

extension XColor {
  convenience init(red: Int, green: Int, blue: Int) {
    let newRed = CGFloat(red) / 255
    let newGreen = CGFloat(green) / 255
    let newBlue = CGFloat(blue) / 255

    self.init(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
  }

  convenience init(hex: Int) {
    self.init(red: (hex >> 16) & 0xFF, green: (hex >> 8) & 0xFF, blue: hex & 0xFF)
  }

  convenience init?(hexString: String) {
    if let hex = Int(hexString.remove("#"), radix: 16) {
      self.init(hex: hex)
    } else {
      return nil
    }
  }

  static var random: XColor {
    XColor(red: .random(in: 0 ... 1), green: .random(in: 0 ... 1), blue: .random(in: 0 ... 1))
  }

  var hex: Int {
    var r: CGFloat = 0
    var g: CGFloat = 0
    var b: CGFloat = 0
    var a: CGFloat = 0

    #if os(iOS)
      getRed(&r, green: &g, blue: &b, alpha: &a)
    #elseif os(OSX)
      usingColorSpace(.extendedSRGB)?.getRed(&r, green: &g, blue: &b, alpha: &a)
    #endif

    let ri = Int(r * 0xFF) << 16
    let gi = Int(g * 0xFF) << 8
    let bi = Int(b * 0xFF) << 0

    return ri | gi | bi
  }

  var hexString: String {
    String(format: "#%06x", hex)
  }

  static let brightnessAmount: CGFloat = 0.25

  func lighter(_ amount: CGFloat = brightnessAmount) -> XColor {
    color(brightness: 1 + amount)
  }

  func darker(_ amount: CGFloat = brightnessAmount) -> XColor {
    color(brightness: 1 - amount)
  }

  func color(hue: CGFloat = 1, saturation: CGFloat = 1, brightness: CGFloat = 1, alpha: CGFloat = 1) -> XColor {
    var h: CGFloat = 0
    var s: CGFloat = 0
    var b: CGFloat = 0
    var a: CGFloat = 0

    #if os(iOS)
      if getHue(&h, saturation: &s, brightness: &b, alpha: &a) {
        return XColor(hue: h * hue, saturation: s * saturation, brightness: b * brightness, alpha: a * alpha)
      } else {
        return self
      }
    #elseif os(OSX)
      usingColorSpace(.sRGB)?.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
      return XColor(hue: h * hue, saturation: s * saturation, brightness: b * brightness, alpha: a * alpha)
    #endif
  }

  var isLight: Bool {
    let components = cgColor.components ?? [0, 0, 0]
    let brightness = ((components[0] * 299) + (components[1] * 587) + (components[2] * 114)) / 500
    return brightness >= 1
  }
}
