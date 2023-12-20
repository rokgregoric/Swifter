//
//  KVObserver.swift
//
//  Created by Rok Gregorič
//  Copyright © 2018 Rok Gregorič. All rights reserved.
//

import Foundation

class KVObserver: NSObject {
  let keyPath: String
  let block: () -> Void
  weak var object: AnyObject?

  init(_ object: AnyObject, keyPath: String, block: @escaping () -> Void) {
    self.object = object
    self.keyPath = keyPath
    self.block = block
    super.init()
    object.addObserver(self, forKeyPath: keyPath, options: .new, context: nil)
  }

  override func observeValue(forKeyPath keyPath: String?, of _: Any?, change _: [NSKeyValueChangeKey: Any]?, context _: UnsafeMutableRawPointer?) {
    if keyPath == self.keyPath {
      block()
    }
  }

  deinit {
    object?.removeObserver(self, forKeyPath: keyPath)
  }
}
