//
//  RecipeIngredientManager.swift
//  FoodDeck
//
//  Created by Luke Wood on 10/04/2020.
//  Copyright © 2020 computer science. All rights reserved.
//
import UIKit
import Foundation
import CoreData
class RecipeIngredientManager: NSManagedObject {
    /*
     Adds a an ingredient to a recipe
     
     Params: the ingredient to add, the recipe to add to, the amount and if it is optional.
     note: to pass the ingredient into this object, use the IngredientManager.getIngredientObject(name)
     to pass the recipe into this object, use the RecipeManager.getRecipeObject(name)
     
     Returns FALSE if the ingredient already exists in that meal
     Returns TRUE if the ingredient was addded to the meal successfully
     */
    static func addIngredient(ingredient: Ingredient, recipe : Recipe, amount : Int16, optional: Bool) -> Bool{
        if checkExists(recipe: recipe, ingredient: ingredient, delete: false) == true{
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let newIngredient = RecipeIngredient(context : context)
            newIngredient.amount = amount
            newIngredient.optional = optional
            newIngredient.belongsTo = recipe
            newIngredient.ingredient = ingredient
            do{
                try context.save()
                return true
            }
            catch{
                return false
            }
        }
        else{
            return false
        }
        
    }
    /*
     Removes an ingredient from a recipe
     
     Params: ingredient and recipe objects
     See notes on addIngredient for how to pass these parameters
     
     Returns TRUE if the ingredient was removed successfully
     Returns FALSE if there was an error removing the ingredient
     */
    static func removeIngredient(ingredient: Ingredient, recipe : Recipe)-> Bool{
        return checkExists(recipe: recipe, ingredient : ingredient, delete : true)
    }
    /*
     Gets the ingredients in a recipe
     
     Params: recipe, array of (one or zero) ingredients ( See notes on addIngredient for how to pass these parameters),
     if enabled is TRUE then only enabled recipes are returned.
     
     Returns an array of tuples [(ingredient name, amount, optional, unit)]
     
     */
    static func getIngredients(recipe : Recipe, enabled: Bool) -> [(String, Int16, Bool, String)]{
        var ingredientsRtn : [(String, Int16, Bool, String)] = []
        for theIngredient in recipe.contains!{
            if !(((theIngredient as! RecipeIngredient).ingredient!.enabled == true) && enabled == true){
                ingredientsRtn.append(
                    ((theIngredient as! RecipeIngredient).ingredient!.name!,
                     (theIngredient as! RecipeIngredient).amount,
                     (theIngredient as! RecipeIngredient).optional,
                     (theIngredient as! RecipeIngredient).ingredient!.unit!)
                )
            }
            
        }
        return ingredientsRtn
    }
    /*
     This function should ONLY BE USED LOCALLY.
     
     Checks if an ingredient exists in a recipe, and/or deletes it
     
     params: recipe, ingredient (see notes on addIngredient on how to pass these parameters) and delete. If delete is set to true,
     the ingredient is deleted from the recipe.
     
     Returns TRUE if the ingredient DOES NOT EXIST in the recipe - so that the ingredient can be added, OR Returns TRUE if a deletion was successful.
     Returns FALSE if the ingredient ALREADY EXISTS in the recipe, OR Returns FALSE if a deletion was unsuccessful.
     
     */
    private static func checkExists(recipe: Recipe, ingredient: Ingredient, delete : Bool) -> Bool{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request : NSFetchRequest<RecipeIngredient> = RecipeIngredient.fetchRequest()
        request.returnsObjectsAsFaults = false
        do{
            let fetchedIngredients = try context.fetch(request)
            for theIngredient in fetchedIngredients{
                if theIngredient.ingredient!.name == ingredient.name && theIngredient.belongsTo!.name == recipe.name{
                    if delete == true{
                        context.delete(theIngredient)
                        return true
                    }
                    return false
                }
            }
            try context.save()
            return true
        }
        catch{
            return false
        }
    }
    
}
