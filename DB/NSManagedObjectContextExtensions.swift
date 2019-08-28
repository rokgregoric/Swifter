//
//  NSManagedObjectContextExtensions.swift
//
//  Created by Rok Gregorič
//  Copyright © 2018 Rok Gregorič. All rights reserved.
//

import Foundation
import CoreData
import SwifterJSON

extension NSManagedObjectContext {

  // MARK: - Creation

  @discardableResult
  func array<T: BaseObject>(from jsons: JSON?, _ type: T.Type? = nil) -> [T] {
    var array = [T]()
    for json in jsons?.array ?? [] {
      if let object = object(from: json, T.self) {
        array.append(object)
      }
    }
    return array
  }

  @discardableResult
  func array<T: BaseObject>(from json: JSON?, _ type: T.Type? = nil, cleanup: (T) -> Bool) -> [T] {
    let old = all(T.self).filter(cleanup)
    let new = array(from: json, T.self)
    old.filter { !new.contains($0) }.forEach { $0.delete() } // delete obsolete objects
    return new
  }

  @discardableResult
  func object<T: BaseObject>(from json: JSON?, _ type: T.Type? = nil, id: String? = nil) -> T? {
    if let id = id ?? json?[T.uniqKey].string ?? json?[T.uniqKey].intString {
      let object = findOrAdd(id, T.self)
      object.update(from: json)
      return object
    }
    return nil
  }

  // MARK: - Fetching

  func findOrAdd<T: BaseObject>(_ id: String) -> T {
    if let object = find(id, T.self) {
      return object
    }
    return add(id)
  }
  func findOrAdd<T: BaseObject>(_ id: String, _ type: T.Type) -> T { return findOrAdd(id) }

  func add<T: BaseObject>(_ id: String) -> T {
    let object = T(context: self)
    object.id = id
    return object
  }
  func add<T: BaseObject>(_ id: String, _ type: T.Type) -> T { return add(id) }

  func deleteAll() {
    all().forEach(delete)
  }

  // MARK: - Fetching

  func all<T: BaseObject>() -> [T] {
    return try! fetch(FetchRequest(type: T.self))
  }
  func all<T: BaseObject>(_ type: T.Type) -> [T] { return all() }

  func first<T: BaseObject>() -> T? {
    let fr = FetchRequest(type: T.self)
    fr.fetchLimit = 1
    return try! fetch(fr).first
  }
  func first<T: BaseObject>(_ type: T.Type) -> T? { return first() }

  func find<T: BaseObject>(_ id: String) -> T? {
    return find(NSPredicate(format: "id = %@", id), limit: 1).first
  }
  func find<T: BaseObject>(_ id: String, _ type: T.Type) -> T? { return find(id) }

  func find<T: BaseObject>(_ ids: [String]) -> [T] {
    return find(NSPredicate(format: "id IN %@", ids))
  }
  func find<T: BaseObject>(_ ids: [String], _ type: T.Type) -> [T] { return find(ids) }

  func find<T: BaseObject>(_ predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil, limit: Int? = nil, _ type: T.Type? = nil) -> [T] {
    let fr = FetchRequest(type: T.self)
    fr.predicate = predicate
    fr.sortDescriptors = sortDescriptors
    limit.map { fr.fetchLimit = $0 }
    return try! fetch(fr)
  }

  func find<T: BaseObject>(_ predicates: [NSPredicate], sortDescriptors: [NSSortDescriptor]? = nil, limit: Int? = nil, _ type: T.Type? = nil) -> [T] {
    return find(NSCompoundPredicate(andPredicateWithSubpredicates: predicates), sortDescriptors: sortDescriptors, limit: limit)
  }

  func sorted<T: BaseObject>() -> [T] {
    return find(sortDescriptors: T.sortDesc)
  }
  func sorted<T: BaseObject>(_ type: T.Type) -> [T] { return sorted() }

  // MARK: - Counts

  func count<T: BaseObject>(_ type: T.Type) -> Int {
    return try! count(for: FetchRequest(type: T.self))
  }

  func count<T: BaseObject>(_ predicate: NSPredicate?, _ type: T.Type) -> Int {
    let fr = FetchRequest(type: T.self)
    fr.predicate = predicate
    return try! count(for: fr)
  }

  // MARK: - Saving

  @discardableResult
  func saveIfNeeded() -> Bool {
    if hasChanges {
      Log.verbose("Saving", (parent == nil ? "main" : "child") + " context", context: "CoreData")
      do {
        try save()
        return true
      } catch {
        // Replace this implementation with code to handle the error appropriately.
        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        let nserror = error as NSError
        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
      }
    }
    return false
  }

  // MARK: - Child contexts

  func child(type: NSManagedObjectContextConcurrencyType) -> NSManagedObjectContext {
    let child = NSManagedObjectContext(concurrencyType: type)
    child.parent = self
    return child
  }
}
