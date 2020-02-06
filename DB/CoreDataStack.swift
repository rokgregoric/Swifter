//
//  CoreDataStack.swift
//
//  Created by Rok Gregorič
//  Copyright © 2018 Rok Gregorič. All rights reserved.
//

import CoreData

class CoreDataStack {
  static var name = "db"
  static var persistentContainer = NSPersistentContainer(name: name)

  static var context: NSManagedObjectContext { return persistentContainer.viewContext }

  static var inMemoryContext: NSManagedObjectContext {
    let psc = NSPersistentStoreCoordinator(managedObjectModel: persistentContainer.managedObjectModel)
    _ = try? psc.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil)
    let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    context.persistentStoreCoordinator = psc
    return context
  }

  enum CompletionStatus {
    case normal, deleted
  }

  static func setup(completion: @escaping (CompletionStatus) -> Void) {
    persistentContainer.loadPersistentStores { desc, err in
      Log.debug(desc, context: "db")
      if let _ = err as NSError? {
        Log.error("flushing", context: "db")
        persistentContainer.persistentStoreDescriptions.forEach { try? $0.url.map(FileManager.default.removeItem) }
        persistentContainer.loadPersistentStores { _, err in
          if let err = err as NSError? {
            Log.error(err, context: "db")
          } else {
            completion(.deleted)
          }
        }
      } else {
        completion(.normal)
      }
    }
  }
}
