//
//  CoreDataManager.swift
//  ToDo-List
//
//  Created by 陳列 on 2022/3/30.
//

import Foundation
import CoreData

class CoreDataManager: NSObject {
    static let shared = CoreDataManager()
    override init() {}
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "ToDo_List")
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
        return container
    }()

    // MARK: - Core Data Saving support

    func managedObjectContext() -> NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext () {
        if managedObjectContext().hasChanges {
            do {
                try managedObjectContext().save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func loadFromCoreData(data: inout [ToDoList]) {
        let moc = persistentContainer.viewContext
        let request = NSFetchRequest<ToDoList>(entityName: "ToDoList")
        let sort  = NSSortDescriptor(key: "date", ascending: true)
        request.sortDescriptors = [sort]
        moc.performAndWait {
            do {
                let results = try moc.fetch(request)
                data = results
            } catch {
                print("error\(error)")
                data = []
            }
        }
    }
    
    func deleteFromCoreData(data: ToDoList) {
        let moc = managedObjectContext()
        moc.performAndWait {
            moc.delete(data)
        }
        saveContext()
    }
}
