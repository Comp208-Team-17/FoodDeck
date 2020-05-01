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

    /*
     Restores the backup that the user has made
     */
    static func restoreCustomBackup(backupName: String){
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
    /*
     Exports the coreData when the export button is pressed
     */
   static func backup(backupName: String){
    deleteExistingBackup()
        let backUpFolderUrl = FileManager.default.urls(for: .documentDirectory, in:.userDomainMask).first!
        let backupUrl = backUpFolderUrl.appendingPathComponent(backupName + ".sqlite")
        let container = NSPersistentContainer(name: "FoodDeck")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in })

        let store:NSPersistentStore
        store = container.persistentStoreCoordinator.persistentStores.last!
        do {
            print(backupUrl)
            try container.persistentStoreCoordinator.migratePersistentStore(store,to: backupUrl,options: nil,withType: NSSQLiteStoreType)
        } catch {
            print("Failed to migrate")
        }
    }
    /*
     Imports the mealPack.sqlite files into the app
     */
    static func loadMealPacks(){
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
    /*
     Deletes the existing back-up when exporting, if such a backup exists
     */
   static func deleteExistingBackup(){
     let backUpFolderUrl = FileManager.default.urls(for: .documentDirectory, in:.userDomainMask).first!
    let backupUrl = backUpFolderUrl.appendingPathComponent("backup.sqlite")
    do{
        try FileManager.default.removeItem(at: backupUrl)
    }
    catch{
        print("Failed to delete backup")
    }
    
    
    }
}
 
