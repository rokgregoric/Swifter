//
//  BaseRequest.swift
//
//  Created by Rok Gregoric on 24/12/2021.
//  Copyright © 2021 Rok Gregoric. All rights reserved.
//

import Foundation

enum Method: String {
  case get, post, put, delete
  var name: String { rawValue.uppercased() }
}

protocol BaseRequest {
  var method: Method { get }
  var authKey: String { get }
  var header: [String: String]? { get }
  var scheme: String { get }
  var basePath: String { get }
  var path: String? { get }
  var params: [String: Any]? { get }
  var body: Data? { get }
  var shouldLogResponse: Bool { get }
  var maxContentLength: Int? { get }
  var session: URLSession? { get }
}

// MARK: - Defaults

extension BaseRequest {
  var method: Method { .get }
  var authKey: String { "Authorization" }
  var header: [String: String]? { nil }
  var scheme: String { "https" }
  var params: [String: Any]? { nil }
  var shouldLogResponse: Bool { true }
  var maxContentLength: Int? { nil }
  var session: URLSession? { nil }
}

extension BaseRequest {
  var body: Data? {
    if method == .get { return nil }
    return params.flatMap(JSONdata)
  }

  var urlString: String { scheme + "://" + basePath + (path.map { "/" + $0 } ?? "") }

  private func getURL(_ url: URL) -> URL? {
    params.flatMap(url.appending)
  }

  var url: URL {
    let url = urlString.url!
    if method == .get, let url = getURL(url) { return url }
    return url
  }

  private func shortAuth(_ headers: [String: String]?) -> [String: String]? {
    guard var h = headers else { return nil }
    h[authKey] = h[authKey]?.substring(to: 20).appending("...")
    return h
  }

  /// returns in a concurrent thread
  func request(completion: @escaping Block3<Data?, Int?, Error?>) {
    let method = method.name
    var request = url.request
    request.httpMethod = method
    header?.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }
    if let body {
      // Only set Content-Type if not already set by header
      if request.value(forHTTPHeaderField: "Content-Type") == nil {
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
      }
      request.httpBody = body
    }
    let s = measureStart()
    (session ?? URLSession.shared).dataTask(with: request) { data, res, err in
      Run.concurrent {
        let time = "\ntime: \(measureEnd(s))s"
        let statusCode = (res as? HTTPURLResponse)?.statusCode
        let code = statusCode ?? -1
        let status = "\nstatus: \(code)"
        let allHeaders = request.allHTTPHeaderFields.nilIfEmpty
        let headers = shortAuth(allHeaders).flatMap(JSONString)?.prepending("\nheaders: ")
        let success = err == nil && 200..<300 ~= code
        var params = request.httpBody?.utf8string?.prepending("\nrequest: ")
        let shouldLogResponse = shouldLogResponse || AppEnvironment.isProduction || !success
        var response = data.flatMap { shouldLogResponse ? (prettyJSONstring($0) ?? $0.utf8string?.nilIfEmpty) : $0.utf8string?.lengthOfBytes(using: .utf8).string.appending(" bytes") }?.prepending("\nresponse: ")
        if let maxContentLength {
          params = params?.substring(to: maxContentLength)
          response = response?.substring(to: maxContentLength)
        }
        Log.custom(level: success ? .verbose : .error, message: method, url, headers, params, status, time, response, err, context: "api")
        Run.main { completion(data, statusCode, err) }
      }
    }.resume()
  }

  // MARK - request decoded

  func parse<T: Decodable>(_ type: T.Type, from data: Data?, status: Int?, error: Error?, completion: @escaping Block3<T?, Int?, Error?>) {
    var t: T?
    do {
      t = try data?.tryDecode()
    } catch let err {
      Log.error(err, context: "decode")
    }
    Run.main { completion(t, status, error) }
  }

  func request<T: Decodable>(_ type: T.Type, completion: @escaping Block3<T?, Int?, Error?>) {
    request { data, status, err in
      Run.concurrent {
        parse(type, from: data, status: status, error: err, completion: completion)
      }
    }
  }

  func request<T: Decodable>(_ type: T.Type, completion: @escaping Block2<T?, Int?>) {
    request(type) { t, status, _ in completion(t, status) }
  }

  func request<T: Decodable>(_ type: T.Type, completion: @escaping Block1<T?>) {
    request(type) { t, _ in completion(t) }
  }

  // MARK - request

  func request(completion: @escaping Block1<Data?>) {
    request { data, _, _ in Run.main { completion(data) } }
  }

  func request(completion: Block? = nil) {
    request { _, _, _ in completion.map { Run.main($0) } }
  }
}
