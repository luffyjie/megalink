//
//  MGLCoreDataHelper.swift
//  FastPayiOS
//
//  Created by ios on 2020/9/10.
//  Copyright © 2020 FastPay. All rights reserved.
//

import UIKit
import CoreData

class MGLCoreDataHelper: NSObject {
    
    private let storeFileName = "store.sqlite"
    var context: NSManagedObjectContext
    var model: NSManagedObjectModel
    var coordinator: NSPersistentStoreCoordinator
    var store: NSPersistentStore?
    
    override init() {
        model = NSManagedObjectModel.mergedModel(from: nil)!
        coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = coordinator
    }
    
    func setupCoreData() {
        loadStore()
    }
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                
            }
        }
    }
    
    func loadStore() {
        guard (store != nil) else {
            do {
                let options = [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true]
                try store = coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeUrl(), options: options)
            } catch {
                
            }
            return
        }
    }
    
    func applicationDocumentsDirectory() -> String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
    }
    
    func applicationStoresDirectory() -> URL {
        let storesDirectory = URL(fileURLWithPath: applicationDocumentsDirectory()).appendingPathComponent("Stores")
        if !FileManager.default.fileExists(atPath: storesDirectory.path) {
            do {
                try FileManager.default.createDirectory(at: storesDirectory, withIntermediateDirectories: true, attributes: nil)
            } catch {
                
            }
        }
        return storesDirectory
    }
    
    func storeUrl() -> URL {
        return applicationStoresDirectory().appendingPathComponent(storeFileName)
    }
}
