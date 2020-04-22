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

}
