//
//  UITextFieldExtensions.swift
//
//  Created by Rok Gregorič
//  Copyright © 2018 Rok Gregorič. All rights reserved.
//

import UIKit

extension UITextField {
  @IBInspectable var assistantItemHidden: Bool {
    get { false }
    set {
      guard newValue else { return }
      inputAssistantItem.leadingBarButtonGroups = []
      inputAssistantItem.trailingBarButtonGroups = []
    }
  }

  @IBInspectable var leftImage: UIImage? {
    get { nil }
    set {
      let iv = UIImageView(image: newValue)
      iv.contentMode = .center
      leftView = iv
      leftViewMode = .always
    }
  }
}

extension UITextView {
  @IBInspectable var assistantItemHidden: Bool {
    get { false }
    set {
      guard newValue else { return }
      inputAssistantItem.leadingBarButtonGroups = []
      inputAssistantItem.trailingBarButtonGroups = []
    }
  }
}
