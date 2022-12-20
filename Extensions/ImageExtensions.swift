//
//  ImageExtensions.swift
//
//  Created by Rok Gregorič
//  Copyright © 2021 Rok Gregorič. All rights reserved.
//

#if os(iOS)
import UIKit
#endif
import CoreGraphics

extension Image {
#if os(iOS)
  func resize(to size: CGSize) -> Image? {
    let rect = size.rect
    UIGraphicsBeginImageContextWithOptions(size, false, 0)
    draw(in: rect)
    let img = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return img
  }

  func resize(max side: CGFloat) -> Image? {
    let ratio = size.width / size.height
    if ratio > 1 {
      return resize(to: CGSize(width: side, height: side / ratio))
    } else {
      return resize(to: CGSize(width: side * ratio, height: side))
    }
  }

  func tinted(with color: Color) -> Image {
    UIGraphicsImageRenderer(size: size).image { _ in
      color.set()
      withRenderingMode(.alwaysTemplate).draw(in: size.rect)
    }
  }
#endif
}
