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
    
    
    static func addIngredient(isEnabled : Bool, theName : String, theUnit : String) -> Bool {
        if checkExists(theName : theName, delete: false, get: false){
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let newIngredient = Ingredient(context : context)
            newIngredient.enabled = isEnabled
            newIngredient.name = theName
            newIngredient.unit = theUnit
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
    static func deleteIngredient(theName : String) -> Bool{
        return checkExists(theName: theName, delete : true, get: false)
    }
    static func updateIngredient(originalName : String, isEnabled: Bool, theName : String, theUnit : String) -> Bool{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request : NSFetchRequest<Ingredient> = Ingredient.fetchRequest()
        request.returnsObjectsAsFaults = false
        do{
            let fetchedIngredients = try context.fetch(request)
            for theIngredient in fetchedIngredients{
                if theIngredient.name == originalName && originalName == theName ? true : checkExists(theName : theName, delete: false, get: false){
                    theIngredient.enabled = isEnabled
                    theIngredient.name = theName
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
    static func getIngredient(theName : String, enabled : Bool, all : Bool) -> [IngredientStr] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request : NSFetchRequest<Ingredient> = Ingredient.fetchRequest()
        request.returnsObjectsAsFaults = false
        do {
            tempIngredientRtn.removeAll()
            let allIngredients = try context.fetch(request)
            if enabled == true {
                for theIngredient in allIngredients{
                    if theIngredient.enabled{
                        tempIngredientRtn.append(IngredientStr(theName : theIngredient.name!, theUnit: theIngredient.unit!, isEnabled : theIngredient.enabled))
                    }
                }
                return tempIngredientRtn
            }
                
            else if all == true{
                for theIngredient in allIngredients{
                    tempIngredientRtn.append(IngredientStr(theName : theIngredient.name!, theUnit: theIngredient.unit!, isEnabled : theIngredient.enabled))
                }
                return tempIngredientRtn
            }
            else if enabled == false && theName == "" {
                for theIngredient in allIngredients{
                    if theIngredient.enabled == false{
                        tempIngredientRtn.append(IngredientStr(theName : theIngredient.name!, theUnit: theIngredient.unit!, isEnabled : theIngredient.enabled))
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
    static func getIngredientObject(theName : String) -> [NSManagedObject]{
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
    static func checkExists(theName : String, delete : Bool, get: Bool) -> Bool{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request : NSFetchRequest<Ingredient> = Ingredient.fetchRequest()
        request.returnsObjectsAsFaults = false
        do{
            let fetchedIngredients = try context.fetch(request)
            for theIngredient in fetchedIngredients{
                if theIngredient.name == theName{
                    if delete == true{
                        context.delete(theIngredient)
                        do{
                            try context.save()
                            return true
                        }
                        catch{}
                    }
                    else if get == true {
                        tempIngredientRtn.append(IngredientStr(theName: theIngredient.name!, theUnit: theIngredient.unit!, isEnabled: theIngredient.enabled))
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
