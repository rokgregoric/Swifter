//
//  UIImageExtensions.swift
//
//  Created by Rok Gregorič
//  Copyright © 2021 Rok Gregorič. All rights reserved.
//

import UIKit

extension UIImage {
  func resize(to size: CGSize) -> UIImage? {
    let rect = CGRect(origin: .zero, size: size)
    UIGraphicsBeginImageContextWithOptions(size, false, 1)
    draw(in: rect)
    let img = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return img
  }

  func resize(max side: CGFloat) -> UIImage? {
    let ratio = size.width / size.height
    if ratio > 1 {
      return resize(to: CGSize(width: side, height: side / ratio))
    } else {
      return resize(to: CGSize(width: side * ratio, height: side))
    }
  }


  func tinted(with color: UIColor) -> UIImage {
    UIGraphicsImageRenderer(size: size).image { _ in
      color.set()
      withRenderingMode(.alwaysTemplate).draw(in: CGRect(origin: .zero, size: size))
    }
  }
}
