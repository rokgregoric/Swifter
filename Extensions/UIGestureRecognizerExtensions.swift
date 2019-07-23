//
//  UIGestureRecognizerExtensions.swift
//
//  Created by Rok Gregorič
//  Copyright © 2018 Rok Gregorič. All rights reserved.
//

import UIKit

extension UIGestureRecognizer.State {
  var name: String {
    switch self {
      case .possible: return "possible"
      case .began: return "began"
      case .changed: return "changed"
      case .ended: return "ended"
      case .cancelled: return "cancelled"
      case .failed: return "failed"
      @unknown default: return "unknown"
    }
  }
}
