//
//  NotificationExtensions.swift
//
//  Created by Rok Gregorič
//  Copyright © 2018 Rok Gregorič. All rights reserved.
//

import Foundation

extension Notification {
  static func post(_ name: Name, object: Any? = nil, info: [AnyHashable: Any]? = nil) {
    NotificationCenter.default.post(name: name, object: object, userInfo: info)
  }

  static func observe(_ name: Name, observer: Any, selector: Selector, object: Any? = nil) {
    stopObserving(name, observer: observer)
    NotificationCenter.default.addObserver(observer, selector: selector, name: name, object: object)
  }

  @discardableResult
  static func observe(_ name: Name, object: Any? = nil, queue: OperationQueue? = .main, using: @escaping Block1<Notification>) -> NSObjectProtocol {
    NotificationCenter.default.addObserver(forName: name, object: object, queue: queue, using: using)
  }

  static func stopObserving(_ name: Name, observer: Any, object: Any? = nil) {
    NotificationCenter.default.removeObserver(observer, name: name, object: object)
  }

  static func remove(observer: Any) {
    NotificationCenter.default.removeObserver(observer)
  }
}

// MARK: - Keyboard support

#if os(iOS)

  import UIKit

  extension Notification {
    var keyboardFrame: CGRect? {
      (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
    }

    var animationDuration: Double? {
      userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
    }

    var animationCurve: UInt? {
      userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt
    }

    var animationOptions: UIView.AnimationOptions? {
      animationCurve.map { .init(rawValue: $0 << 16) }
    }

    func animate(_ animations: @escaping () -> Void) {
      guard let animationDuration, let animationOptions else { return animations() }
      UIView.animate(duration: animationDuration, options: animationOptions, animations)
    }
  }

#endif
