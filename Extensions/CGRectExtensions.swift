//
//  CGRectExtensions.swift
//
//  Created by Rok Gregorič
//  Copyright © 2021 Rok Gregorič. All rights reserved.
//

import CoreGraphics

extension CGRect {
  @nonobjc
  var width: CGFloat {
    get { size.width }
    set { size.width = newValue }
  }

  @nonobjc
  var height: CGFloat {
    get { size.height }
    set { size.height = newValue }
  }

  @nonobjc
  var x: CGFloat {
    get { origin.x }
    set { origin.x = newValue }
  }

  @nonobjc
  var y: CGFloat {
    get { origin.y }
    set { origin.y = newValue }
  }

  @nonobjc
  var center: CGPoint {
    get { CGPoint(x: midX, y: midY) }
    set { origin = CGPoint(x: newValue.x - width/2, y: newValue.y - height/2) }
  }

  var rounded: CGRect { .init(x: x.rounded(), y: y.rounded(), width: width.rounded(), height: height.rounded()) }

  func rounded(to decimal: Int) -> CGRect {
    .init(x: x.rounded(to: decimal),
          y: y.rounded(to: decimal),
          width: width.rounded(to: decimal),
          height: height.rounded(to: decimal))
  }

  var maxWH: CGFloat {
    [width, height].max()!
  }

  var area: CGFloat {
    width * height
  }

  func inset(all val: CGFloat) -> CGRect {
    inset(by: EdgeInsets(top: val, left: val, bottom: val, right: val))
  }

  func outset(all val: CGFloat) -> CGRect {
    inset(all: -val)
  }

  func outset(by insets: EdgeInsets) -> CGRect {
    inset(by: EdgeInsets(top: -insets.top, left: -insets.left, bottom: -insets.bottom, right: -insets.right))
  }

  init (points: [CGPoint]) {
    var minX = CGFloat.infinity
    var minY = CGFloat.infinity
    var maxX = CGFloat.zero
    var maxY = CGFloat.zero
    points.forEach {
      if $0.x < minX { minX = $0.x }
      if $0.y < minY { minY = $0.y }
      if $0.x > maxX { maxX = $0.x }
      if $0.y > maxY { maxY = $0.y }
    }
    self.init(x: minX, y: minY, width: maxX - minX, height: maxY - minY)
  }

#if os(OSX)
  func inset(by insets: EdgeInsets) -> CGRect {
    var rect = self
    rect.x += insets.left
    rect.y += insets.top
    rect.width -= insets.left + insets.right
    rect.height -= insets.top + insets.bottom
    return rect
  }
#endif

  static func ~=(lhs: Self, rhs: Self) -> Bool {
    abs(lhs.x - rhs.x) < 1 && abs(lhs.y - rhs.y) < 1 && lhs.size ~= rhs.size
  }

  func resizeKeepingCenter(newSize: CGSize) -> CGRect {
    var newRect = CGRect(origin: .zero, size: newSize)
    newRect.origin.x = origin.x + (width - newSize.width) / 2
    newRect.origin.y = origin.y + (height - newSize.height) / 2
    return newRect
  }
}

extension CGSize {
  var rect: CGRect { CGRect(origin: .zero, size: self) }

  static func ~=(lhs: Self, rhs: Self) -> Bool {
    abs(lhs.width - rhs.width) < 1 && abs(lhs.height - rhs.height) < 1
  }
}

extension Int {
  var size: CGSize { CGSize(width: self, height: self) }
}
