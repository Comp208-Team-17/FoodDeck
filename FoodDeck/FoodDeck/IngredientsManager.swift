//
//  IngredientsManager.swift
//  FoodDeck
//
//  Created by Luke Wood on 31/03/2020.
//  Copyright © 2020 computer science. All rights reserved.
//
import CoreData
import UIKit
class IngredientsManager: NSManagedObject {
    struct Ingredient{
        var name : String
        var unit : String
        var enabled : Bool
        init(theName : String, theUnit : String, isEnabled : Bool){
            name = theName
            unit = theUnit
            enabled = isEnabled
        }
    }
    var ingredients : [Ingredient] = []
    
    func updateIngredients(){
        ingredients.removeAll()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ingreident")
        request.returnsObjectsAsFaults = false
        do{
            let result = try managedContext.fetch(request)
            for data in result as! [NSManagedObject] {
                ingredients.append(Ingredient(theName: data.value(forKey:"name") as! String, theUnit: data.value(forKey:"unit") as! String, isEnabled: data.value(forKey:"enabled") as! Bool) )
            }
        }
        catch{
            print("updating ingredients array failed")
        }
    }
    func deleteIngredient(theName : String){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ingreident")
        request.predicate = NSPredicate(format: "name = %@", theName)
        do{
            let deletion = try managedContext.fetch(request)
            let toDelete = deletion[0] as! NSManagedObject
            managedContext.delete(toDelete)
            do{
                try managedContext.save()
            }
            catch{
                print("error deleting ingredient - issue saving context")
            }
        }
        catch{
            print("error deleting ingredient")
        }
    }
    func addIngredient(theName : String, theUnit : String, isEnabled: Bool){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        let ingredientEntity = NSEntityDescription.entity(forEntityName: "Ingredent", in: managedContext)!
        let anIngredient = NSManagedObject(entity: ingredientEntity, insertInto: managedContext)
        anIngredient.setValue(theName, forKey: "name")
        anIngredient.setValue(theUnit, forKey: "unit")
        anIngredient.setValue(isEnabled, forKey: "enabled")
        do {
            try managedContext.save()
           } catch {
            print("Failed saving")
         }
        updateIngredients()
    }
}

    
    


