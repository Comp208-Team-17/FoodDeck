//
//  ImportExportManager.swift
//  FoodDeck
//
//  Created by Luke Wood on 25/04/2020.
//  Copyright © 2020 computer science. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class ImportExportManager: NSManagedObject {
    func importMealPack(fileName: String) {
        
    }
    func exportAll(caller : SettingsViewController){
        
    }
    static func importMealPackAll(){
        
    }
    static func backup(backupName: String){
        print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
        let backUpFolderUrl = FileManager.default.urls(for: .documentDirectory, in:.userDomainMask).first!
        let backupUrl = backUpFolderUrl.appendingPathComponent(backupName + ".sqlite")
        let container = NSPersistentContainer(name: "FoodDeck")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in })

        let store:NSPersistentStore
        store = container.persistentStoreCoordinator.persistentStores.last!
        do {
            try container.persistentStoreCoordinator.migratePersistentStore(store,to: backupUrl,options: nil,withType: NSSQLiteStoreType)
        } catch {
            print("Failed to migrate")
        }
    }
    static func preloadDBData() {
        let sqlitePath = Bundle.main.path(forResource: "crap2", ofType: "sqlite")
        let sqlitePath_shm = Bundle.main.path(forResource: "crap2", ofType: "sqlite-shm")
        let sqlitePath_wal = Bundle.main.path(forResource: "crap2", ofType: "sqlite-wal")

        let URL1 = URL(fileURLWithPath: sqlitePath!)
        let URL2 = URL(fileURLWithPath: sqlitePath_shm!)
        let URL3 = URL(fileURLWithPath: sqlitePath_wal!)
        let URL4 = URL(fileURLWithPath: NSPersistentContainer.defaultDirectoryURL().relativePath + "/MyDB.sqlite")
        let URL5 = URL(fileURLWithPath: NSPersistentContainer.defaultDirectoryURL().relativePath + "/MyDB.sqlite-shm")
        let URL6 = URL(fileURLWithPath: NSPersistentContainer.defaultDirectoryURL().relativePath + "/MyDB.sqlite-wal")

        if !FileManager.default.fileExists(atPath: NSPersistentContainer.defaultDirectoryURL().relativePath + "/MyDB.sqlite") {
            // Copy 3 files
            do {
                try FileManager.default.copyItem(at: URL1, to: URL4)
                try FileManager.default.copyItem(at: URL2, to: URL5)
                try FileManager.default.copyItem(at: URL3, to: URL6)

                print("=======================")
                print("FILES COPIED")
                print("=======================")

            } catch {
                print("=======================")
                print("ERROR IN COPY OPERATION")
                print("=======================")
            }
        } else {
            print("=======================")
            print("FILES EXIST")
            print("=======================")
        }
    }
    static func restoreFromStore1(backupName: String){
        
        let storeFolderUrl = FileManager.default.urls(for: .applicationSupportDirectory, in:.userDomainMask).first!
        let storeUrl = storeFolderUrl.appendingPathComponent("FoodDeck.sqlite")
        let backUpFolderUrl = FileManager.default.urls(for: .documentDirectory, in:.userDomainMask).first!
        let backupUrl = backUpFolderUrl.appendingPathComponent(backupName + ".sqlite")

        let container = NSPersistentContainer(name: "FoodDeck")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            let stores = container.persistentStoreCoordinator.persistentStores

            for store in stores {
                print(store)
                print(container)
            }
            do{
                try container.persistentStoreCoordinator.replacePersistentStore(at: storeUrl,destinationOptions: nil,withPersistentStoreFrom: backupUrl,sourceOptions: nil,ofType: NSSQLiteStoreType)
            } catch {
                print("Failed to restore")
            }

        })

    }
    static func restoreFromStore(backupName: String){
           
           let storeFolderUrl = FileManager.default.urls(for: .applicationSupportDirectory, in:.userDomainMask).first!
           let storeUrl = storeFolderUrl.appendingPathComponent("FoodDeck.sqlite")
           let backupUrl = Bundle.main.url(forResource: "mealPack", withExtension: "sqlite")

           let container = NSPersistentContainer(name: "FoodDeck")
           container.loadPersistentStores(completionHandler: { (storeDescription, error) in
               let stores = container.persistentStoreCoordinator.persistentStores

               for store in stores {
                   print(store)
                   print(container)
               }
               do{
                try container.persistentStoreCoordinator.replacePersistentStore(at: storeUrl,destinationOptions: nil,withPersistentStoreFrom: backupUrl!,sourceOptions: nil,ofType: NSSQLiteStoreType)
               } catch {
                   print("Failed to restore")
               }

           })

       }

}
 
