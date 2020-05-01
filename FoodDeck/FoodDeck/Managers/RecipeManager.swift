
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
            newRecipe.name = theName.capitalizingFirstLetter()
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
    /*
     Gets a recipe object
     Params: The name of the recipe
     Returns: An array of objects of type Recipe. Either has 1 or 0 elements
     Has 0 elements returned if there is no such recipe matching that name.
     */
    static func getRecipeObject(theName: String) -> [Recipe] {
        var recipeTmpRtn : [Recipe] = []
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request : NSFetchRequest<Recipe> = Recipe.fetchRequest()
        request.returnsObjectsAsFaults = false
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        do{
            let fetchedRecipes = try context.fetch(request)
            for theRecipe in fetchedRecipes{
                if theRecipe.name! == theName {
                    recipeTmpRtn.append(theRecipe)
                }
            }
        }
        catch{}
        return recipeTmpRtn
    }
    /*
     Gets either one, or all recipes.
     Params: The name of the recipe to be retrieved or "" if all recipe being searched
    An all boolean which is TRUE if retrieving all recipes. FALSE if just retrieving one
     
     Returns an empty array if no recipe has been found
     Returns an array of one item if searching for a recipe and there is a match
     Returns all recipes in the array if the all bool has been set to true on the params
     */
    static func getRecipe(theName : String, all: Bool) -> [RecipeStr]{
        if all == true {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let request : NSFetchRequest<Recipe> = Recipe.fetchRequest()
            request.returnsObjectsAsFaults = false
            request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
            do{
                tempRecipeRtn.removeAll()
                let fetchedRecipes = try context.fetch(request)
                for theRecipe in fetchedRecipes {
                    var theMealPackTmp = ""
                    if let mpack = theRecipe.belongsTo {
                        theMealPackTmp = mpack.name!
                    }
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
                    theIngredients: RecipeIngredientManager.getIngredients(recipe: theRecipe, enabled: false), theMealPack: theMealPackTmp))
                   
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
    /*
     Local helper function to check if a recipe exists and then either retrieve or delete it.
     Params:
     theName: the name of the recipe
     delete: if said recipe should be deleted if found
     get: if said recipe should be retrieved
     
     Returns true if the action was successful, false if not.
     */
    private static func checkExists(theName : String, delete : Bool, get: Bool) -> Bool{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request : NSFetchRequest<Recipe> = Recipe.fetchRequest()
        request.returnsObjectsAsFaults = false
        do{
            let fetchedRecipes = try context.fetch(request)
            for theRecipe in fetchedRecipes{
                if theRecipe.name!.lowercased() == theName.lowercased(){
                    if delete == true{
                        context.delete(theRecipe)
                        do{
                            try context.save()
                            return true
                        }
                        catch{}
                    }
                    else if get == true {
                        var theMealPackTmp = ""
                        if let mpack = theRecipe.belongsTo {
                            theMealPackTmp = mpack.name!
                        }
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
                                                       theIngredients: RecipeIngredientManager.getIngredients(recipe: theRecipe, enabled: false), theMealPack: theMealPackTmp))
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
    /*
     Deletes a recipe
     params: the recipe name
     Returns true if deletion successuful, false if not.
     */
    static func deleteRecipe(theName : String) -> Bool {
        return checkExists(theName: theName, delete: true, get: false)
    }
    /*
     Updates the recipe
     Params: all the paramteters as defined in the ingredients structure, except for the ingredients tuple.
     
     Returns true if successful, false if not.
     */
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
            updatedRecipe.name = newName.capitalizingFirstLetter()
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
    /*
     Updates the dietary requirements of a recipe
     Params:
     theName: name of the recipe
     theDietaryRequirements: String relating to dietary requirements as defined in the structures
     Returns true if update was successful, false if not.
     */
    static func updateRecipeDietary(theName : String, theDietaryRequirements : String)-> Bool {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
             let context = appDelegate.persistentContainer.viewContext
        if checkExists(theName: theName, delete: false, get: false) == false{
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
    /*
     Sets a recipe as a favourite / not a favourite
     Params: The name of the recipe and if it should be favourited
     Returns true/false depending on success
     */
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
    /*
     Does the same as the converDietaryValue but in reverse.
     Params: The dietaray string. where String is made up for 3 chars, 0 for off, 1 for on.
     char one represents vegan, two for vegetarian, three for gluten free
     Returns array of booleans
     */
    static func revertDietaryValue(value : String) -> [Bool] {
        var output : [Bool] = []
        let charOneIndex = value.index(value.startIndex, offsetBy: 1)
        let charTwoIndex = value.index(value.startIndex, offsetBy: 2)
        let charThreeIndex = value.index(value.startIndex, offsetBy: 3)
        let charOne = value[..<charOneIndex]
        let charTwo = value[charOneIndex..<charTwoIndex]
        let charThree = value[charTwoIndex..<charThreeIndex]
        output.append(charOne == "0" ? false : true)
        output.append(charTwo == "0" ? false : true)
        output.append(charThree == "0" ? false : true)
        return output
    }
    /*
     Filters the recipes by constraints, and returns the filtered results
     
     Params: The recipes to be filtered
    The time of day filter - string as Breakfast Lunch or Dinner
     Vegan filter - true/false
     Gluten filter true/false
     Search - string of search item
     
     Returns filter results in an array of recipe structs
     */
    static func filter(theRecipes : [RecipeStr], theTimeOfDayFilter : String, theVeganFilter : Bool, theVegFilter : Bool, theGlutenFilter: Bool, theSearch: String) -> [RecipeStr]{
        var localRecipeFilt : [RecipeStr] = []
        var filtNameDescription : [RecipeStr] = []
        var filtIngredients: [RecipeStr] = []
        let mealPacks = MealPackManager.getDisabledMealPacks()
        for recipe in theRecipes{
            if recipe.mealPack == "" || !mealPacks.contains(where: {$0.name == recipe.mealPack}) {
                localRecipeFilt.append(recipe)
            }
        }
        if theTimeOfDayFilter != "All"{
          localRecipeFilt = localRecipeFilt.filter {$0.timeOfDay == theTimeOfDayFilter}
        }
        if theVeganFilter == true {
            localRecipeFilt = localRecipeFilt.filter {revertDietaryValue(value: $0.dietaryRequirements)[0] == true}
        }
        if theVegFilter == true{
            localRecipeFilt = localRecipeFilt.filter {revertDietaryValue(value: $0.dietaryRequirements)[1] == true}
        }
        if theGlutenFilter == true{
           localRecipeFilt = localRecipeFilt.filter {revertDietaryValue(value: $0.dietaryRequirements)[2] == true}
        }
        // search can filter by recipe name, decription, servings and ingredients
        if theSearch != "" {
            if let value = Int16(theSearch.trimmingCharacters(in: .whitespaces)) {
                localRecipeFilt = localRecipeFilt.filter{$0.servings == value}
            }
            else {
                localRecipeFilt = localRecipeFilt.filter {$0.name.lowercased().contains(theSearch.lowercased().trimmingCharacters(in: .whitespaces))
                    || $0.recipeDescription.contains(theSearch.lowercased().trimmingCharacters(in: .whitespaces))
                    || ($0.ingredients.filter{$0.0.lowercased().contains(theSearch.lowercased().trimmingCharacters(in: .whitespaces))}).count > 0
                }
            }
            
        }
        return localRecipeFilt
    }

}
