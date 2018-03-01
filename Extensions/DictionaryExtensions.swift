//
//  DictionaryExtensions.swift
//
//  Created by Rok Gregorič
//  Copyright © 2018 Rok Gregorič. All rights reserved.
//

import Foundation

extension Dictionary {
  func map<K, V>(transform: (_ key: Key, _ value: Value) -> (K, V)) -> [K: V] {
    return dic(map { transform($0, $1) })
  }
  
  func flatMap<K, V>(transform: (_ key: Key, _ value: Value) -> (K?, V?)) -> [K: V] {
    return dic(flatMap { let (k, v) = transform($0, $1); return (k == nil || v == nil ? nil : (k!, v!)) })
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

func += <K, V> (left: inout [K: V], right: [K: V]) {
  right.forEach { left[$0.key] = $0.value }
}
