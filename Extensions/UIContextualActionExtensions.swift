//
//  UIContextualActionExtensions.swift
//
//  Created by Rok Gregorič
//  Copyright © 2021 Rok Gregorič. All rights reserved.
//

import UIKit

extension UIContextualAction {
  convenience init(style: Style = .normal, title: String?, color: UIColor? = nil, handler: @escaping (@escaping ((Bool) -> Void)) -> Void) {
    self.init(style: style, title: title) { _, _, h in handler(h) }
    self.backgroundColor = color
  }
}
