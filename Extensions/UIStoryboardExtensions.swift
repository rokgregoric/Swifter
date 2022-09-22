//
//  UIStoryboardExtensions.swift
//
//  Created by Rok Gregorič
//  Copyright © 2018 Rok Gregorič. All rights reserved.
//

import UIKit

extension UIStoryboard {
  typealias Name = RawString

  class func instantiate(_ name: Name, identifier: String? = nil) -> UIViewController {
    instantiate(string: name.rawValue, identifier: identifier)
  }

  class func instantiate(string: String, identifier: String? = nil) -> UIViewController {
    self.init(name: string, bundle: nil).instantiate(identifier)
  }

  func instantiate(_ identifier: String? = nil) -> UIViewController {
    identifier.map(instantiateViewController) ?? instantiateInitialViewController()!
  }

  static func present(to name: Name, identifier: String? = nil, animated: Bool = false) {
    UIViewController.rootVC?.present(instantiate(name, identifier: identifier), animated: animated)
  }
}
