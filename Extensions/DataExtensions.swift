//
//  DataExtensions.swift
//
//  Created by Rok Gregorič
//  Copyright © 2018 Rok Gregorič. All rights reserved.
//

import UIKit
import Foundation

extension Data {
  var utf8string: String? {
    return String(data: self, encoding: .utf8)
  }
  
  var hexString: String {
    return map { String(format: "%02.2hhx", $0) }.joined()
  }
  
  init?(hexString: String) {
    let len = hexString.count / 2
    var data = Data(capacity: len)
    for i in 0..<len {
      let j = i*2
      let bytes = hexString[j..<j+2]
      if var num = UInt8(bytes, radix: 16) {
        data.append(&num, count: 1)
      } else {
        return nil
      }
    }
    self = data
  }

  var image: UIImage? {
    return UIImage(data: self)
  }
}
