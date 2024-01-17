//
//  UIAlertControllerExtensions.swift
//
//  Created by Rok Gregorič
//  Copyright © 2018 Rok Gregorič. All rights reserved.
//

import UIKit

extension UIAlertController {
  convenience init(title: String? = nil, message: String? = nil, style: Style = .alert, tint: UIColor? = nil) {
    self.init(title: title, message: message, preferredStyle: style)
    tint.map { view.tintColor = $0 }
  }

  static func show(error: Error, tint _: UIColor? = nil, completion: (() -> Void)? = nil) {
    show(title: "Error", message: error.localizedDescription, completion: completion)
  }

  static func show(title: String? = nil, message: String? = nil, buttonTitle: String = "OK", tint: UIColor? = nil, completion: (() -> Void)? = nil) {
    let vc = UIAlertController(title: title, message: message, tint: tint)
    vc.addAction(UIAlertAction(title: buttonTitle, style: .cancel) { _ in completion?() })
    UIViewController.rootVC?.present(vc, animated: true)
  }

  static func show(title: String? = nil, message: String? = nil, acceptTitle: String = "Continue", acceptStyle: UIAlertAction.Style = .default, cancelTitle: String = "Cancel", preferAccept: Bool = false, tint: UIColor? = nil, cancel: (() -> Void)? = nil, accept: (() -> Void)? = nil) {
    let vc = UIAlertController(title: title, message: message, tint: tint)
    vc.addAction(UIAlertAction(title: cancelTitle, style: .cancel) { _ in cancel?() })
    vc.addAction(UIAlertAction(title: acceptTitle, style: acceptStyle) { _ in accept?() })
    if preferAccept { vc.preferredAction = vc.actions.last }
    UIViewController.rootVC?.present(vc, animated: true)
  }

  func addTextField(text: String? = nil, placeholder: String? = nil, keyboardType: UIKeyboardType? = nil, autocapitalizationType: UITextAutocapitalizationType? = nil, borderStyle: UITextField.BorderStyle = .none) {
    addTextField { field in
      field.text = text
      field.placeholder = placeholder
      keyboardType.map { field.keyboardType = $0 }
      autocapitalizationType.map { field.autocapitalizationType = $0 }
      if UIDevice.current.systemVersion.safeDouble < 13 { field.borderStyle = borderStyle }
    }
  }

  func fixTextFieldsRoundedBorders() {
    if UIDevice.current.systemVersion.safeDouble >= 13 { return }
    for textField in textFields ?? [] {
      if let container = textField.superview, let effectView = container.superview?.subviews.first, effectView is UIVisualEffectView {
        container.backgroundColor = .clear
        effectView.removeFromSuperview()
      }
    }
  }

  func text(at index: Int) -> String? {
    textFields?.object(at: index)?.text
  }
}

extension UIAlertController.Style {
  static var auto: UIAlertController.Style {
    UIDevice.current.userInterfaceIdiom == .pad ? .alert : .actionSheet
  }
}

extension UIAlertAction {
  convenience init(title: String?, style: Style = .default, color: UIColor? = nil, checked: Bool? = nil, handler: (() -> Void)? = nil) {
    self.init(title: title, style: style, handler: { _ in handler?() })
    color.map {
      setValue($0, forKey: "titleTextColor")
      setValue($0, forKey: "imageTintColor")
    }
    checked.map {
      setValue($0, forKey: "checked")
    }
  }
}
