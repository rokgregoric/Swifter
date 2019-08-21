//
//  CoreDataStack.swift
//
//  Created by Rok Gregorič
//  Copyright © 2018 Rok Gregorič. All rights reserved.
//

import CoreData

class CoreDataStack {
  static var persistentContainer: NSPersistentContainer!

  static var context: NSManagedObjectContext {
    return persistentContainer.viewContext
  }

  static func initContainer(completion: @escaping (NSPersistentStoreDescription, Error?) -> Void) {
    persistentContainer = NSPersistentContainer(name: "db")
    persistentContainer.loadPersistentStores(completionHandler: completion)
  }

  static func initCoreDataStack(completion: @escaping () -> Void) {
    initContainer { desc, error in
      Log.debug(desc, context: "db")
      if let _ = error as NSError? {
        Log.error("flushing", context: "db")
        persistentContainer.persistentStoreDescriptions.compactMap { $0.url }.forEach {
          try? FileManager.default.removeItem(at: $0)
        }
        self.initContainer { _, error in
          if let error = error as NSError? {
            Log.error(error, context: "db")
          } else {
            completion()
          }
        }
      } else {
        completion()
      }
    }
  }
}
