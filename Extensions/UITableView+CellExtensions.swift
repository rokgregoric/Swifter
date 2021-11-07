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

  class func register(identifier: String? = nil, on tableView: UITableView) {
    tableView.register(nib(), forCellReuseIdentifier: identifier ?? self.identifier)
  }
}

extension UITableView {
  func layout() {
    beginUpdates()
    endUpdates()
  }

  func deselectSelectedRow(animated: Bool) {
    indexPathForSelectedRow.map { self.deselectRow(at: $0, animated: animated) }
  }

  func scrollToTopRow(animated: Bool) {
    scrollToRow(at: 0.indexPath, at: .top, animated: animated)
  }
}

extension Int {
  var indexPath: IndexPath {
    return indexPath(0)
  }

  func indexPath(_ section: Int) -> IndexPath {
    return IndexPath(row: self, section: section)
  }
}
