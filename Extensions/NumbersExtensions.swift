//
//  NumbersExtension.swift
//
//  Created by Rok Gregorič
//  Copyright © 2018 Rok Gregorič. All rights reserved.
//

import UIKit
import CoreGraphics

func clamp<T: Comparable>(_ value: T, min lo: T, max hi: T) -> T {
  return min(max(lo, value), hi)
}

let mainScreenScale = UIScreen.main.scale // read UIScreen.mainScreen().scale only once since is expensive and impacts scrolling performance

extension Double {
  var pixelValue: CGFloat {
    return CGFloat(self) / mainScreenScale
  }

  func formatted(to decimals: Int) -> String {
    return String(format: "%.\(decimals)f", self)
  }


  func rounded(to decimals: Int) -> Double {
    let divisor = pow(10, decimals).doubleValue
    return (self * divisor).rounded()/divisor
  }
}

extension CGFloat {
  var pixelRounded: CGFloat {
    return (self * mainScreenScale).rounded() / mainScreenScale
  }

  func formatted(to decimals: Int) -> String {
    return String(format: "%.\(decimals)f", self)
  }
}

extension NSNumber {
  var cgfloat: CGFloat {
    return CGFloat(truncating: self)
  }
}

extension TimeInterval {
  static var since1970: TimeInterval {
    return Date().timeIntervalSince1970
  }
}

extension Int {
  /// Range - 0 ..< n
  var range: CountableRange<Int> {
    return 0..<self
  }

  /// Repeat n-times - no parameter
  func times(_ block: () -> Void) {
    range.forEach { _ in block() }
  }

  /// Repeat n-times - index as parameter
  func forEach(_ block: (Int) -> Void) {
    range.forEach(block)
  }

  /// Return array with n elements - no parameter
  func maps<T>(_ block: () -> T) -> [T] {
    return range.map { _ in block() }
  }

  /// Return array with n elements - index as parameter
  func map<T>(_ block: (Int) -> T) -> [T] {
    return range.map(block)
  }

  var string: String {
    return "\(self)"
  }
}

extension Bool {
  var int: Int {
    return self ? 1 : 0
  }

  var cgfloat: CGFloat {
    return CGFloat(int)
  }
}

private func formatter() -> NumberFormatter {
  let formatter = NumberFormatter()
  formatter.numberStyle = .decimal
  formatter.maximumFractionDigits = 2
  formatter.minimumFractionDigits = 2
  return formatter
}

extension Decimal {
  public func stringValue() -> String? {
    return formatter().string(for: self)
  }

  public init?(fromString: String) {
    let separator = Locale.current.decimalSeparator ?? "."
    if let value = formatter().number(from: fromString.replace(".", with: separator))?.decimalValue {
      self = value
    } else {
      return nil
    }
  }

  var decimalNumber: NSDecimalNumber {
    return self as NSDecimalNumber
  }

  var doubleValue: Double {
    return decimalNumber.doubleValue
  }
}

func < <T: Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
    case let (l?, r?): return l < r
    case (nil, _?): return true
    default: return false
  }
}

func <= <T: Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
    case let (l?, r?): return l <= r
    case (nil, _?): return true
    default: return false
  }
}

func > <T: Comparable>(lhs: T?, rhs: T?) -> Bool {
  return rhs < lhs
}

func >= <T: Comparable>(lhs: T?, rhs: T?) -> Bool {
  return rhs <= lhs
}
