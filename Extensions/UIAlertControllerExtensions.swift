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

  static func show(title: String? = nil, message: String? = nil, buttonTitle: String = "OK", completion: (() -> Void)? = nil) {
    let vc = UIAlertController(title: title, message: message, preferredStyle: .alert)
    vc.addAction(UIAlertAction(title: buttonTitle, style: .cancel) { _ in completion?() })
    UIViewController.rootVC?.present(vc, animated: true)
  }

  static func show(title: String? = nil, message: String? = nil, acceptTitle: String = "Continue", acceptStyle: UIAlertAction.Style = .default, cancelTitle: String = "Cancel", preferAccept: Bool = false, cancel: (() -> Void)? = nil, accept: (() -> Void)? = nil) {
    let vc = UIAlertController(title: title, message: message, preferredStyle: .alert)
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
    return textFields?.object(at: index)?.text
  }
}

extension UIAlertController.Style {
  static var auto: UIAlertController.Style {
    return UIDevice.current.userInterfaceIdiom == .pad ? .alert : .actionSheet
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
