//
//  NotificationExtensions.swift
//
//  Created by Rok Gregorič
//  Copyright © 2018 Rok Gregorič. All rights reserved.
//

import Foundation

extension Notification {
  static func post(_ name: Name, object: Any? = nil, info: [AnyHashable: Any]? = nil) {
    NotificationCenter.default.post(name: name, object: object, userInfo: info)
  }
  
  static func observe(_ name: Name, observer: Any, selector: Selector, object: Any? = nil) {
    stopObserving(name, observer: observer)
    NotificationCenter.default.addObserver(observer, selector: selector, name: name, object: object)
  }
  
  static func stopObserving(_ name: Name, observer: Any, object: Any? = nil) {
    NotificationCenter.default.removeObserver(observer, name: name, object: object)
  }
  
  static func remove(observer: Any) {
    NotificationCenter.default.removeObserver(observer)
  }
}
