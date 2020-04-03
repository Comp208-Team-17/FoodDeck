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
    var tempIngredientRtn : [IngredientStr] = [IngredientStr()] // Stores the ingredient that will be returned if a calling function requests an ingredient
    struct IngredientStr{
    var name : String
    var unit : String
    var enabled : Bool
    init(theName : String, theUnit : String, isEnabled : Bool){
        name = theName
        unit = theUnit
        enabled = isEnabled
    }
    init(){
        name = ""
        unit = ""
        enabled = false
    }
    }
    func addIngredient(isEnabled : Bool, theName : String, theUnit : String) -> Bool {
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
    func deleteIngredient(theName : String) -> Bool{
        return checkExists(theName: theName, delete : true, get: false)
    }
    func updateIngredient(originalName : String, isEnabled: Bool, theName : String, theUnit : String) -> Bool{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request : NSFetchRequest<Ingredient> = Ingredient.fetchRequest()
        request.returnsObjectsAsFaults = false
        do{
            let fetchedIngredients = try context.fetch(request)
            for theIngredient in fetchedIngredients{
                if theIngredient.name == originalName && checkExists(theName : theName, delete: false, get: false){
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
    func getIngredient(theName : String, enabled : Bool, all : Bool) -> [IngredientStr] {
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
    func checkExists(theName : String, delete : Bool, get: Bool) -> Bool{
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
                        tempIngredientRtn[0].enabled = theIngredient.enabled
                        tempIngredientRtn[0].name = theIngredient.name!
                        tempIngredientRtn[0].unit = theIngredient.unit!
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
