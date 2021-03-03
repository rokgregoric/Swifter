//
//  StringExtension.swift
//
//  Created by Rok Gregorič
//  Copyright © 2018 Rok Gregorič. All rights reserved.
//

import Foundation

extension String {
  var url: URL? {
    return URL(string: self)
  }

  var fileURL: URL? {
    return URL(fileURLWithPath: self)
  }

  var urlEncoded: String {
    return escaped(.urlHostAllowed).plusAndEncoded
  }

  var plusAndEncoded: String {
    return replace("+", with: "%2B").replace("&", with: "%26")
  }

  var plusAndDecoded: String {
    return replace("%2B", with: "+").replace("%26", with: "&").replace("(", with: "%28").replace(")", with: "%29")
  }

  var htmlEncoded: String {
    return replace("&", with: "&amp;").replace("\"", with: "&quot;").replace("'", with: "&#39;").replace("<", with: "&lt;").replace(">", with: "&gt;")
  }

  var urlDecoded: String {
    return removingPercentEncoding ?? ""
  }

  var trimmed: String {
    return trimmingCharacters(in: .whitespacesAndNewlines)
  }

  var digits: String {
    return components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
  }

  var removedSpacesAndNewlines: String {
    return components(separatedBy: CharacterSet.whitespacesAndNewlines).joined()
  }

  func escaped(_ characterSet: CharacterSet) -> String {
    return addingPercentEncoding(withAllowedCharacters: characterSet) ?? ""
  }

  func replace(_ substring: String, with: String) -> String {
    return replacingOccurrences(of: substring, with: with)
  }

  func replace(_ substring: String, with: String, options: NSString.CompareOptions) -> String {
    return replacingOccurrences(of: substring, with: with, options: options)
  }

  func regplace(_ regexp: String, with: String) -> String {
    return replace(regexp, with: with, options: .regularExpression)
  }

  func remove(_ substring: String) -> String {
    return replace(substring, with: "")
  }

  func regmove(_ regexp: String) -> String {
    return regplace(regexp, with: "")
  }

  func splitString(_ string: String, length: Int) -> [String] {
    return stride(from: 0, to: string.count, by: length).reversed().map {
      let endIndex = string.index(string.endIndex, offsetBy: -$0)
      let startIndex = string.index(endIndex, offsetBy: -length, limitedBy: string.startIndex)
      return String(string[startIndex!..<endIndex])
    }
  }

  func spacedString(at spacedIncrement: Int) -> String? {
    let splitString = self.splitString(self, length: spacedIncrement)
    return splitString.joined(separator: " ")
  }

  var localized: String {
    return NSLocalizedString(self, comment: "")
  }

  subscript(i: Int) -> String {
    return self[i ..< i + 1]
  }

  func substring(from: Int) -> String {
    return self[min(from, count) ..< count]
  }

  func substring(to: Int) -> String {
    return self[0 ..< clamp(to, min: 0, max: count)]
  }

  func substring(from: Int, to: Int) -> String {
    return substring(from: from).substring(to: to-from)
  }

  mutating func insert(_ char: Character, at: Int) {
    insert(char, at: String.Index(utf16Offset: at, in: self))
  }

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
      let regex = try NSRegularExpression(pattern: regex)
      let results = regex.matches(in: self, range: NSRange(location: 0, length: ns.length))
      return results.map { (match: ns.substring(with: $0.range), range: $0.range) }
    } catch _ {
      return []
    }
  }

  var ns: NSString {
    return self as NSString
  }

  var trimmedEmpty: String? {
    return trimmed.nilIfEmpty
  }

  var comparable: String? {
    return trimmedEmpty?.lowercased()
  }

  static func random(length: Int) -> String {
    let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    return String(length.maps { letters.randomElement()! })
  }

  static func randomDigits(length: Int) -> String {
    let letters = "0123456789"
    return String(length.maps { letters.randomElement()! })
  }

  var firstCapitalized: String {
    return substring(to: 1).capitalized + substring(from: 1)
  }

  func matches(regExp: String) -> Bool {
    let predicate = NSPredicate(format:"SELF MATCHES %@", regExp)
    return predicate.evaluate(with: self)
  }

  var isValidEmail: Bool {
    return matches(regExp: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,10}")
  }

  var isValidSSN: Bool {
    return matches(regExp: "^\\d{3}-\\d{2}-\\d{4}$")
  }

  var int: Int {
    return Int(digits) ?? 0
  }

  var safeDouble: Double {
    let arr = components(separatedBy: ".")
    let major = arr.object(at: 0).flatMap(Int.init) ?? 0
    let minor = arr.object(at: 1).flatMap(Int.init) ?? 0
    let str = String(format: "%d.%d", major, minor)
    return Double(str) ?? 0
  }
}

extension Substring {
  var string: String {
    return String(self)
  }
}
