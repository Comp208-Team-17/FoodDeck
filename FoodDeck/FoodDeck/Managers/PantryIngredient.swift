//
//  PantryIngredient.swift
//  FoodDeck
//
//  Created by Elkehya, Sara Mruan M on 16/04/2020.
//  Copyright © 2020 computer science. All rights reserved.
//


import Foundation
import CoreData
import UIKit

@objc(PantryIngredient)

class PantryIngredient: NSManagedObject {
    
    // return pantry as type pantryIngredient
    static func getPantry() -> [PantryIngredient] {
        var inPantry : [PantryIngredient] = []
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchPantry: NSFetchRequest<PantryIngredient>  = PantryIngredient.fetchRequest()
        do {
            inPantry = try managedContext.fetch(fetchPantry)
        } catch {
            print("could not retrieve ingredients")
        }
        return inPantry
    }
    
    // return all ingredients in pantry
    static func getAllPanryIngredients() -> [Ingredient] {
        var inPantry : [PantryIngredient] = []
        var pantryList : [Ingredient] = []
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchPantry: NSFetchRequest<PantryIngredient>  = PantryIngredient.fetchRequest()
        do {
            inPantry = try managedContext.fetch(fetchPantry)
        } catch {
            print("could not retrieve ingredients")
        }
        for index in 0..<inPantry.count {
            pantryList.append(inPantry[index].belongsTo!)
        }
        return pantryList
    }
    
    static func subtractRecipeIngredient(recipeIngredient: RecipeIngredient, on: UIViewController ) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        
        
        do {
            let theIngredient = recipeIngredient.ingredient
            // if ingredient exists in pantry
            if  theIngredient?.pantryIngredient != nil {
                let value = Int((theIngredient?.shoppingList!.amount)!) - Int(recipeIngredient.amount)
                // check if within limit -> 0
                if value >= 0 {
                    theIngredient?.pantryIngredient!.setValue(value, forKey: "amount")
                }
                else {
                    // present error to user
                    let alert = UIAlertController(title: "Invaid quantity", message: "One or more of the ingredients selected could not be added to the pantry", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    
                    // show the alert
                    on.present(alert, animated: true, completion: nil)
                }
            }
            // save changes
            try managedContext.save()
            
        } catch {
            print("Pantry and shopping list could not be updated")
        }
    }
}
