//
//  Defaults.swift
//
//  Created by Rok Gregorič
//  Copyright © 2018 Rok Gregorič. All rights reserved.
//

import Foundation

class Defaults {
  typealias Key = RawString

  fileprivate static var defaults = UserDefaults.standard

  class func object<T>(for key: Key) -> T? {
    return object(for: key.rawValue) as? T
  }

  class func set(object: Any?, for key: Key) {
    set(object: object, for: key.rawValue)
  }

  class func hasObject(for key: Key) -> Bool {
    return object(for: key.rawValue) != nil
  }

  class func removeObject(for key: Key) {
    removeObject(for: key.rawValue)
  }

  class func object(for string: String) -> Any? {
    return defaults.object(forKey: string) as Any?
  }

  class func set(object: Any?, for string: String) {
    if let object: Any = object {
      defaults.set(object, forKey: string)
    } else {
      defaults.removeObject(forKey: string)
    }
    defaults.synchronize()
  }

  class func removeObject(for string: String) {
    defaults.removeObject(forKey: string)
    defaults.synchronize()
  }

  class func clear() {
    defaults.dictionaryRepresentation().forEach {
      defaults.removeObject(forKey: $0.0)
    }
    defaults.synchronize()
  }
}
