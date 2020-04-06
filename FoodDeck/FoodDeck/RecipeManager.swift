////
////  RecipeManager.swift
////  FoodDeck
////
////  Created by Luke Wood on 03/04/2020.
////  Copyright © 2020 computer science. All rights reserved.
////
//
//import UIKit
//import Foundation
//import CoreData
//class RecipeManager: NSManagedObject {
//   static var tempRecipeRtn : [RecipeStr] = [] // Stores the recipe that will be returned if a calling function requests a recipe
//
//    static func addRecipe(theAllergens : String, isAvailable : Bool, theCookTime : Int16, theDateCreated : String, theDietaryRequirements : String, isFavourite : Bool, theInstructions : String, theName : String, thePrepTime : Int16, theRating : Int16, theRecipeDescription : String, theScore : Int16, theServings :  Int16, theThumbnail : UIImage, theTimeOfDay : String, theIngredients : [String]) -> Bool{
//        if checkExists(theName: theName, delete: false, get : false){
//            let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                   let context = appDelegate.persistentContainer.viewContext
//                   let newRecipe = Recipe(context : context)
//                   newRecipe.allergen = theAllergens
//                   newRecipe.available = isAvailable
//                   newRecipe.cookTime = theCookTime
//                   //newRecipe.dateCreated = theDateCreated
//                   newRecipe.dietaryRequirements = theDietaryRequirements
//                   newRecipe.favourite = isFavourite
//                   newRecipe.instructions = theInstructions
//                   newRecipe.name = theName
//                   newRecipe.prepTime = thePrepTime
//                   newRecipe.rating = theRating
//                   newRecipe.recipeDescription = theRecipeDescription
//                   newRecipe.score = theScore
//                   newRecipe.servings = theServings
//                   newRecipe.thumbnail = theThumbnail.pngData()!
//                   newRecipe.timeOfDay = theTimeOfDay
//            for index in 0..<theIngredients.count{
//                let ingredientGet : [NSManagedObject] = IngredientManager.getIngredientObject(theName: theName)
//
//
//            }
//                   do{
//                       try context.save()
//                       return true
//                   }
//                   catch{
//                       return false
//                   }
//        }
//        return false
//
//    }
//   static func checkExists(theName : String, delete : Bool, get: Bool) -> Bool{
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let context = appDelegate.persistentContainer.viewContext
//        let request : NSFetchRequest<Ingredient> = Ingredient.fetchRequest()
//        request.returnsObjectsAsFaults = false
//        do{
//            let fetchedRecipes = try context.fetch(request)
//            for theRecipe in fetchedRecipes{
//                if theRecipe.name == theName{
//                    if delete == true{
//                        context.delete(theRecipe)
//                        do{
//                            try context.save()
//                            return true
//                        }
//                        catch{}
//                    }
//                    else if get == true {
//                        tempRecipeRtn.append(
//                        theRecipe.allergen,
//                       //theRecipe.available,
//                       theRecipe.cookTime,
//                       theRecipe.dateCreated,
//                       theRecipe.dietaryRequirements,
//                       theRecipe.favourite,
//                       theRecipe.instructions,
//                       theRecipe.name,
//                       theRecipe.prepTime,
//                       theRecipe.rating,
//                       theRecipe.recipeDescription,
//                       theRecipe.score,
//                       theRecipe.servings,
//                       theRecipe.thumbnail,
//                       theRecipe.timeOfDay)
//                        return true
//                    }
//                    return false
//                }
//            }
//        }
//        catch {
//            return false
//        }
//        return true
//    }
//
//}
