//
//  MealPackManager.swift
//  FoodDeck
//
//  Created by Gabrielle Magruder on 04/04/2020.
//  Copyright © 2020 computer science. All rights reserved.
//

import UIKit
import CoreData

class MealPackManager: NSManagedObject {
 static var tempMealPacksRtn: [MealPackStr] = []
 static var mealPackNames : [String] = ["Italian", "British", "American"]
    static var mealPackRecipes : [(String, String)] = [("Italian", "Spaghetti Carbonara"), ("British", "Corned Beef Hash"), ("American", "CheeseBurger")]
 
 // Fetch all meal packs from core data
 static func getMealPacks() -> [MealPackStr] {
     
     // Set up request to fetch data
     let appDelegate = UIApplication.shared.delegate as! AppDelegate
     let context = appDelegate.persistentContainer.viewContext
     let request : NSFetchRequest<MealPack> = MealPack.fetchRequest()
     request.returnsObjectsAsFaults = false
     
     // Run request
     do {
         let allMealPacks = try context.fetch(request)
         
         // Save results and return
         for mealPack in allMealPacks {
             tempMealPacksRtn.append(MealPackStr(theName: mealPack.name!, isEnabled: mealPack.enabled))
         }
         
         return tempMealPacksRtn
     }
     catch {
         print("No meal packs found")
         return []
     }
 }
    
 // Update status of all meal paks
    static func updateMealPack(newMealPacks: [MealPackStr]) {
     // Set up request
     let appDelegate = UIApplication.shared.delegate as! AppDelegate
     let context = appDelegate.persistentContainer.viewContext
     let request : NSFetchRequest<MealPack> = MealPack.fetchRequest()
     request.returnsObjectsAsFaults = false
    // Run request
    do {
        let allMealPacks = try context.fetch(request)
        
        // Update each meal pack
        for mealPack in allMealPacks {
            // Compare each unique meal pack name and update enabled status
            for updateMealPack in newMealPacks {
                if (mealPack.name == updateMealPack.name) {
                    mealPack.setValue(updateMealPack.enabled, forKey: "enabled")
                }
            }
        }
        
        // Save changes to core data
        try context.save()
        
    }
    catch {
        print("No meal packs found - cannot update")
    }
  }
    static func addMealPack(theName: String) -> Bool{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let newMealPack = MealPack(context : context)
        newMealPack.enabled = true
        newMealPack.name = theName
        do{
            try context.save()
            return true
        }
        catch{
            return false
        }
    }
    
    // Fetch all disabled meal packs
    static func getDisabledMealPacks() -> [MealPackStr] {
        // Set up request to fetch data
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request : NSFetchRequest<MealPack> = MealPack.fetchRequest()
        request.returnsObjectsAsFaults = false
        
        // Run request
        do {
            let allMealPacks = try context.fetch(request)
            
            // Save results and return
            for mealPack in allMealPacks {
                if (mealPack.enabled == false){
                    tempMealPacksRtn.append(MealPackStr(theName: mealPack.name!, isEnabled: mealPack.enabled))
                }
            }
            return tempMealPacksRtn
        }
        catch {
            print("No meal packs found")
            return []
        }
    }
    static func makeMealPacks(){
        for name in mealPackNames{
            addMealPack(theName: name)
        }
        for recipes in mealPackRecipes {
            
        }
    }
}
