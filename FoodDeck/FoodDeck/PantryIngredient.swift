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
    
    // return all ingredients in the pantry
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
}
