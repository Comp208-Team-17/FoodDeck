
// RecipeManager.swift
// FoodDeck

// Created by Luke Wood on 03/04/2020.
//Copyright © 2020 computer science. All rights reserved.


import UIKit
import Foundation
import CoreData
class RecipeManager: NSManagedObject {
    static var tempRecipeRtn : [RecipeStr] = []  // Stores the recipe that will be returned if a calling function requests a recipe
    /*
     Adds a new recipe to the database
     Params:
     theAllergens in format "111" where pos 1 is Vegetarian, pos 2 is Vegan, pos 2 is Gluten. 1 is true, 0 is false
     
     
     */
    static func addRecipe(theAllergens : String, isAvailable : Bool, theCookTime : Int16, theDateCreated : String, theDietaryRequirements : String, isFavourite : Bool, theInstructions : String, theName : String, thePrepTime : Int16, theRating : Int16, theRecipeDescription : String, theScore : Int16, theServings :  Int16, theThumbnail : UIImage, theTimeOfDay : String, theIngredients : [(String, Int16, Bool)]) -> Bool{
        if checkExists(theName: theName, delete: false, get : false){
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let newRecipe = Recipe(context : context)
            newRecipe.allergen = theAllergens
            newRecipe.available = isAvailable
            newRecipe.cookTime = theCookTime
            newRecipe.dateCreated = theDateCreated
            newRecipe.dietaryRequirements = theDietaryRequirements
            newRecipe.favourite = isFavourite
            newRecipe.instructions = theInstructions
            newRecipe.name = theName
            newRecipe.prepTime = thePrepTime
            newRecipe.rating = theRating
            newRecipe.recipeDescription = theRecipeDescription
            newRecipe.score = theScore
            newRecipe.servings = theServings
            newRecipe.thumbnail = theThumbnail.pngData() ?? UIImage(named: "burgerchair")!.pngData()
            newRecipe.timeOfDay = theTimeOfDay
            do{
                try context.save()
                return true
            }
            catch{
                return false
            }
            for index in 0..<theIngredients.count{
                if RecipeIngredientManager.addRecipeIngredient(ingredient: IngredientManager.getIngredientObject(theName: theIngredients[index].0)[0], recipe: newRecipe, amount: theIngredients[index].1, optional: theIngredients[index].2) == true {
                    return true
                }
            }
            
        }
        return false
    }
    
