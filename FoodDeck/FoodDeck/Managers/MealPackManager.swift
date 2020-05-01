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
static var mealPackRecipes : [(String, String)] = [("Italian", "Chocolate semifreddo"), ("British", "Treacle sponge cake"), ("American", "Smores dip"),("Italian", "Italian butter beans"),("Italian", "Italian Vegetable soup"), ("Italian", "Rustic bread"), ("Italian", "Panna cotta") , ("American", "Hot gumbo dip"), ("American", "Creamed corn"),  ("American", "Pancakes"), ("American", "Cheese Steak Hot Dogs"),  ("British", "Lemon Syllabub"), ("British", "Sausage with apple mash and gravy"), ("British", "Clotted cream rice pudding"), ("British", "Pear and blackberry crumble") ] //pre-defined meal pack names
 
 /*
    Fetches all meal packs from core data,
    Returns an array if type MealPackStr, the standard structure for meal packs.
*/
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
         //print("No meal packs found")
         return []
     }
 }
    
    /*
     Returns a meal pack object reference from core data
     Params: the name of the meal pack being retrieved
     Returns an array of either one meal pack object, or an empty array if no meal pack has been found
     */
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
            //print("No meal packs found")
            
        }
        return []
    }
/*
     Updates the meal packs in the database
     Params: An array of meal pack structures
     */
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
    /*
     Creates a new meal pack
     Params: The name of the new meal pack
     Returns TRUE if created successfully, FALSE if not
     */
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
    
    /*
     Retrieves all disabled meal packs so they can be excluded from the suggestions that are generated in SuggestionsGenerator
     Returns: Array of meal pack structures where the meal packs are disabled
     */
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
    /*
     Creates the meal packs based on our definitions of pre-defined meal packs on line 15
     Called when the app is first installed
     */
    static func makeMealPacks(){
        for name in mealPackNames{
            addMealPack(theName: name)
        }
        for recipe in mealPackRecipes {
            let theRecipe = RecipeManager.getRecipeObject(theName: recipe.1)[0]
            theRecipe.belongsTo = getMealPackObject(theName: recipe.0)[0]
        }
    }
}
