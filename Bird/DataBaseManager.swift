//
//  DataBaseManager.swift
//  Bird
//
//  Created by Pavel Burdukovskii on 11/04/18.
//  Copyright © 2018 Pavel Burdukovskii. All rights reserved.
//

import Foundation
import CoreData
class DataBaseManager {
    
    public static var shared  : DataBaseManager = {
        return DataBaseManager()
    }()
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Bird")
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
    
    func saveContext (_ arr : AnyObject, entityName : String, key: String...) {
        let context = persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: context)
        let object = NSManagedObject(entity: entity!, insertInto: context)
        print(arr)
        for index in key{
            
            object.setValue(arr, forKey: index)
        }
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
   
    func fetchFromCoreData(entityName : String, key: String...) -> AnyObject{
        let context = persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        var returnObject  : AnyObject = 0 as AnyObject
        request.returnsObjectsAsFaults = false
        do {
           let result = try context.fetch(request)
            for res in result as! [NSManagedObject] {
                for index in key{
                    print("asdasdddas")
                 returnObject = res.value(forKey: index) as AnyObject
                    print("qweqwe")

                }
            }
        } catch {
            print("Failed")

        }
        print(returnObject)
        return returnObject
    }
}
