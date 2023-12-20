//
//  NSManagedObjectContextExtensions.swift
//
//  Created by Rok Gregorič
//  Copyright © 2018 Rok Gregorič. All rights reserved.
//

import CoreData
import Foundation
import SwifterJSON

extension NSManagedObjectContext {
  // MARK: - Creation

  @discardableResult
  func array<T: BaseObject>(from jsons: JSON?, _: T.Type? = nil) -> [T]? {
    guard let arr = jsons?.array else { return nil }
    var array = [T]()
    for json in arr {
      if let object = object(from: json, T.self) {
        array.append(object)
      }
    }
    return array
  }

  @discardableResult
  func array<T: BaseObject>(from json: JSON?, _: T.Type? = nil, cleanup: (T) -> Bool) -> [T]? {
    let old = all(T.self).filter(cleanup)
    guard let new = array(from: json, T.self) else { return nil }
    old.filter { !new.contains($0) }.forEach { $0.delete() } // delete obsolete objects
    return new
  }

  @discardableResult
  func object<T: BaseObject>(from json: JSON?, _ type: T.Type? = nil, id: String? = nil) -> T? {
    T.object(from: json, type, id: id, in: self)
  }

  // MARK: - Fetching

  func findOrAdd<T: BaseObject>(_ id: String) -> T {
    find(id, T.self) ?? add(id)
  }

  func findOrAdd<T: BaseObject>(_ id: String, _: T.Type) -> T { findOrAdd(id) }

  func add<T: BaseObject>(_ id: String) -> T {
    let object = T(context: self)
    object.id = id
    return object
  }

  func add<T: BaseObject>(_ id: String, _: T.Type) -> T { add(id) }

  func deleteAll() {
    CoreDataStack.persistentContainer.managedObjectModel.entities.forEach { $0.name.map(all)?.forEach(delete) }
  }

  // MARK: - Fetching

  func all(_ type: String) -> [NSManagedObject] {
    try! fetch(NSFetchRequest<NSManagedObject>(entityName: type))
  }

  func all<T: BaseObject>() -> [T] {
    try! fetch(FetchRequest(type: T.self))
  }

  func all<T: BaseObject>(_: T.Type) -> [T] { all() }

  func first<T: BaseObject>() -> T? {
    let fr = FetchRequest(type: T.self)
    fr.fetchLimit = 1
    return try! fetch(fr).first
  }

  func first<T: BaseObject>(_: T.Type) -> T? { first() }

  func find<T: BaseObject>(_ id: String) -> T? {
    find(NSPredicate(format: "id = %@", id), limit: 1).first
  }

  func find<T: BaseObject>(_ id: String, _: T.Type) -> T? { find(id) }

  func find<T: BaseObject>(_ ids: [String]) -> [T] {
    find(NSPredicate(format: "id IN %@", ids))
  }

  func find<T: BaseObject>(_ ids: [String], _: T.Type) -> [T] { find(ids) }

  func find<T: BaseObject>(_ predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil, limit: Int? = nil, _: T.Type? = nil) -> [T] {
    let fr = FetchRequest(type: T.self)
    fr.predicate = predicate
    fr.sortDescriptors = sortDescriptors
    limit.map { fr.fetchLimit = $0 }
    return try! fetch(fr)
  }

  func find<T: BaseObject>(_ predicates: [NSPredicate], sortDescriptors: [NSSortDescriptor]? = nil, limit: Int? = nil, _: T.Type? = nil) -> [T] {
    find(NSCompoundPredicate(andPredicateWithSubpredicates: predicates), sortDescriptors: sortDescriptors, limit: limit)
  }

  func sorted<T: BaseObject>() -> [T] {
    find(sortDescriptors: T.sortDesc)
  }

  func sorted<T: BaseObject>(_: T.Type) -> [T] { sorted() }

  // MARK: - Counts

  func count<T: BaseObject>(_: T.Type) -> Int {
    try! count(for: FetchRequest(type: T.self))
  }

  func count<T: BaseObject>(_ predicate: NSPredicate?, _: T.Type) -> Int {
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
