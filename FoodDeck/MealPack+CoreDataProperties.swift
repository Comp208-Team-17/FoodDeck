//
//  MealPack+CoreDataProperties.swift
//  FoodDeck
//
//  Created by Elkehya, Sara Mruan M on 02/04/2020.
//  Copyright © 2020 computer science. All rights reserved.
//
//

import Foundation
import CoreData


extension MealPack {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MealPack> {
        return NSFetchRequest<MealPack>(entityName: "MealPack")
    }

    @NSManaged public var enabled: Bool
    @NSManaged public var name: String?
    @NSManaged public var contains: NSSet?

}

// MARK: Generated accessors for contains
extension MealPack {

    @objc(addContainsObject:)
    @NSManaged public func addToContains(_ value: Recipe)

    @objc(removeContainsObject:)
    @NSManaged public func removeFromContains(_ value: Recipe)

    @objc(addContains:)
    @NSManaged public func addToContains(_ values: NSSet)

    @objc(removeContains:)
    @NSManaged public func removeFromContains(_ values: NSSet)

}
