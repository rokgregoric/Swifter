//
//  URLExtensions.swift
//
//  Created by Rok Gregorič
//  Copyright © 2018 Rok Gregorič. All rights reserved.
//

import Foundation

extension URL {
  var components: URLComponents? { URLComponents(url: self, resolvingAgainstBaseURL: true) }

  var queryItems: [URLQueryItem] { components?.queryItems ?? [] }

  var queryKeys: [String] { queryItems.map { $0.name } }

  var queryComponents: [String: String] {
    var result = [String: String]()
    queryItems.forEach { result[$0.name] = $0.value }
    return result
  }

  func appending(params: [String: Any]) -> URL? {
    guard var comp = components else { return nil }
    comp.queryItems = queryItems + params.queryItems.sorted { $0.name < $1.name }
    return comp.url
  }

  var request: URLRequest { URLRequest(url: self) }

  var data: Data? { try? Data(contentsOf: self) }

  var ns: NSURL { self as NSURL }
}
