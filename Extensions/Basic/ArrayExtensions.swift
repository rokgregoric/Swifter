//
//  ArrayExtensions.swift
//
//  Created by Rok Gregorič
//  Copyright © 2018 Rok Gregorič. All rights reserved.
//

import Foundation

extension Array {
  func object(at index: Int) -> Element? { (0 ..< count).contains(index) ? self[index] : nil }

  func object(mod index: Int) -> Element? { object(at: index % count) }

  var randomIndex: Int { Int.random(in: count.range) }

  var random: Element? { object(at: randomIndex) }

  @discardableResult
  mutating func removeRandom() -> Element? { isEmpty ? nil : remove(at: randomIndex) }
  @discardableResult
  mutating func removeFirstIf() -> Element? { isEmpty ? nil : remove(at: 0) }
  @discardableResult
  mutating func removeLastIf() -> Element? { isEmpty ? nil : remove(at: count - 1) }

  mutating func insert(random object: Element) {
    let index = isEmpty ? 0 : Int.random(in: (count + 1).range)
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

  var ns: NSArray { self as NSArray }
}

extension ArraySlice {
  var array: [Element] { Array(self) }
}

extension Collection {
  var nilIfEmpty: Self? { isEmpty ? nil : self }
  var nilIfEmptyOrOne: Self? { hasOne ? nil : nilIfEmpty }

  var hasOne: Bool { count == 1 }

  var firstIfHasOne: Element? { hasOne ? first : nil }

  var notEmpty: Bool { !isEmpty }

  func has(where predicate: (Self.Element) -> Bool) -> Bool { first(where: predicate).notNil }
}

extension Optional where Wrapped: Collection {
  var nilIfEmpty: Wrapped? { self?.nilIfEmpty }
}

extension Array {
  func chunked(into size: Int) -> [[Element]] {
    stride(from: 0, to: count, by: Swift.max(size, 1)).map { startIndex in
      let endIndex = Swift.min(startIndex + size, count)
      return Array(self[startIndex..<endIndex])
    }
  }
}

extension Array where Iterator.Element: Equatable {
  @discardableResult
  mutating func remove(_ element: Element) -> Int? {
    let idx = firstIndex(of: element)
    _ = idx.map { remove(at: $0) }
    return idx
  }

  /// replace the matching element with a replacement or the element itself
  @discardableResult
  mutating func replace(_ element: Element, with replacement: Element? = nil) -> Int? {
    let idx = firstIndex(of: element)
    _ = idx.map { self[$0] = replacement ?? element }
    return idx
  }

  func removing(_ element: Element) -> [Element] {
    removing([element])
  }

  func removing(_ elements: [Element]) -> [Element] {
    filter(elements.excludes)
  }

  mutating func toggle(_ element: Element) {
    if contains(element) {
      remove(element)
    } else {
      append(element)
    }
  }
}

extension Set where Iterator.Element: Equatable {
  func removing(_ element: Element) -> Set<Element> {
    removing([element])
  }

  func removing(_ elements: [Element]) -> Set<Element> {
    filter(elements.excludes)
  }

  mutating func toggle(_ element: Element) {
    if contains(element) {
      remove(element)
    } else {
      insert(element)
    }
  }
}

public extension Sequence where Iterator.Element: Equatable {
  func containsNil(_ element: Iterator.Element?) -> Bool {
    element.map(contains) ?? false
  }

  func excludes(_ element: Iterator.Element) -> Bool {
    !contains(element)
  }

  func excludesNil(_ element: Iterator.Element?) -> Bool {
    element.map(excludes) ?? true
  }

  func containsAny(_ other: [Iterator.Element]) -> Bool {
    first(where: other.contains).notNil
  }

  func contains(_ element: Iterator.Element?) -> Bool {
    element.map { contains($0) } ?? false
  }
}

extension Sequence where Iterator.Element: Equatable {
  func uniqueOrdered() -> [Iterator.Element] {
    reduce([Iterator.Element]()) { $0.contains($1) ? $0 : $0 + [$1] }
  }
}

extension Sequence where Iterator.Element: Hashable {
  func unique() -> [Iterator.Element] {
    Array(Set<Iterator.Element>(self))
  }

  func intersects(with array: [Iterator.Element]) -> Bool {
    !Set(self).isDisjoint(with: Set(array))
  }
}

extension Sequence where Element: AdditiveArithmetic {
  func sum() -> Element { reduce(.zero, +) }
}

extension Collection where Element: BinaryInteger {
  func average() -> Element { isEmpty ? .zero : sum() / Element(count) }
}

extension Collection where Element: FloatingPoint {
  func average() -> Element { isEmpty ? .zero : sum() / Element(count) }
}

extension Sequence where Iterator.Element: OptionalProtocol {
  var flat: [Iterator.Element.Wrapped] {
    compactMap {
      if let str = ($0.val as? String)?.nilIfEmpty {
        return str as? Iterator.Element.Wrapped
      }
      return $0.val
    }
  }
}

extension Sequence where Iterator.Element == String {
  func joined(_ separator: String) -> String {
    joined(separator: separator)
  }

  func nilJoined(_ separator: String) -> String? {
    map { $0 }.nilIfEmpty?.joined(separator)
  }
}

extension Sequence where Iterator.Element == String? {
  func flatJoined(_ separator: String) -> String {
    flat.joined(separator)
  }

  func nilFlatJoined(_ separator: String) -> String? {
    flat.nilIfEmpty?.joined(separator)
  }
}

extension Array: @retroactive RawRepresentable where Element: Codable {
  public init?(rawValue: String) {
    guard let array = rawValue.utf8OptionalData?.decoded([Element].self) else { return nil }
    self = array
  }

  public var rawValue: String {
    JSONstring ?? ""
  }
}
