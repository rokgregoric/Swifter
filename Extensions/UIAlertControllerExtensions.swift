//
//  UIAlertControllerExtensions.swift
//  RedDoor
//
//  Created by Rok Gregoric on 25/04/2019.
//  Copyright © 2019 MortgageHub. All rights reserved.
//

import UIKit

extension UIAlertController.Style {
  static var auto: UIAlertController.Style {
    return UIDevice.current.userInterfaceIdiom == .pad ? .alert : .actionSheet
  }
}