    static func getRecipeObject(theName: String) -> [Recipe] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request : NSFetchRequest<Recipe> = Recipe.fetchRequest()
        request.returnsObjectsAsFaults = false
        do{
            let fetchedRecipes = try context.fetch(request)
            for theRecipe in fetchedRecipes{
                if theRecipe.name! == theName {
                    return [theRecipe]
                }
            }
        }
        catch{}
        return []
    }
    static func getRecipe(theName : String, all: Bool) -> [RecipeStr]{
        if all == true {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let request : NSFetchRequest<Recipe> = Recipe.fetchRequest()
            request.returnsObjectsAsFaults = false
            do{
                tempRecipeRtn.removeAll()
                let fetchedRecipes = try context.fetch(request)
                for theRecipe in fetchedRecipes {
                    tempRecipeRtn.append(RecipeStr(theAllergens: theRecipe.allergen!,
                    isAvailable: theRecipe.available,
                    theCookTime: theRecipe.cookTime,
                    theDateCreated: theRecipe.dateCreated!,
                    theDietaryRequirements: theRecipe.dietaryRequirements!,
                    isFavourite: theRecipe.favourite,
                    theInstructions: theRecipe.instructions!,
                    theName: theRecipe.name!,
                    thePrepTime: theRecipe.prepTime,
                    theRating: theRecipe.rating,
                    theRecipeDescription: theRecipe.recipeDescription!,
                    theScore: theRecipe.score,
                    theServings: theRecipe.servings,
                    theThumbnail: UIImage(data: theRecipe.thumbnail!)!,
                    theTimeOfDay: theRecipe.timeOfDay!,
                    theIngredients: RecipeIngredientManager.getIngredients(recipe: theRecipe, enabled: false)))
                }
                return tempRecipeRtn
            }
            catch {
                return []
            }
        }
        if checkExists(theName: theName, delete: false, get: true) {
            return tempRecipeRtn
        }
        else {
            return []
        }
    }
    
    private static func checkExists(theName : String, delete : Bool, get: Bool) -> Bool{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request : NSFetchRequest<Recipe> = Recipe.fetchRequest()
        request.returnsObjectsAsFaults = false
        do{
            let fetchedRecipes = try context.fetch(request)
            for theRecipe in fetchedRecipes{
                if theRecipe.name == theName{
                    if delete == true{
                        context.delete(theRecipe)
                        do{
                            try context.save()
                            return true
                        }
                        catch{}
                    }
                    else if get == true {
                        tempRecipeRtn.removeAll()
                        tempRecipeRtn.append(RecipeStr(theAllergens: theRecipe.allergen!,
                                                       isAvailable: theRecipe.available,
                                                       theCookTime: theRecipe.cookTime,
                                                       theDateCreated: theRecipe.dateCreated!,
                                                       theDietaryRequirements: theRecipe.dietaryRequirements!,
                                                       isFavourite: theRecipe.favourite,
                                                       theInstructions: theRecipe.instructions!,
                                                       theName: theRecipe.name!,
                                                       thePrepTime: theRecipe.prepTime,
                                                       theRating: theRecipe.rating,
                                                       theRecipeDescription: theRecipe.recipeDescription!,
                                                       theScore: theRecipe.score,
                                                       theServings: theRecipe.servings,
                                                       theThumbnail: UIImage(data: theRecipe.thumbnail!)!,
                                                       theTimeOfDay: theRecipe.timeOfDay!,
                                                       theIngredients: RecipeIngredientManager.getIngredients(recipe: theRecipe, enabled: false)))
                        return true
                    }
                    return false
                }
            }
        }
        catch {
            return false
        }
        return true
    }
    static func deleteRecipe(theName : String) -> Bool {
        return checkExists(theName: theName, delete: true, get: false)
    }
    static func updateRecipeExceptIngredients(originalName: String, newName: String, theAllergens : String, isAvailable : Bool, theCookTime : Int16, theDateCreated : String, theDietaryRequirements : String, isFavourite : Bool, theInstructions : String,  thePrepTime : Int16, theRating : Int16, theRecipeDescription : String, theScore : Int16, theServings :  Int16, theThumbnail : UIImage, theTimeOfDay : String) -> Bool {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        if checkExists(theName: newName, delete: false, get: false) == true || originalName == newName {
            let updatedRecipe =  getRecipeObject(theName: originalName)[0]
            updatedRecipe.allergen = theAllergens
                 updatedRecipe.available = isAvailable
                 updatedRecipe.cookTime = theCookTime
                 updatedRecipe.dateCreated = theDateCreated
            if theDietaryRequirements != "ignore"{
                updatedRecipe.dietaryRequirements = theDietaryRequirements
            }
                 updatedRecipe.favourite = isFavourite
                 updatedRecipe.instructions = theInstructions
                 updatedRecipe.name = newName
                 updatedRecipe.prepTime = thePrepTime
                 updatedRecipe.rating = theRating
                 updatedRecipe.recipeDescription = theRecipeDescription
                 updatedRecipe.score = theScore
                 updatedRecipe.servings = theServings
                 updatedRecipe.thumbnail = theThumbnail.pngData()!
                 updatedRecipe.timeOfDay = theTimeOfDay
            do{
                try context.save()
                return true
            }
            catch{}
        }
       
        return false
    }
    static func updateRecipeDietary(theName : String, theDietaryRequirements : String)-> Bool {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
             let context = appDelegate.persistentContainer.viewContext
        if checkExists(theName: theName, delete: false, get: false) == true{
            let updatedRecipe = getRecipeObject(theName: theName)[0]
            updatedRecipe.dietaryRequirements = theDietaryRequirements
            do{
                try context.save()
                return true
            }
            catch{}
        }
        return false
    }
    static func updateRecipeRating(theName: String, theStars: Int16) -> Bool {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
          let context = appDelegate.persistentContainer.viewContext
        let theRecipe = getRecipeObject(theName : theName)
        theRecipe[0].rating = theStars
        do{
            try context.save()
            return true
        }
        catch{
        }
        return false
    }
    static func updateRecipeFavourite(theName: String, isFavourite : Bool) -> Bool {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let theRecipe = getRecipeObject(theName : theName)
        theRecipe[0].favourite = isFavourite
        
        do{
            try context.save()
            return true
        }
        catch{
        }
        return false
    }
    /*
     Converts the boolean values for dietary requirements when editing a recipe, to the corresponding string which will be stored in coredata
     Params: Booleans for requirements
     Returns string as "000" where position 1 is vegan, position 2 for vegetarian, or gluten for position 3.
     
     */
    static func convertDietaryValue(vegan : Bool, veg: Bool, gluten : Bool) -> String{
        let veganTmp : Character = (vegan == true ? "1" : "0")
        let vegTmp : Character = (veg == true ? "1" : "0")
        let glutenTmp : Character = (gluten == true ? "1" : "0")
        return "\(veganTmp)\(vegTmp)\(glutenTmp)"
    }
    static func revertDietaryValue(value : String) -> [Bool] {
        var output : [Bool] = []
        let charOneIndex = value.index(value.startIndex, offsetBy: 1)
        let charTwoIndex = value.index(value.startIndex, offsetBy: 2)
        let charThreeIndex = value.index(value.startIndex, offsetBy: 3)
        let charOne = value[..<charOneIndex]
        let charTwo = value[charOneIndex..<charTwoIndex]
        let charThree = value[charTwoIndex..<charThreeIndex]
        print (charOne)
        print (charTwo)
        print (charThree)
        output.append(charOne == "0" ? false : true)
        output.append(charTwo == "0" ? false : true)
        output.append(charThree == "0" ? false : true)
        return output
    }
}
