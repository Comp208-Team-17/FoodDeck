//
//  RecipeIngredient+CoreDataProperties.swift
//  FoodDeck
//
//  Created by Elkehya, Sara Mruan M on 02/04/2020.
//  Copyright © 2020 computer science. All rights reserved.
//
//

import Foundation
import CoreData


extension RecipeIngredient {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecipeIngredient> {
        return NSFetchRequest<RecipeIngredient>(entityName: "RecipeIngredient")
    }

    @NSManaged public var amount: Int16
    @NSManaged public var optional: Bool
    @NSManaged public var belongsTo: Recipe?
    @NSManaged public var ingredient: Ingredient?

}
