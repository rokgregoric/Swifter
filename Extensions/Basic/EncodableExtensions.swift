//
//  EncodableExtensions.swift
//
//  Created by Rok Gregorič
//  Copyright © 2024 Rok Gregorič. All rights reserved.
//

import Foundation

extension Encodable {
  var JSONdata: Data? {
    let enc = JSONEncoder()
    enc.outputFormatting = [.sortedKeys, .prettyPrinted]
    enc.dateEncodingStrategy = .iso8601
    return try? enc.encode(self)
  }

  var JSONstring: String? {
    JSONdata?.utf8string
  }

  var JSONdictionary: [String: Any]? {
    JSONdata?.JSONdictionary
  }
}

func JSONString(_ value: Any) -> String? {
  (value as? Encodable)?.JSONstring
}

func JSONdata(_ value: Any) -> Data? {
  try? JSONSerialization.data(withJSONObject: value, options: [.sortedKeys, .prettyPrinted, .fragmentsAllowed])
}

func prettyJSONstring(_ data: Data) -> String? {
  data.JSONobject.flatMap(JSONdata)?.utf8string
}
