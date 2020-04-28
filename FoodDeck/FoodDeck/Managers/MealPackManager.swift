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
static var mealPackRecipes : [(String, String)] = [("Italian", "Chocolate semifreddo"), ("British", "Treacle sponge cake"), ("American", "Smores dip"),("Italian", "Italian butter beans"),("Italian", "Italian Vegetable soup"), ("Italian", "Rustic bread"), ("Italian", "Panna cotta") , ("American", "Hot gumbo dip"), ("American", "Creamed corn"),  ("American", "Pancakes"), ("American", "Cheese Steak Hot Dogs"),  ("British", "Lemon Syllabulb"), ("British", "Sausage with apple mash and gravy"), ("British", "clotted cream rice pudding"), ("British", "pear and blackberry crumble") ]
 
 // Fetch all meal packs from core data
 static func getMealPacks() -> [MealPackStr] {
     
     // Set up request to fetch data
     let appDelegate = UIApplication.shared.delegate as! AppDelegate
     let context = appDelegate.persistentContainer.viewContext
     let request : NSFetchRequest<MealPack> = MealPack.fetchRequest()
     request.returnsObjectsAsFaults = false
     
     // Run request
     do {
        tempMealPacksRtn.removeAll()
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
    
    static func getMealPackObject(theName : String) -> [MealPack]{
        var mealPackRtn : [MealPack] = []
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request : NSFetchRequest<MealPack> = MealPack.fetchRequest()
        request.returnsObjectsAsFaults = false
        
        // Run request
        do {
            let allMealPacks = try context.fetch(request)
            
            // Save results and return
            for mealPack in allMealPacks {
                if mealPack.name! == theName {
                    mealPackRtn.append(mealPack)
                    return mealPackRtn
                }
            }
        }
        catch {
            print("No meal packs found")
            
        }
        return []
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
                    //mealPack.setValue(updateMealPack.enabled, forKey: "enabled")
                    mealPack.enabled = updateMealPack.enabled
                    print(mealPack.enabled)
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
        tempMealPacksRtn.removeAll()
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
        print("made new meal packs")
        for name in mealPackNames{
            addMealPack(theName: name)
        }
        for recipe in mealPackRecipes {
            print(recipe.1)
            let theRecipe = RecipeManager.getRecipeObject(theName: recipe.1)[0]
            theRecipe.belongsTo = getMealPackObject(theName: recipe.0)[0]
        }
    }
}
