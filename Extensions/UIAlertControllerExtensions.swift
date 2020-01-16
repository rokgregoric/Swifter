//
//  UIAlertControllerExtensions.swift
//
//  Created by Rok Gregorič
//  Copyright © 2018 Rok Gregorič. All rights reserved.
//

import UIKit

extension UIAlertController {
  static func show(error: Error, completion: (() -> Void)? = nil) {
    show(title: "Error", message: error.localizedDescription, completion: completion)
  }

  static func show(title: String? = nil, message: String? = nil, completion: (() -> Void)? = nil) {
    let vc = UIAlertController(title: title, message: message, preferredStyle: .alert)
    vc.addAction(UIAlertAction(title: "OK", style: .cancel) { _ in completion?() })
    UIViewController.rootVC?.present(vc, animated: true)
  }

  static func show(title: String? = nil, message: String? = nil, cancel: (() -> Void)? = nil, accept: (() -> Void)? = nil) {
    let vc = UIAlertController(title: title, message: message, preferredStyle: .alert)
    vc.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in cancel?() })
    vc.addAction(UIAlertAction(title: "Continue", style: .default) { _ in accept?() })
    UIViewController.rootVC?.present(vc, animated: true)
  }

  func addTextField(text: String? = nil, placeholder: String? = nil, keyboardType: UIKeyboardType = .default, borderStyle: UITextField.BorderStyle = .none) {
    addTextField {
      $0.text = text
      $0.placeholder = placeholder
      $0.keyboardType = keyboardType
      if UIDevice.current.systemVersion.float < 13 { $0.borderStyle = borderStyle }
    }
  }

  func fixTextFieldsRoundedBorders() {
    if UIDevice.current.systemVersion.float >= 13 { return }
    for textField in textFields ?? [] {
      if let container = textField.superview, let effectView = container.superview?.subviews.first, effectView is UIVisualEffectView {
        container.backgroundColor = .clear
        effectView.removeFromSuperview()
      }
    }
  }

  func text(at index: Int) -> String? {
    return textFields?.object(at: index)?.text
  }
}

extension UIAlertController.Style {
  static var auto: UIAlertController.Style {
    return UIDevice.current.userInterfaceIdiom == .pad ? .alert : .actionSheet
  }
}
