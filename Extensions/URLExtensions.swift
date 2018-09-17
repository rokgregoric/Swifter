//
//  URLExtensions.swift
//
//  Created by Rok Gregorič
//  Copyright © 2018 Rok Gregorič. All rights reserved.
//

import Foundation

extension URL {
  var queryItems: [URLQueryItem] {
    return URLComponents(url: self, resolvingAgainstBaseURL: true)?.queryItems ?? []
  }

  var queryKeys: [String] {
    return queryItems.map { $0.name }
  }

  var queryComponents: [String: String] {
    var result = [String: String]()
    queryItems.forEach { result[$0.name] = $0.value }
    return result
  }

  func appending(queryComponents new: [String: String]) -> URL {
    var comp = URLComponents(url: self, resolvingAgainstBaseURL: true)!
    comp.queryItems = queryItems + new.map { URLQueryItem(name: $0.key, value: $0.value) }
    return comp.url!
  }
}
