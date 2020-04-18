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
    
    // Should this return recipe to be shown on screen?
    static func gererateSuggestion() {
        var suggestedRecipes: [RecipeStr] = []
        let recipeList = RecipeManager.getRecipe(theName: "", all: true)
        for item in recipeList {
            let random = Int.random(in: 1...4)
            
            if (item.available){
                if (random == 1 && item.rating == 0) {
                    // Display item?
                }
                else if (random != 1 && item.rating > 0) {
                    // Display item?
                }
            }
            suggestedRecipes.append(item)
        }
    }
    
    static func setPotentialMeals() {}
    
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
}
