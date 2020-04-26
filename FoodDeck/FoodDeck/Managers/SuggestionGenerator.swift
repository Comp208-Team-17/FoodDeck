//
//  SuggestionGenerator.swift
//  FoodDeck
//
//  Created by Gabrielle Magruder on 16/04/2020.
//  Copyright © 2020 computer science. All rights reserved.
//

import UIKit

enum pointSource {
    case swipeLeft
    case swipeRight
    case rating
    case favouriteOn
    case favouriteOff
}

class SuggestionGenerator {
    
    static func updatePoints(source: pointSource, rating: Int, inpRecipe: RecipeStr) {
        var lowerBound: Int
        var recipe = inpRecipe
        
        // Adjust recipe score based on actions
        if (source == .swipeRight) {
            recipe.score += 1
        }
        
        else if (source == .swipeLeft) {
            recipe.score -= 1
        }
        
        else if (source == .rating) {
            // Reset ratings
            if rating == 0 {
                recipe.score = 100
            }
            else{
                // changing ratings
                recipe.score = Int16(recipe.score - (recipe.rating == 0 ? 100 : recipe.rating * 25) + Int16((rating * 25)))
            }
            recipe.rating = Int16(rating)
        }
        
        else if (source == .favouriteOn) {
            recipe.favourite = true
            recipe.score = recipe.score - (recipe.rating == 0 ? 100 : recipe.rating * 25) + 150
        }
        
        else if (source == .favouriteOff) {
            recipe.favourite = false
            recipe.score = recipe.score + (recipe.rating == 0 ? 100 : recipe.rating * 25) - 150
        }
        
        // Adjust recipe score to be withing boundaries
        lowerBound = findLowerBound(inpRecipe: recipe)
        
        if (recipe.score > 200) {
            recipe.score = 200
        }
            
        else if (recipe.score < lowerBound){
            recipe.score = Int16(lowerBound)
        }
        
        // Update recipe
        
         let saved = RecipeManager.updateRecipeExceptIngredients(originalName: recipe.name, newName: recipe.name, theAllergens: recipe.allergen, isAvailable: recipe.available, theCookTime: recipe.cookTime, theDateCreated: recipe.dateCreated, theDietaryRequirements: recipe.dietaryRequirements, isFavourite: recipe.favourite, theInstructions: recipe.instructions, thePrepTime: recipe.prepTime, theRating: recipe.rating, theRecipeDescription: recipe.recipeDescription, theScore: recipe.score, theServings: recipe.servings, theThumbnail: recipe.thumbnail ?? UIImage(), theTimeOfDay: recipe.timeOfDay)
        
        if (!saved){
            print("Recipe score not saved")
        }
 
    }
    
    static func findLowerBound(inpRecipe: RecipeStr) -> Int {
        if (inpRecipe.favourite == false){
            return Int(inpRecipe.rating == 0 ? 1: inpRecipe.rating * 25)
        }
            
        else {
            return 150
        }
    }
    
    static func gererateSuggestion() -> [RecipeStr] {
        var suggestedRecipes: [RecipeStr] = []
        var displayRecipe: [RecipeStr] = []
        var recipeList = RecipeManager.getRecipe(theName: "", all: true)
        var generate = true
        
        // Filter out all unavailable recipes
        recipeList = recipeList.filter{$0.available == true}
        if (recipeList.count == 0) {
            return []
        }
        
        // Sort recipe by score - highest score first
        recipeList.sort {$0.score > $1.score}
        print (recipeList)
        
        // Regenerate recipes if it would return an empty list
        while (generate){
            
            // Decide which recipes should be displayed
            for item in recipeList {
                let random = Int.random(in: 1...4)
                
                // 25% chance to show an unrated recipe
                if (random == 1 && item.rating == 0) {
                    displayRecipe.append(item)
                    generate = false
                }
                    
                // 75% chance to show a rated recipe
                else if (random != 1 && item.rating > 0) {
                    displayRecipe.append(item)
                    generate = false
                }
                
                suggestedRecipes.append(item)
            }
        }
        
        return displayRecipe
    }
    
