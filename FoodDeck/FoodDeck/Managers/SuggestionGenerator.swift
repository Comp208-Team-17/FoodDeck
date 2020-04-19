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
            recipe.rating = Int16(rating)
        }
        
        else if (source == .favouriteOn) {
            recipe.favourite = true
        }
        
        else if (source == .favouriteOff) {
            recipe.favourite = false
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
        let recipeList = RecipeManager.getRecipe(theName: "", all: true)
        
        // Should we sort by score here?
        
        // Decide which recipes should be displayed
        for item in recipeList {
            let random = Int.random(in: 1...4)
            if (item.available) {
                // 25% chance to show an unrated recipe
                if (random == 1 && item.rating == 0) {
                    displayRecipe.append(item)
                }
                    
                // 75% chance to show a rated recipe
                else if (random != 1 && item.rating > 0) {
                    displayRecipe.append(item)
                }
            }
            suggestedRecipes.append(item)
        }
        
        return displayRecipe
    }
    
    // Call at generate suggetion or at cards page?
    static func setPotentialMeals() {
        var acceptedRequirement: Bool
        var recipe: RecipeStr
        let recipeList = RecipeManager.getRecipe(theName: "", all: true)
        let pantryList = PantryIngredient.getAllPanryIngredients()
        let currentTime = findTimeOfDay()
        
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
            
            // Allow recipe to be generated if it's the correct course
            
            
            // Allow recipe to be generated if it matches the user's requirements
            let requirements = Array(recipe.dietaryRequirements)
            
            if (vegetarian == true && requirements[0] == "0"){
                acceptedRequirement = false
            }
            
            if (vegan == true && requirements[1] == "0"){
                acceptedRequirement = false
            }
            
            if (gluten == true && requirements[2] == "0"){
                acceptedRequirement = false
            }
            
            // Allow recipe to be generated if all it's ingredients are in the pantry
            for ingredient in recipe.ingredients {
                for item in pantryList {
                    // Only allow recipes with correct ingredients and amounts
                    if (ingredient.0 == item.name && ingredient.1 == item.pantryIngredient?.amount){
                        acceptedRequirement = false
                    }
                }
            }
            
            // Update recipe if necessary
            if (recipe.available != acceptedRequirement){
                recipe.available = acceptedRequirement
                let saved = RecipeManager.updateRecipeExceptIngredients(originalName: recipe.name, newName: recipe.name, theAllergens: recipe.allergen, isAvailable: recipe.available, theCookTime: recipe.cookTime, theDateCreated: recipe.dateCreated, theDietaryRequirements: recipe.dietaryRequirements, isFavourite: recipe.favourite, theInstructions: recipe.instructions, thePrepTime: recipe.prepTime, theRating: recipe.rating, theRecipeDescription: recipe.recipeDescription, theScore: recipe.score, theServings: recipe.servings, theThumbnail: recipe.thumbnail ?? UIImage(), theTimeOfDay: recipe.timeOfDay)
                
                if (!saved){
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
            return "Morning"
        }
        // Afternoon = 12:00 - 16:59
        else if (hour >= 12 && hour < 15){
            return "Afternoon"
        }
        // Evening = 17:00 - 03:59
        else if (hour >= 15 || hour < 4){
            return "Evening"
        }
        return ""
    }
}
