//
//  RealmListExtension.swift
//
//  Created by Rok Gregorič
//  Copyright © 2018 Rok Gregorič. All rights reserved.
//

import RealmSwift

extension List {
  var array: [Element] {
    return Array(self)
  }

  func object(at index: Int) -> Element? {
    if index >= 0 && index < self.count {
      return self[index] as Element
    }
    return nil
  }

  func remove(_ element: Element) {
    _ = index(of: element).map { remove(at: $0 ) }
  }
}
