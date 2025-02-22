//
//  NumbersExtensions.swift
//
//  Created by Rok Gregorič
//  Copyright © 2018 Rok Gregorič. All rights reserved.
//

import CoreGraphics
import Foundation

func clamp<T: Comparable>(_ value: T, min lo: T, max hi: T) -> T { min(max(lo, value), hi) }

extension Double {
  var int: Int { Int(self) }
  var cgfloat: CGFloat { CGFloat(self) }

  func rounded(to decimals: Int) -> Double {
    let divisor = pow(10, decimals.double)
    return (self * divisor).rounded() / divisor
  }

  var ns: NSNumber { self as NSNumber }
}

extension CGFloat {
  var int: Int { Int(self) }

  func rounded(to decimals: Int) -> CGFloat {
    let divisor = pow(10, CGFloat(decimals))
    return (self * divisor).rounded() / divisor
  }

  var radians: CGFloat { self * (.pi / 180) }
}

extension NSNumber {
  var cgfloat: CGFloat { CGFloat(truncating: self) }
}

extension TimeInterval {
  static var since1970: TimeInterval { Date().timeIntervalSince1970 }
}

extension Int {
  /// Range - 0 ..< n
  var range: CountableRange<Int> { 0 ..< self }

  /// Repeat n-times - no parameter
  func times(_ block: () -> Void) { range.forEach { _ in block() } }

  /// Repeat n-times - index as parameter
  func forEach(_ block: (Int) -> Void) { range.forEach(block) }

  /// Return array with n elements - no parameter
  func maps<T>(_ block: () -> T) -> [T] { range.map { _ in block() } }

  /// Return array with n elements - index as parameter
  func map<T>(_ block: (Int) -> T) -> [T] { range.map(block) }

  func modded(mod: Int) -> Self {
    let i = self % mod
    return i < 0 ? i + mod : i
  }
}

extension Bool {
  var int: Int { self ? 1 : 0 }
  var not: Bool { !self }
  var cgfloat: CGFloat { int.cgfloat }
  var debug: String { self == true ? "🟢" : "🔴" }
}

extension Bool? {
  var debug: String { val?.debug ?? "🟡" }
}

private func formatter() -> NumberFormatter {
  let formatter = NumberFormatter()
  formatter.numberStyle = .decimal
  formatter.maximumFractionDigits = 2
  formatter.minimumFractionDigits = 2
  return formatter
}

let decimalSeparator = Locale.current.decimalSeparator ?? "."
let groupingSeparator = Locale.current.groupingSeparator ?? ","
let currencySymbol = Locale.current.currencySymbol ?? "$"

extension Decimal {
  func string() -> String? { formatter().string(for: self) }

  init?(fromString: String) {
    if let value = formatter().number(from: fromString.replace(".", with: decimalSeparator))?.decimalValue {
      self = value
    } else {
      return nil
    }
  }

  var decimalNumber: NSDecimalNumber { self as NSDecimalNumber }
  var doubleValue: Double { decimalNumber.doubleValue }
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

func > <T: Comparable>(lhs: T?, rhs: T?) -> Bool { rhs < lhs }

func >= <T: Comparable>(lhs: T?, rhs: T?) -> Bool { rhs <= lhs }

extension BinaryInteger {
  var bool: Bool { self != 0 }
  var string: String { "\(self)" }
  var double: Double { Double(self) }
  var cgfloat: CGFloat { CGFloat(self) }
}

extension FloatingPoint {
  func formatted(to decimals: Int) -> String { String(format: "%.\(decimals)f", self as! CVarArg) }
  var safe: Self { isInfinite || isNaN ? 0 : self }
}

extension Numeric where Self: Comparable {
  var plural: String { self == 1 ? "" : "s" }
}
