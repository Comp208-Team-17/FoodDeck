//
//  Recipe+CoreDataProperties.swift
//  FoodDeck
//
//  Created by Elkehya, Sara Mruan M on 02/04/2020.
//  Copyright © 2020 computer science. All rights reserved.
//
//

import Foundation
import CoreData


extension Recipe {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Recipe> {
        return NSFetchRequest<Recipe>(entityName: "Recipe")
    }

    @NSManaged public var available: Bool
    @NSManaged public var cookTime: Int16
    @NSManaged public var dateCreated: Date?
    @NSManaged public var favourite: Bool
    @NSManaged public var instructions: String?
    @NSManaged public var name: String?
    @NSManaged public var prepTime: Int16
    @NSManaged public var rating: Int16
    @NSManaged public var recipeDescription: String?
    @NSManaged public var score: Int16
    @NSManaged public var servings: Int16
    @NSManaged public var thumbnail: Data?
    @NSManaged public var timeOfDay: String?
    @NSManaged public var allergen: String?
    @NSManaged public var dietaryRequirements: String?
    @NSManaged public var belongsTo: MealPack?
    @NSManaged public var contains: NSSet?

}

// MARK: Generated accessors for contains
extension Recipe {

    @objc(addContainsObject:)
    @NSManaged public func addToContains(_ value: RecipeIngredient)

    @objc(removeContainsObject:)
    @NSManaged public func removeFromContains(_ value: RecipeIngredient)

    @objc(addContains:)
    @NSManaged public func addToContains(_ values: NSSet)

    @objc(removeContains:)
    @NSManaged public func removeFromContains(_ values: NSSet)

}
