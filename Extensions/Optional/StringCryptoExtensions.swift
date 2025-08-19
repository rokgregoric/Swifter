//
//  StringCryptoExtensions.swift
//
//  Created by Rok Gregorič
//  Copyright © 2018 Rok Gregorič. All rights reserved.
//

import CryptoKit
import Foundation

extension String {
  var md5Data: Data {
    Data(Insecure.MD5.hash(data: utf8Data))
  }

  var sha1Data: Data {
    Data(Insecure.SHA1.hash(data: utf8Data))
  }

  var md5: String {
    md5Data.map { String(format: "%02hhx", $0) }.joined()
  }

  var sha1: String {
    sha1Data.map { String(format: "%02hhx", $0) }.joined()
  }
}
