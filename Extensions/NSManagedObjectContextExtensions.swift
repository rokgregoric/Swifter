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
  func array<T: BaseObject>(from jsons: JSON) -> [T] {
    var array = [T]()
    for json in jsons.arrayValue {
      if let object: T = object(from: json) {
        array.append(object)
      }
    }
    return array
  }

  @discardableResult
  func array<T: BaseObject>(from json: JSON, cleanup: (T) -> Bool) -> [T] {
    let old: [T] = all().filter(cleanup)
    let new: [T] = array(from: json)
    old.filter { !new.contains($0) }.forEach { $0.delete() } // delete obsolete objects
    return new
  }

  @discardableResult
  public func object<T: BaseObject>(from json: JSON, id: String? = nil) -> T? {
    if let id = id ?? json[T.idKey].string ?? json[T.idKey].intString {
      let object: T = findOrAdd(id)
      object.update(from: json)
      return object
    }
    return nil
  }

  // MARK: - Fetching

  func findOrAdd<T: BaseObject>(_ id: String) -> T {
    if let object: T = find(id) {
      return object
    }
    return add(id)
  }

  func add<T: BaseObject>(_ id: String) -> T {
    let object = T(context: self)
    object.id = id
    return object
  }

  func deleteAll() {
    all().forEach(delete)
  }

  // MARK: - Fetching

  public func all<T: BaseObject>() -> [T] {
    return try! fetch(FetchRequest(type: T.self))
  }
  public func all<T: BaseObject>(_ type: T.Type? = nil) -> [T] {
    return all()
  }

  func first<T: BaseObject>() -> T? {
    let fr = FetchRequest(type: T.self)
    fr.fetchLimit = 1
    return try! fetch(fr).first
  }
  func first<T: BaseObject>(_ type: T.Type? = nil) -> T? {
    return first()
  }

  func find<T: BaseObject>(_ id: String) -> T? {
    return find(NSPredicate(format: "id = %@", id), limit: 1).first
  }
  func find<T: BaseObject>(_ id: String, _ type: T.Type? = nil) -> T? {
    return find(id)
  }

  func find<T: BaseObject>(_ ids: [String]) -> [T] {
    return find(NSPredicate(format: "id IN %@", ids))
  }
  func find<T: BaseObject>(_ ids: [String], _ type: T.Type? = nil) -> [T] {
    return find(ids)
  }

  func find<T: BaseObject>(_ predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil, limit: Int? = nil) -> [T] {
    let fr = FetchRequest(type: T.self)
    fr.predicate = predicate
    fr.sortDescriptors = sortDescriptors
    limit.map { fr.fetchLimit = $0 }
    return try! fetch(fr)
  }
  func find<T: BaseObject>(_ predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil, limit: Int? = nil, _ type: T.Type? = nil) -> [T] {
    return find(predicate, sortDescriptors: sortDescriptors, limit: limit)
  }

  func find<T: BaseObject>(_ predicates: [NSPredicate], sortDescriptors: [NSSortDescriptor]? = nil, limit: Int? = nil) -> [T] {
    return find(NSCompoundPredicate(andPredicateWithSubpredicates: predicates), sortDescriptors: sortDescriptors, limit: limit)
  }
  func find<T: BaseObject>(_ predicates: [NSPredicate], sortDescriptors: [NSSortDescriptor]? = nil, limit: Int? = nil, _ type: T.Type? = nil) -> [T] {
    return find(predicates, sortDescriptors: sortDescriptors, limit: limit)
  }

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

// MARK: - JSON intString

extension JSON {
  var intString: String? {
    return int64.map { "\($0)" }
  }
}
