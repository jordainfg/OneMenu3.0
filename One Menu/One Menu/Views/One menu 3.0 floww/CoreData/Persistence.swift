//
//  Persistence.swift
//  Shared
//
//  Created by Jordain on 25/08/2021.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    /*:
     The preview property allows us to use the CoreData functionality inside preview simulators.
     */
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for _ in 0..<10 {
                    let newItem = FavoritedConsumable(context: viewContext)
                    newItem.consumableID = "consumable1"
                    newItem.restaurantID = "restaurant1"
                }
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    
    
    /*:
     The container property is the heart of the PersistenceController, which performs many different operations for us in the background when we store and call data. Most importantly, the container allows us to access the so-called viewContext, which serves as in an in-memory scratchpad where objects are created, fetched, updated, deleted, and saved back to the persistent store of the device where the app runs on.
     */
    let container: NSPersistentContainer

    
    /*:
     The container gets initialized within the below PersistenceController’s init function.
     */
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "OneMenu")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                Typical reasons for an error here include:
                * The parent directory does not exist, cannot be created, or disallows writing.
                * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                * The device is out of space.
                * The store could not be migrated to the current model version.
                Check the error message to determine what the actual problem was.
                */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
    
    /**
     You’re going to also need a way of saving any data to disk, because Core Data does not handle that automatically.
     
     This creates a method called `saveContext()` which does the following:
      * Obtain the `viewContext` of the persistent container. This is a special managed object context which is designated for use only on the main thread. You’ll use this one to save any unsaved data.
      * Save only if there are changes to save.
      * Save the context. This call may throw an error, so it’s wrapped in a try/catch.
      * In the event of an error, it’s logged and the app killed. Just like in the previous method, any errors here should only happen during development, but should be handled appropriately in your application just in case.
     */
    func saveContext() {
      // 1
      let context = container.viewContext
      // 2
      if context.hasChanges {
        do {
          // 3
          try context.save()
        } catch {
          // 4
          // The context couldn't be saved.
          // You should add your own error handling here.
          let nserror = error as NSError
          fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
      }
    }
}
