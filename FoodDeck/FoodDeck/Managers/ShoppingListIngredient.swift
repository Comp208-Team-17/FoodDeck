//
//  ShoppingListIngredient.swift
//  FoodDeck
//
//  Created by Elkehya, Sara Mruan M on 16/04/2020.
//  Copyright © 2020 computer science. All rights reserved.
//

import Foundation
import CoreData
import UIKit

@objc(ShoppingListIngredient)

class ShoppingListIngredient: NSManagedObject {
    // return pantry as type ShoppingListIngredient
    static func getShoppingList() -> [ShoppingListIngredient] {
        var inShoppingList : [ShoppingListIngredient] = []
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchPantry: NSFetchRequest<ShoppingListIngredient>  = ShoppingListIngredient.fetchRequest()
        do {
            inShoppingList = try managedContext.fetch(fetchPantry)
        } catch {
            print("could not retrieve ingredients")
        }
        return inShoppingList
    }
    
    // return all ingredients in Shopping list
    static func getAllShoppingListIngredients() -> [Ingredient] {
        var inShoppingList : [ShoppingListIngredient] = []
        var shoppingListIngredients : [Ingredient] = []
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchPantry: NSFetchRequest<ShoppingListIngredient>  = ShoppingListIngredient.fetchRequest()
        do {
            inShoppingList = try managedContext.fetch(fetchPantry)
        } catch {
            print("could not retrieve ingredients")
        }
        for index in 0..<inShoppingList.count {
            shoppingListIngredients.append(inShoppingList[index].belongsTo!)
        }
        return shoppingListIngredients
    }
    
    // add ingredient to shopping list
    static func addFromRecipe(recipeIngredient: RecipeIngredient, on: UIViewController)  {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let theIngredient = recipeIngredient.ingredient
        do {
            // if ingredient already exists in shopping list
            if  theIngredient?.shoppingList != nil {
                let value = Int(recipeIngredient.amount) + Int((theIngredient?.shoppingList!.amount)!)
                // check if within limit -> 32767
                if value <= Int16.max{
                    theIngredient?.shoppingList!.setValue(value, forKey: "amount")
                }
                else {
                    // present error to user
                    let alert = UIAlertController(title: "Invaid quantity", message: "One or more of the ingredients selected could not be added to the pantry", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    
                    // show the alert
                    on.present(alert, animated: true, completion: nil)
                }
            }
            else {
                // add igredient to list
                let ShoppingListIngredientEntity = NSEntityDescription.entity(forEntityName: "ShoppingListIngredient", in: managedContext)!
                let newShoppingListIngredient = NSManagedObject(entity: ShoppingListIngredientEntity, insertInto: managedContext)
                newShoppingListIngredient.setValue(recipeIngredient.amount, forKey: "amount")
                newShoppingListIngredient.setValue(theIngredient, forKey: "belongsTo")
            }
            // save changes
            try managedContext.save()
            
        } catch {
            print("Pantry and shopping list could not be updated")
        }
        
    }
    
}
