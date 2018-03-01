//
//  UITableView+CellExtensions.swift
//
//  Created by Rok Gregorič
//  Copyright © 2018 Rok Gregorič. All rights reserved.
//

import UIKit

extension UITableViewCell {
  class func dequeueReusableCell(identifier: String? = nil, for indexPath: IndexPath, in tableView: UITableView) -> Self {
    let cell = tableView.dequeueReusableCell(withIdentifier: identifier ?? self.identifier, for: indexPath)
    return castToSelf(cell)
  }

  class func dequeueReusableCell(identifier: String? = nil, in tableView: UITableView) -> Self? {
    let cell = tableView.dequeueReusableCell(withIdentifier: identifier ?? self.identifier)
    return castIfSelf(cell)
  }
}

extension UITableView {
  func layout() {
    beginUpdates()
    endUpdates()
  }
}

