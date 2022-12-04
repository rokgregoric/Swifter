//
//  CGPointExtensions.swift
//
//  Created by Rok Gregorič
//  Copyright © 2021 Rok Gregorič. All rights reserved.
//

import CoreGraphics

extension CGPoint {
  func add(point: CGPoint) -> CGPoint {
    CGPoint(x: x + point.x, y: y + point.y)
  }

  func subtract(point: CGPoint) -> CGPoint {
    CGPoint(x: x - point.x, y: y - point.y)
  }

  func divide(by: Int) -> CGPoint {
    let denominator = CGFloat(by)
    return CGPoint(x: x / denominator, y: y / denominator)
  }

  func distance(from point: CGPoint) -> CGFloat {
    hypot(point.x - x, point.y - y)
  }
}

extension Collection where Element == CGPoint {
  func average() -> CGPoint {
    if isEmpty { return .zero }
    return reduce(CGPoint.zero) { $0.add(point: $1) }.divide(by: count)
  }
}
