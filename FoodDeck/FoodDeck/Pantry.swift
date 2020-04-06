//
//  Pantry.swift
//  FoodDeck
//
//  Created by Elkehya, Sara Mruan M on 06/04/2020.
//  Copyright © 2020 computer science. All rights reserved.
//

import UIKit
import CoreData

@objc(Pantry)

class Pantry: NSManagedObject {
    var ingredients: [Ingredient]? {
        return self.contains?.array as? [Ingredient]
    }
    convenience init?(amount: Int) {
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return nil }
        
        self.init(entity: Pantry.entity(), insertInto: managedContext)
        self.amount = Int16(amount)
    }
}
