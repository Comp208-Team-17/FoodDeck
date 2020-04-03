//
//  Ingredient+CoreDataProperties.swift
//  FoodDeck
//
//  Created by Elkehya, Sara Mruan M on 02/04/2020.
//  Copyright © 2020 computer science. All rights reserved.
//
//

import Foundation
import CoreData


extension Ingredient {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Ingredient> {
        return NSFetchRequest<Ingredient>(entityName: "Ingredient")
    }

    @NSManaged public var enabled: Bool
    @NSManaged public var name: String?
    @NSManaged public var unit: String?
    @NSManaged public var inPantry: Pantry?
    @NSManaged public var inRecipe: NSSet?
    @NSManaged public var inShoppingList: ShoppingList?

}

// MARK: Generated accessors for inRecipe
extension Ingredient {

    @objc(addInRecipeObject:)
    @NSManaged public func addToInRecipe(_ value: RecipeIngredient)

    @objc(removeInRecipeObject:)
    @NSManaged public func removeFromInRecipe(_ value: RecipeIngredient)

    @objc(addInRecipe:)
    @NSManaged public func addToInRecipe(_ values: NSSet)

    @objc(removeInRecipe:)
    @NSManaged public func removeFromInRecipe(_ values: NSSet)

}
