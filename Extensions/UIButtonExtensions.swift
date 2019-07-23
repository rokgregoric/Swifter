//
//  UIButtonExtensions.swift
//
//  Created by Rok Gregorič
//  Copyright © 2018 Rok Gregorič. All rights reserved.
//

import UIKit

extension UIButton {
  var title: String? {
    get { return title(for: .normal) }
    set { setTitle(newValue, for: .normal) }
  }

  var attributedTitle: NSAttributedString? {
    get { return attributedTitle(for: .normal) }
    set { setAttributedTitle(newValue, for: .normal) }
  }

  var image: UIImage? {
    get { return image(for: .normal) }
    set { setImage(newValue, for: .normal) }
  }

  var titleColor: UIColor? {
    get { return titleColor(for: .normal) }
    set { setTitleColor(newValue, for: .normal) }
  }
}
