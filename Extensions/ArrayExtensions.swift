//
//  ArrayExtensions.swift
//
//  Created by Rok Gregorič
//  Copyright © 2018 Rok Gregorič. All rights reserved.
//

import Foundation

extension Array {
  func object(at index: Int) -> Element? {
    return (0 ..< count).contains(index) ? self[index] : nil
  }

  var randomIndex: Int {
    return Int.random(in: count.range)
  }

  var random: Element? {
    return object(at: randomIndex)
  }

  mutating func removeRandom() -> Element? {
    if count == 0 { return nil }
    return remove(at: randomIndex)
  }

  mutating func insert(random object: Element) {
    let index = isEmpty ? 0 : Int.random(in: (count+1).range)
    insert(object, at: index)
  }

  mutating func insertAppend(_ element: Element, at index: Int) {
    if count > index {
      insert(element, at: index)
    } else {
      append(element)
    }
  }

  func slice(from s: Int? = nil, to e: Int? = nil) -> [Element] {
    let s = s.map { clamp($0, min: 0, max: count) } ?? 0
    let e = e.map { clamp($0, min: 0, max: count) } ?? count
    return Array(self[s ..< e])
  }

  var indexed: [String: Element] {
    var result = [String: Element]()
    enumerated().forEach { result["\($0.0)"] = $0.1 }
    return result
  }

  func shuffled() -> [Element] {
    var result = [Element]()
    forEach { result.insert(random: $0) }
    return result
  }
}

extension Collection {
  var nilIfEmpty: Self? {
    return isEmpty ? nil : self
  }

  var hasOne: Bool {
    return count == 1
  }

  var firstIfAlone: Element? {
    return hasOne ? first : nil
  }

  var notEmpty: Bool {
    return !isEmpty
  }
}

extension Optional where Wrapped: Collection {
  var nilIfEmpty: Wrapped? {
    return self?.nilIfEmpty
  }
}

extension Array where Iterator.Element: Equatable {
  @discardableResult
  mutating func remove(_ element: Element) -> Int? {
    let idx = firstIndex(of: element)
    _ = idx.map { remove(at: $0 ) }
    return idx
  }

  func removing(_ element: Element) -> [Element] {
    var copy = self
    copy.remove(element)
    return copy
  }

  mutating func toggle(_ element: Element) {
    if self.contains(element) {
      remove(element)
    } else {
      append(element)
    }
  }
}

extension Sequence where Iterator.Element: Equatable {
  public func containsNil(_ element: Iterator.Element?) -> Bool {
    return element.map(contains) ?? false
  }

  public func excludes(_ element: Iterator.Element) -> Bool {
    return !contains(element)
  }

  public func excludesNil(_ element: Iterator.Element?) -> Bool {
    return element.map(excludes) ?? true
  }
}

extension Sequence where Iterator.Element: Hashable {
  func unique() -> [Iterator.Element] {
    return Array(Set<Iterator.Element>(self))
  }

  func uniqueOrdered() -> [Iterator.Element] {
    return reduce([Iterator.Element]()) { $0.contains($1) ? $0 : $0 + [$1] }
  }
}

protocol OptionalProtocol {
  associatedtype Wrapped
  var val: Wrapped? { get }
}

extension Optional: OptionalProtocol {
  public var val: Wrapped? { return self }
}

extension Sequence where Iterator.Element: OptionalProtocol {
  var flat: [Iterator.Element.Wrapped] {
    return compactMap {
      if let str = ($0.val as? String)?.nilIfEmpty {
        return str as? Iterator.Element.Wrapped
      }
      return $0.val
    }
  }
}

extension Sequence where Iterator.Element == String {
  func joined(_ separator: String) -> String {
    return joined(separator: separator)
  }

  func nilJoined(_ separator: String) -> String? {
    return map { $0 }.nilIfEmpty?.joined(separator)
  }
}

extension Sequence where Iterator.Element == Optional<String> {
  func flatJoined(_ separator: String) -> String {
    return flat.joined(separator)
  }

  func nilFlatJoined(_ separator: String) -> String? {
    return flat.nilIfEmpty?.joined(separator)
  }
}
