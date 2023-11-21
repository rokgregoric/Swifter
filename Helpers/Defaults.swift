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
    _obj(for: key.rawValue) as? T
  }

  class func set(object: Any?, for key: Key) {
    set(object: object, for: key.rawValue)
  }

  /// Set default value if object doesn't exist
  class func set(default d: Any?, for key: Key) {
    if !hasObject(for: key) { set(object: d, for: key.rawValue) }
  }

  class func hasObject(for key: Key) -> Bool {
    _obj(for: key.rawValue) != nil
  }

  class func removeObject(for key: Key) {
    removeObject(for: key.rawValue)
  }

  class func _obj(for string: String) -> Any? {
    defaults.object(forKey: string) as Any?
  }

  class func object<T>(for string: String) -> T? {
    defaults.object(forKey: string) as? T
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
    defaults.clear()
  }
}

extension UserDefaults {
  func clear() {
    dictionaryRepresentation().forEach {
      removeObject(forKey: $0.0)
    }
    synchronize()
  }
}
