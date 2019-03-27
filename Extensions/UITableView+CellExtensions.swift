//
//  UITableView+CellExtensions.swift
//
//  Created by Rok Gregorič
//  Copyright © 2018 Rok Gregorič. All rights reserved.
//

import UIKit

extension UITableViewCell {
  @objc class func dequeueReusableCell(identifier: String? = nil, for indexPath: IndexPath, on tableView: UITableView) -> Self {
    let cell = tableView.dequeueReusableCell(withIdentifier: identifier ?? self.identifier, for: indexPath)
    return castToSelf(cell)
  }

  @objc class func dequeueReusableCell(identifier: String? = nil, on tableView: UITableView) -> Self? {
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

extension Int {
  var indexPath: IndexPath {
    return IndexPath(row: self, section: 0)
  }
}
