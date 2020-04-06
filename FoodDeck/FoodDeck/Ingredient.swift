//
//  Ingredient.swift
//  FoodDeck
//
//  Created by Elkehya, Sara Mruan M on 06/04/2020.
//  Copyright © 2020 computer science. All rights reserved.
//

import UIKit
import CoreData

@objc(Ingredient)
class Ingredient: NSManagedObject {
    convenience init?(enabled: Bool, name: String, unit: String) {
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            guard let managedContext = appDelegate?.persistentContainer.viewContext else { return nil }
            
            self.init(entity: Pantry.entity(), insertInto: managedContext)
            self.enabled = enabled
            self.name = name
            self.unit = unit
        }
}
