//
//  StringExtensions.swift
//
//  Created by Rok Gregorič
//  Copyright © 2018 Rok Gregorič. All rights reserved.
//

import Foundation

extension String {
  var url: URL? { URL(string: self) }

  var fileURL: URL { URL(fileURLWithPath: self) }

  var mailtoURL: URL? { "mailto:\(self)".url }

  var safeURL: URL {
    if AppEnvironment.isSimulator || AppEnvironment.isDebuggerAttached {
      if let url { return url }
      fatalError("Invalid URL: \(self)")
    }
    return url ?? .empty
  }

  var urlEncoded: String { escaped(.urlHostAllowed).plusAndEncoded }

  var plusAndEncoded: String { replace("+", with: "%2B").replace("&", with: "%26") }

  var plusAndDecoded: String {
    replace("%2B", with: "+").replace("%26", with: "&").replace("(", with: "%28").replace(")", with: "%29")
  }

  var htmlEncoded: String {
    replace("&", with: "&amp;").replace("\"", with: "&quot;").replace("'", with: "&#39;").replace("<", with: "&lt;").replace(">", with: "&gt;")
  }

  var htmlDecoded: String {
    replace("&nbsp;", with: " ").replace("&amp;", with: "&").replace("&quot;", with: "\"").replace("&#39;", with: "'").replace("&lt;", with: "<").replace("&gt;", with: ">")
  }

  var urlDecoded: String { removingPercentEncoding ?? "" }

  var trimmed: String { trimmingCharacters(in: .whitespacesAndNewlines) }

  var digits: String { removed(.decimalDigits.inverted) }

  var removedSpacesAndNewlines: String { removed(.whitespacesAndNewlines) }

  func removed(_ characterSet: CharacterSet) -> String { components(separatedBy: characterSet).joined() }

  func escaped(_ characterSet: CharacterSet) -> String {
    addingPercentEncoding(withAllowedCharacters: characterSet) ?? ""
  }

  func replace(_ substring: String, with: String) -> String { replacingOccurrences(of: substring, with: with) }

  func replace(_ substring: String, with: String, options: NSString.CompareOptions) -> String {
    replacingOccurrences(of: substring, with: with, options: options)
  }

  func regplace(_ regexp: String, with: String) -> String { replace(regexp, with: with, options: .regularExpression) }
  func regplacei(_ regexp: String, with: String) -> String { replace(regexp, with: with, options: [.regularExpression, .caseInsensitive]) }
  func replacei(_ regexp: String, with: String) -> String { replace(regexp, with: with, options: .caseInsensitive) }

  func remove(_ substring: String) -> String { replace(substring, with: "") }
  func removei(_ substring: String) -> String { replacei(substring, with: "") }

  func regmove(_ regexp: String) -> String { regplace(regexp, with: "") }
  func regmovei(_ regexp: String) -> String { regplacei(regexp, with: "") }

  func splitString(_ string: String, length: Int) -> [String] {
    stride(from: 0, to: string.count, by: length).reversed().map {
      let endIndex = string.index(string.endIndex, offsetBy: -$0)
      let startIndex = string.index(endIndex, offsetBy: -length, limitedBy: string.startIndex)
      return String(string[startIndex! ..< endIndex])
    }
  }

  func spacedString(at spacedIncrement: Int) -> String? { splitString(self, length: spacedIncrement).joined(" ") }

  var localized: String { NSLocalizedString(self, comment: "") }

  subscript(i: Int) -> String { self[i ..< i + 1] }

  func substring(from: Int) -> String { self[min(from, count) ..< count] }

  func substring(to: Int) -> String { self[0 ..< clamp(to, min: 0, max: count)] }

  func substring(from: Int, to: Int) -> String { substring(from: from).substring(to: to - from) }

  mutating func insert(_ char: Character, at: Int) { insert(char, at: String.Index(utf16Offset: at, in: self)) }

  subscript(r: Range<Int>) -> String {
    let range = Range(uncheckedBounds: (lower: clamp(r.lowerBound, min: 0, max: count),
                                        upper: clamp(r.upperBound, min: 0, max: count)))
    let start = index(startIndex, offsetBy: range.lowerBound)
    let end = index(start, offsetBy: range.upperBound - range.lowerBound)
    return String(self[start ..< end])
  }

  typealias RegexMatch = (match: String, range: NSRange)
  func matches(for regex: String) -> [RegexMatch] {
    do {
      let regex = try NSRegularExpression(pattern: regex, options: [.dotMatchesLineSeparators])
      let results = regex.matches(in: self, range: NSRange(location: 0, length: ns.length))
      return results.map { (match: ns.substring(with: $0.range), range: $0.range) }
    } catch _ {
      return []
    }
  }

