//
//  DataExtensions.swift
//
//  Created by Rok Gregorič
//  Copyright © 2018 Rok Gregorič. All rights reserved.
//

import Foundation

extension Data {
  var utf8string: String? { String(data: self, encoding: .utf8) }

  var hexString: String { map { String(format: "%02.2hhx", $0) }.joined() }

  var JSONobject: Any? {
    try? JSONSerialization.jsonObject(with: self, options: .allowFragments)
  }

  var JSONdictionary: [String: Any]? { JSONobject as? [String: Any] }

  func tryDecode<T: Decodable>(_ type: T.Type? = nil) throws -> T {
    try JSONDecoder().decode(T.self, from: self)
  }

  func decoded<T: Decodable>(_ type: T.Type? = nil) -> T? {
    try? tryDecode(type)
  }

  init?(hexString: String) {
    let len = hexString.count / 2
    var data = Data(capacity: len)
    var i = hexString.startIndex
    for _ in 0 ..< len {
      let j = hexString.index(i, offsetBy: 2)
      let bytes = hexString[i ..< j]
      if var num = UInt8(bytes, radix: 16) {
        data.append(&num, count: 1)
      } else {
        return nil
      }
      i = j
    }
    self = data
  }

  var image: XImage? { XImage(data: self) }

  enum ContentType: String {
    case png = "image/png"
    case jpeg = "image/jpeg"
    case text = "text/plain"
  }

  func dataURLstring(type: ContentType) -> String { "data:\(type.rawValue);base64,\(base64EncodedString())" } // options:.lineLength64Characters
  func dataURL(type: ContentType) -> URL? { dataURLstring(type: type).url }

  func array<T>(of type: T.Type) -> [T] {
    let v = withUnsafeBytes { $0.load(as: type) }
    var arr = [T](repeating: v, count: count / MemoryLayout<T>.stride)
    _ = arr.withUnsafeMutableBytes { copyBytes(to: $0) }
    return arr
  }

  var safeString: String? { array(of: CChar.self).withUnsafeBufferPointer { String(cString: $0.baseAddress!) }.components(separatedBy: .controlCharacters).joined() }

  var ns: NSData { self as NSData }

  var fileSize: String {
    let formatter = ByteCountFormatter()
    formatter.allowedUnits = [.useAll]
    formatter.countStyle = .file
    return formatter.string(fromByteCount: Int64(count))
  }

  func saveToFile(type: String) -> URL? {
    saveTemp(filename: "\(String.longerID).\(type)")
  }

  enum Directory {
    case temp
    case document
    case cache

    var url: URL {
      switch self {
        case .temp: return FileManager.default.temporaryDirectory
        case .document: return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        case .cache: return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
      }
    }
  }

  @discardableResult
  func saveTemp(filename: String) -> URL? {
    save(directory: .temp, filename: filename)
  }

  @discardableResult
  func save(directory: Directory, filename: String) -> URL? {
    let url = directory.url.appendingPathComponent(filename)
    Log.debug(#function, url.absoluteString, context: "data")
    return save(to: url) ? url : nil
  }

  init?(directory: Directory, filename: String) {
    do {
      let url = directory.url.appendingPathComponent(filename)
      Log.debug(#function, url.absoluteString, context: "data")
      try self.init(contentsOf: url)
    } catch {
      return nil
    }
  }

  @discardableResult
  func save(to url: URL) -> Bool {
    do {
      try write(to: url)
      return true
    } catch {
      Log.error("Error saving image:", error)
      return false
    }
  }
}
