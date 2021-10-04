//
//  URLExtensions.swift
//
//  Created by Rok Gregorič
//  Copyright © 2018 Rok Gregorič. All rights reserved.
//

import Foundation

extension URL {
  var components: URLComponents? {
    return URLComponents(url: self, resolvingAgainstBaseURL: true)
  }

  var queryItems: [URLQueryItem] {
    return components?.queryItems ?? []
  }

  var queryKeys: [String] {
    return queryItems.map { $0.name }
  }

  var queryComponents: [String: String] {
    var result = [String: String]()
    queryItems.forEach { result[$0.name] = $0.value }
    return result
  }

  func appending(params: [String: Any]) -> URL? {
    guard var comp = components else { return nil }
    comp.queryItems = queryItems + params.queryItems
    return comp.url
  }

  var request: URLRequest {
    return URLRequest(url: self)
  }

  var data: Data? {
    return try? Data(contentsOf: self)
  }
}
