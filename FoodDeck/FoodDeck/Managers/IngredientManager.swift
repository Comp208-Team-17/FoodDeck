//
//  IngredientManager.swift
//  FoodDeck
//
//  Created by Luke Wood on 02/04/2020.
//  Copyright © 2020 computer science. All rights reserved.
//

import UIKit
import CoreData
class IngredientManager: NSManagedObject {
    static var tempIngredientRtn : [IngredientStr] = [] // Stores the ingredient that will be returned if a calling function requests an ingredient
  
    /*
     Adds a new ingredient
     Params:
     enabled - true/false
     name of new recipe
     unit - "U" for units, "G" for grams/ml
     
     Returns true/false depending on success
     */
    static func addIngredient(isEnabled : Bool, theName : String, theUnit : String) -> Bool {
        if checkExists(theName : theName, delete: false, get: false){
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let newIngredient = Ingredient(context : context)
            newIngredient.enabled = isEnabled
            newIngredient.name = theName.capitalizingFirstLetter()
            newIngredient.unit = theUnit
            newIngredient.inMealPack = false
            do{
                try context.save()
                return true
            }
            catch{
                return false
            }
        }
        return false
        
    }
    /*
     Deletes an ingredient
     Params: name of ingredient to delete
     Returns true/false depending on success
     */
    static func deleteIngredient(theName : String) -> Bool{
        return checkExists(theName: theName, delete : true, get: false)
    }
    /*
     Updates an ingredient
     Params:
     originalName - the name originally set for the recipe
     Other paramaters are what are being changes
     
     Returns true/false depending on success
     */
    static func updateIngredient(originalName : String, isEnabled: Bool, theName : String, theUnit : String) -> Bool{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request : NSFetchRequest<Ingredient> = Ingredient.fetchRequest()
        request.returnsObjectsAsFaults = false
        do{
            let fetchedIngredients = try context.fetch(request)
            for theIngredient in fetchedIngredients{
                if theIngredient.name == originalName && (originalName == theName ? true : checkExists(theName : theName.capitalizingFirstLetter(), delete: false, get: false)){
                    theIngredient.enabled = isEnabled
                    theIngredient.name = theName.capitalizingFirstLetter()
                    theIngredient.unit = theUnit
                    do{
                        try context.save()
                        return true
                    }
                    catch{
                        return false
                    }
                }
            }
        }
        catch {
            return false
        }
        return false
    }
    /*
      Gets either one, or all ingredients.
      Params: The name of the recipe to be retrieved or "" if all ingredients being searched
     An all boolean which is TRUE if retrieving all ingredients. FALSE if just retrieving one
      
      Returns an empty array if no ingredient has been found
      Returns an array of one item if searching for an ingredient and there is a match
      Returns all ingredients in the array if the all bool has been set to true on the params
     */
    static func getIngredient(theName : String, enabled : Bool, all : Bool) -> [IngredientStr] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request : NSFetchRequest<Ingredient> = Ingredient.fetchRequest()
        request.returnsObjectsAsFaults = false
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        do {
            tempIngredientRtn.removeAll()
            let allIngredients = try context.fetch(request)
            
            if enabled == true {
                for theIngredient in allIngredients{
                    if theIngredient.enabled{
                        tempIngredientRtn.append(IngredientStr(theName : theIngredient.name!, theUnit: theIngredient.unit!, isEnabled : theIngredient.enabled, isInMealPack: theIngredient.inMealPack))
                    }
                }
                return tempIngredientRtn
            }
            else if all == true{
                for theIngredient in allIngredients{
                    tempIngredientRtn.append(IngredientStr(theName : theIngredient.name!, theUnit: theIngredient.unit!, isEnabled : theIngredient.enabled, isInMealPack: theIngredient.inMealPack))
                }
                return tempIngredientRtn
            }
            else if enabled == false && theName == "" {
                for theIngredient in allIngredients{
                    if theIngredient.enabled == false{
                        tempIngredientRtn.append(IngredientStr(theName : theIngredient.name!, theUnit: theIngredient.unit!, isEnabled : theIngredient.enabled, isInMealPack: theIngredient.inMealPack))
                    }
                }
                return tempIngredientRtn
            }
        }
        catch{
            return []
        }
        
        if checkExists(theName: theName, delete: false, get: true) == true {
            return tempIngredientRtn
        }
        else{
            return []
        }
        
    }
    /*
       Gets an ingredient object
       Params: The name of the ingredient
       Returns: An array of objects of type Ingredient. Either has 1 or 0 elements
       Has 0 elements returned if there is no such ingredient matching that name.
       */
    static func getIngredientObject(theName : String) -> [Ingredient]{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request : NSFetchRequest<Ingredient> = Ingredient.fetchRequest()
        request.returnsObjectsAsFaults = false
        do{
            let allIngredients = try context.fetch(request)
            for ingredient in allIngredients{
                if ingredient.name == theName {
                    return [ingredient]
                }
            }
        }
        catch{}
        return []
    }
    /*
        Local helper function to check if an ingredient exists and then either retrieve or delete it.
        Params:
        theName: the name of the ingredient
        delete: if said ingredient should be deleted if found
        get: if said ingredient should be retrieved
        
        Returns true if the action was successful, false if not.
        */
   private static func checkExists(theName : String, delete : Bool, get: Bool) -> Bool{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request : NSFetchRequest<Ingredient> = Ingredient.fetchRequest()
        request.returnsObjectsAsFaults = false
        do{
            let fetchedIngredients = try context.fetch(request)
            for theIngredient in fetchedIngredients{
                if theIngredient.name?.lowercased() == theName.lowercased(){
                    if delete == true{
                        context.delete(theIngredient)
                        do{
                            try context.save()
                            return true
                        }
                        catch{}
                    }
                    else if get == true {
                        tempIngredientRtn.append(IngredientStr(theName: theIngredient.name!, theUnit: theIngredient.unit!, isEnabled: theIngredient.enabled, isInMealPack: theIngredient.inMealPack))
                        return true
                    }
                    return false
                }
            }
        }
        catch {
            return false
        }
        return true
    }
}

// the following method is now applicable to all strings/
/*
 Auto capitalises the ingredients.
 */
extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}


