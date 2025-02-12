//
//  DictionaryExtensions.swift
//
//  Created by Rok Gregorič
//  Copyright © 2018 Rok Gregorič. All rights reserved.
//

import Foundation

extension Dictionary {
  func map<K, V>(transform: ((key: Key, value: Value)) -> (K, V)) -> [K: V] {
    dic(map(transform))
  }

  func flatMap<K, V>(transform: ((key: Key, value: Value)) -> (K?, V?)) -> [K: V] {
    dic(compactMap { let (k, v) = transform($0); return k == nil || v == nil ? nil : (k!, v!) })
  }

  var urlParams: String? {
    nilIfEmpty?.map { "\($0.key)=\("\($0.value)".urlEncoded)" }.flatJoined("&")
  }

  var queryItems: [URLQueryItem] {
    map { URLQueryItem(name: "\($0.key)", value: "\($0.value)") }.sorted { $0.name < $1.name }
  }

  var ns: NSDictionary { self as NSDictionary }
}

extension Dictionary where Value: OptionalProtocol {
  var flat: [Key: Value.Wrapped] {
    var dic = [Key: Value.Wrapped]()
    forEach { dic[$0.key] = $0.value.val }
    return dic
  }

  var urlParams: String? {
    flat.urlParams
  }
}

func dic<K, V>(_ tupples: [(K, V)]) -> [K: V] {
  var dic = [K: V]()
  tupples.forEach { dic[$0.0] = $0.1 }
  return dic
}

func + <K, V>(left: [K: V], right: [K: V]) -> [K: V] {
  var sum = left
  right.forEach { sum[$0.key] = $0.value }
  return sum
}

func += <K, V>(left: inout [K: V], right: [K: V]) {
  right.forEach { left[$0.key] = $0.value }
}

func flat<K>(_ opt: [K: Any?]) -> [K: Any] {
  var dic = [K: Any]()
  opt.forEach { dic[$0.key] = $0.value }
  return dic
}
