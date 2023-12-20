//
//  UIButtonExtensions.swift
//
//  Created by Rok Gregorič
//  Copyright © 2018 Rok Gregorič. All rights reserved.
//

import UIKit

extension UIButton {
  var title: String? {
    get { title(for: .normal) }
    set { setTitle(newValue, for: .normal) }
  }

  var attributedTitle: NSAttributedString? {
    get { attributedTitle(for: .normal) }
    set { setAttributedTitle(newValue, for: .normal) }
  }

  var image: UIImage? {
    get { image(for: .normal) }
    set { setImage(newValue, for: .normal) }
  }

  var backgroundImage: UIImage? {
    get { backgroundImage(for: .normal) }
    set { setBackgroundImage(newValue, for: .normal) }
  }

  var titleColor: UIColor? {
    get { titleColor(for: .normal) }
    set { setTitleColor(newValue, for: .normal) }
  }
}
