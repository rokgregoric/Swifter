//
//  RealmListExtension.swift
//
//  Created by Rok Gregorič
//  Copyright © 2018 Rok Gregorič. All rights reserved.
//

#if canImport(RealmSwift)
import RealmSwift

extension List {
  var array: [Element] {
    Array(self)
  }

  func object(at index: Int) -> Element? {
    if index >= 0, index < count {
      return self[index] as Element
    }
    return nil
  }

  func remove(_ element: Element) {
    _ = index(of: element).map { remove(at: $0) }
  }
}
#endif