  var ns: NSString { self as NSString }
  var cf: CFString { self as CFString }

  var trimmedEmpty: String? { trimmed.nilIfEmpty }

  var comparable: String? { trimmedEmpty?.lowercased() }

  static func random(length: Int) -> String {
    let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    return String(length.maps { letters.randomElement()! })
  }

  static func randomDigits(length: Int) -> String {
    let letters = "0123456789"
    return String(length.maps { letters.randomElement()! })
  }

  var firstCapitalized: String { substring(to: 1).capitalized + substring(from: 1) }
  var firstLowercased: String { substring(to: 1).lowercased() + substring(from: 1) }

  var rawNormalized: String { regplace("([a-z])([A-Z])", with: "$1 $2").capitalized }
  var rawValued: String { capitalized.regmove(" ").firstLowercased }
  var rawSnakeCased: String { rawNormalized.snakeCased }
  var rawDashCased: String { rawNormalized.dashCased }

  var snakeCased: String { regplace(" ", with: "_").lowercased() }
  var dashCased: String { regplace(" ", with: "-").lowercased() }

  var searchable: String { ns.folding(options: [.caseInsensitive, .diacriticInsensitive], locale: nil) }

  func prepending(_ pre: String = "") -> String { pre + self }

  func enclosing(pre: String = "", suf: String = "") -> String { pre + self + suf }

  func matches(regExp: String) -> Bool {
    NSPredicate(format: "SELF MATCHES %@", regExp).evaluate(with: self)
  }

  var isValidEmail: Bool {
    matches(regExp: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,10}")
  }

  var isValidSSN: Bool {
    matches(regExp: "^\\d{3}-\\d{2}-\\d{4}$") && !(hasPrefix("000") || hasPrefix("666") || (digits.map { $0 }.unique().count == 1))
  }

  var domain: String? { regmovei(".*https?://").regmove(".*@").regmove("/.*").lowercased().trimmedEmpty }

  var subURLs: [URL] {
    matches(for: "https?://[-a-zA-Z0-9()@:%_\\+.~#?&\\/=]*").compactMap { $0.match.url }
  }

  var intOptional: Int? { Int(digits) }

  var int: Int { intOptional ?? 0 }

  var double: Double? {
    Double(remove(groupingSeparator).replace(decimalSeparator, with: "."))
  }

  var usDouble: Double? { Double(remove(",")) }

  var safeDouble: Double {
    let arr = components(separatedBy: ".")
    let major = arr.object(at: 0).flatMap(Int.init) ?? 0
    let minor = arr.object(at: 1).flatMap(Int.init) ?? 0
    let str = String(format: "%d.%d", major, minor)
    return Double(str) ?? 0
  }

  var version: Int {
    let arr = components(separatedBy: ".")
    let major = arr.object(at: 0).flatMap(Int.init) ?? 0
    let minor = arr.object(at: 1).flatMap(Int.init) ?? 0
    let bugfix = arr.object(at: 2).flatMap(Int.init) ?? 0
    return major * 1_000_000 + minor * 1000 + bugfix
  }

  var base64DecodedData: Data? { Data(base64Encoded: self) }

  var djb2hash: Int { unicodeScalars.map { $0.value }.reduce(5381) { ($0 << 5) &+ $0 &+ Int($1) } }

  var sdbmhash: Int {
    let mapped = unicodeScalars.map { $0.value }
    return mapped.reduce(0) { Int($1) &+ ($0 << 6) &+ ($0 << 16) &- $0 }
  }

  var utf8OptionalData: Data? { data(using: .utf8) }
  var utf8Data: Data { utf8OptionalData! }

  func XorEncoded(with byte: UInt8) -> String? {
    String(bytes: utf8.map { $0 ^ byte }, encoding: .utf8)
  }
}

extension Substring {
  var string: String { String(self) }
}

extension NSString {
  var string: String { self as String }
}

extension String {
  static var shortID: String { String.random(length: 5) }
  static var longID: String { String.random(length: 28) }
  static var longerID: String { String.random(length: 64) }
  static var uuid: String { UUID().uuidString.lowercased() }
}

extension String: @retroactive Identifiable {
  public var id: String { self }
}

// MARK: - Command line

#if os(OSX)

  extension String {
    func run() -> String? {
      runData()?.utf8string
    }

    func runData() -> Data? {
      let pipe = Pipe()
      let process = Process()
      process.executableURL = "/bin/sh".fileURL
      process.arguments = ["-c", self]
      process.standardOutput = pipe
      process.qualityOfService = .userInteractive
      try? process.run()
      let data = pipe.fileHandleForReading.readDataToEndOfFile()
      pipe.fileHandleForReading.closeFile()
      process.terminate()
      return data
    }
  }

#endif
