//
//  StringCryptoExtensions.swift
//  WorkPhone
//
//  Created by Rok Gregoric on 11/10/2018.
//  Copyright © 2018 Riley. All rights reserved.
//

import Foundation
import CommonCrypto

extension String {
  var md5Data: Data {
    let messageData = data(using: .utf8)!
    var digestData = Data(count: Int(CC_MD5_DIGEST_LENGTH))

    _ = digestData.withUnsafeMutableBytes { digestBytes in
      messageData.withUnsafeBytes { messageBytes in
        CC_MD5(messageBytes, CC_LONG(messageData.count), digestBytes)
      }
    }
    return digestData
  }
}
