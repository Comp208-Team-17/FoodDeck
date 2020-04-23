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
    
    // subtracts an array of recipe ingredients from the pantry
    static func subtractRecipeIngredient(recipeIngredients: [RecipeIngredient], on: UIViewController ) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        var error = false
        
        do {
            for index in 0..<recipeIngredients.count {
                let theIngredient = recipeIngredients[index].ingredient
                // if ingredient exists in pantry
                if  theIngredient?.pantryIngredient != nil {
                    let value = Int((theIngredient?.pantryIngredient!.amount)!) - Int(recipeIngredients[index].amount)
                    // check if within limit -> 0
                    if value == 0 {
                        managedContext.delete((theIngredient?.pantryIngredient!)!)
                    }
                    else if value > 0 {
                        theIngredient?.pantryIngredient!.setValue(value, forKey: "amount")
                    }
                    else {
                        error = true
                        break
                    }
                }
                else {
                    error = true
                    break
                }
            }
            
            if error == true {
                managedContext.rollback()
                // present error to user
                let alert = UIAlertController(title: "Not enough ingredients", message: "Lack of ingredients in your pantry to cook this meal", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                
                // show the alert
                on.present(alert, animated: true, completion: nil)
            }
            else if error == false {
                // save changes
                try managedContext.save()
            }
            
           
            
        } catch {
            print("Pantry could not be updated")
        }
    }
}