    static func setPotentialMeals() {
        var acceptedRequirement: Bool
        var recipe: RecipeStr
        let recipeList = RecipeManager.getRecipe(theName: "", all: true)
        let pantryList = PantryIngredient.getAllPanryIngredients()
        let currentTime = findTimeOfDay()
        let disabledMealPacks = MealPackManager.getDisabledMealPacks()
        
        // User's dietary requirements
        let vegan = UserDefaults.standard.object(forKey: "vegan") as? Bool
        let vegetarian = UserDefaults.standard.object(forKey: "vegetarian") as? Bool
        let gluten = UserDefaults.standard.object(forKey: "gluten") as? Bool
        
        for item in recipeList {
            acceptedRequirement = true
            recipe = item
            
            // Allow recipe to be generated if it's the correct time of day
            if (recipe.timeOfDay != currentTime) {
                acceptedRequirement = false
            }
            
            // Allow recipe to be generated if it matches the user's requirements
            let requirements = Array(recipe.dietaryRequirements)
            
            if (vegetarian == true && requirements[0] == "0") {
                acceptedRequirement = false
            }
            
            if (vegan == true && requirements[1] == "0") {
                acceptedRequirement = false
            }
            
            if (gluten == true && requirements[2] == "0") {
                acceptedRequirement = false
            }
            
            // Allow recipe to be generated if all it's ingredients are in the pantry
            for ingredient in recipe.ingredients {
                // Check only if the ingredient is mandatory
                if (ingredient.4 == false) {
                    
                    // If the recipe ingredient is disabled - disable recipe
                    if (ingredient.2 == false) {
                        acceptedRequirement = false
                    }
                        
                    else{
                        // Filter to see if ingredient exists in pantry
                        let tempPantry = pantryList.filter{ $0.name == ingredient.0 }
                        
                        
                        // Disable recipe if ingredient does not exist in pantry
                        if (tempPantry.count == 0) {
                            acceptedRequirement = false
                        }
                            
                        // Disable recipe if there is not enough of the ingredient in the pantry to cook the recipe
                        else if (ingredient.1 > tempPantry[0].pantryIngredient!.amount) {
                            acceptedRequirement = false
                        }
                    }
                }
            }
            
            // Update recipe if necessary
            if (recipe.available != acceptedRequirement) {
                recipe.available = acceptedRequirement
                let saved = RecipeManager.updateRecipeExceptIngredients(originalName: recipe.name, newName: recipe.name, theAllergens: recipe.allergen, isAvailable: recipe.available, theCookTime: recipe.cookTime, theDateCreated: recipe.dateCreated, theDietaryRequirements: recipe.dietaryRequirements, isFavourite: recipe.favourite, theInstructions: recipe.instructions, thePrepTime: recipe.prepTime, theRating: recipe.rating, theRecipeDescription: recipe.recipeDescription, theScore: recipe.score, theServings: recipe.servings, theThumbnail: recipe.thumbnail ?? UIImage(), theTimeOfDay: recipe.timeOfDay)
                
                if (!saved) {
                    print("Recipe availabilty not updated")
                }
            }
        }
    }
    
    static func degradePoints() {
        let recipeList = RecipeManager.getRecipe(theName: "", all: true)
        var recipe: RecipeStr
        var scoreUpdated: Bool
        
        for item in recipeList {
            scoreUpdated = false
            recipe = item
            
            // Degrade score if it is getting too high
            if (recipe.score > 175){
                recipe.score -= 5
                scoreUpdated = true
            }
                
            // Increase score if it is getting too low
            else if (recipe.score < 25 && item.rating > 0){
                recipe.score += 2
                scoreUpdated = true
            }
            
            // Update recipe if the score has changed
            if (scoreUpdated){
                 let saved = RecipeManager.updateRecipeExceptIngredients(originalName: recipe.name, newName: recipe.name, theAllergens: recipe.allergen, isAvailable: recipe.available, theCookTime: recipe.cookTime, theDateCreated: recipe.dateCreated, theDietaryRequirements: recipe.dietaryRequirements, isFavourite: recipe.favourite, theInstructions: recipe.instructions, thePrepTime: recipe.prepTime, theRating: recipe.rating, theRecipeDescription: recipe.recipeDescription, theScore: recipe.score, theServings: recipe.servings, theThumbnail: recipe.thumbnail ?? UIImage(), theTimeOfDay: recipe.timeOfDay)
                
                if (!saved){
                    print("Recipe score not saved")
                }
            }
        }
    }
    
    static func findTimeOfDay() -> String {
        // Find current time
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        
        // Check which category current time falls into
        // Morning = 04:00 - 11:59
        if (hour >= 4 && hour < 12) {
            return "Breakfast"
        }
        // Afternoon = 12:00 - 16:59
        else if (hour >= 12 && hour < 17){
            return "Lunch"
        }
        // Evening = 17:00 - 03:59
        else if (hour >= 17 || hour < 4){
            return "Dinner"
        }
        return ""
    }
    
}
