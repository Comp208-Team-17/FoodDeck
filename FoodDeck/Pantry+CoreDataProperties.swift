//
//  Pantry+CoreDataProperties.swift
//  FoodDeck
//
//  Created by Elkehya, Sara Mruan M on 02/04/2020.
//  Copyright © 2020 computer science. All rights reserved.
//
//

import Foundation
import CoreData


extension Pantry {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Pantry> {
        return NSFetchRequest<Pantry>(entityName: "Pantry")
    }

    @NSManaged public var amount: Int16
    @NSManaged public var contains: NSSet?

}

// MARK: Generated accessors for contains
extension Pantry {

    @objc(addContainsObject:)
    @NSManaged public func addToContains(_ value: Ingredient)

    @objc(removeContainsObject:)
    @NSManaged public func removeFromContains(_ value: Ingredient)

    @objc(addContains:)
    @NSManaged public func addToContains(_ values: NSSet)

    @objc(removeContains:)
    @NSManaged public func removeFromContains(_ values: NSSet)

}
