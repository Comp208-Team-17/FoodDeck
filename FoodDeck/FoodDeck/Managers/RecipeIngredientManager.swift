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
    private static var tempRtn : [RecipeIngredient] = []
    /*
     Adds a an ingredient to a recipe
     
     Params: the ingredient to add, the recipe to add to, the amount and if it is optional.
     note: to pass the ingredient into this object, use the IngredientManager.getIngredientObject(name)
     to pass the recipe into this object, use the RecipeManager.getRecipeObject(name)
     
     Returns FALSE if the ingredient already exists in that meal
     Returns TRUE if the ingredient was addded to the meal successfully
     */
    static func addRecipeIngredient(ingredient: Ingredient, recipe : Recipe, amount : Int16, optional: Bool) -> Bool{
        if checkExists(recipe: recipe, ingredient: ingredient, delete: false, get : false) == true{
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
     Gets the requested object of type RecipeIngredient
     
     Params: The ingredient and recipe
     
     Returns an array of a single element [RecipeIngredient] of the requested recipe ingredient, OR Returns an empty array [] if no such ingredient exists in that recipe.
     */
    static func getRecipeIngredientObject(ingredient: Ingredient, recipe: Recipe) -> [RecipeIngredient]{
        checkExists(recipe: recipe, ingredient: ingredient, delete: false, get: true)
        return tempRtn
    }
    /*
     Removes an ingredient from a recipe
     
     Params: ingredient and recipe objects
     See notes on addIngredient for how to pass these parameters
     
     Returns TRUE if the ingredient was removed successfully
     Returns FALSE if there was an error removing the ingredient
     */
    static func removeIngredient(ingredient: Ingredient, recipe : Recipe)-> Bool{
        return checkExists(recipe: recipe, ingredient : ingredient, delete : true, get: false)
    }
    /*
     Gets the ingredients in a recipe
     
     Params: recipe, array of (one or zero) ingredients ( See notes on addIngredient for how to pass these parameters),
     if enabled is TRUE then only enabled recipes are returned.
     
     Returns an array of tuples [(ingredient name, amount, optional, unit)]
     
     */
    static func getIngredients(recipe : Recipe, enabled: Bool) -> [(String, Int16, Bool, String, Bool)]{
        var ingredientsRtn : [(String, Int16, Bool, String, Bool)] = []
        for theIngredient in recipe.contains!{
            ingredientsRtn.append(
                ((theIngredient as! RecipeIngredient).ingredient!.name!,
                 (theIngredient as! RecipeIngredient).amount,
                 (theIngredient as! RecipeIngredient).optional,
                 (theIngredient as! RecipeIngredient).ingredient!.unit!,
                (theIngredient as! RecipeIngredient).ingredient!.enabled
            ))
        }
        return ingredientsRtn
    }
    /*
     This function should ONLY BE USED LOCALLY.
     
     Checks if an ingredient exists in a recipe, and/or deletes it
     
     params: recipe, ingredient (see notes on addIngredient on how to pass these parameters) , delete and get. If delete is set to true,
     the ingredient is deleted from the recipe. if get is set to true, the local variable tempRtn is populated with the recipe that matches the search criteria.
     
     Returns TRUE if the ingredient DOES NOT EXIST in the recipe - so that the ingredient can be added, OR Returns TRUE if a deletion was successful OR Returns true if the local variable tempRtn was successfully populated.
     
     Returns FALSE if the ingredient ALREADY EXISTS in the recipe, OR Returns FALSE if a deletion was unsuccessful OR Returns FALSE if there was no such ingredient able to be set for tempRtn
     
     */
    private static func checkExists(recipe: Recipe, ingredient: Ingredient, delete : Bool, get: Bool) -> Bool{
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
                    if get == true{
                        tempRtn = [theIngredient]
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
    /*
     Updates the ingredient in the recipe, to change the quantity or if the ingredient is considered optional
    Params: Takes the recipe ingredient to be updated, and the updated quantity and optional as a boolean.
     
     Returns TRUE if the update was successful
     Returns FALSE if the update was not successful, e.g. the changes could not be commited to the database.
     
     
     */
    static func updateRecipeIngredient(recipeIngredient : RecipeIngredient, updatedAmount :Int16, updatedOptional: Bool ) -> Bool {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        recipeIngredient.amount = updatedAmount
        recipeIngredient.optional = updatedOptional
        do{
            try context.save()
            return true
        }
        catch{
            return false
        }
    }
    
}
