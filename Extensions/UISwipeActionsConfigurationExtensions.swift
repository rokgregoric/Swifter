//
//  UISwipeActionsConfigurationExtensions.swift
//
//  Created by Rok Gregorič
//  Copyright © 2018 Rok Gregorič. All rights reserved.
//

import UIKit

@available(iOS 11.0, *)
extension UISwipeActionsConfiguration {
  convenience init(actions: [UIContextualAction], fullSwipe: Bool) {
    self.init(actions: actions)
    performsFirstActionWithFullSwipe = fullSwipe
  }
}
