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
}

extension Int {
  var indexPath: IndexPath {
    return indexPath(0)
  }

  func indexPath(_ section: Int) -> IndexPath {
    return IndexPath(row: self, section: section)
  }
}

extension UIScrollView {
  func scrollToTop(animated: Bool) {
    return scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: animated)
  }

  @IBInspectable var topContentInset: CGFloat {
    get { return contentInset.top }
    set { contentInset.top = newValue }
  }

  @IBInspectable var bottomContentInset: CGFloat {
    get { return contentInset.bottom }
    set { contentInset.bottom = newValue }
  }

  @IBInspectable var leftContentInset: CGFloat {
    get { return contentInset.left }
    set { contentInset.left = newValue }
  }

  @IBInspectable var rightContentInset: CGFloat {
    get { return contentInset.right }
    set { contentInset.right = newValue }
  }
}
