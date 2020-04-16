//
//  SuggestionGenerator.swift
//  FoodDeck
//
//  Created by Gabrielle Magruder on 16/04/2020.
//  Copyright © 2020 computer science. All rights reserved.
//

enum pointSource {
    case swipeLeft
    case swipeRight
    case rating
    case favouriteOn
    case favouriteOff
}

class SuggestionGenerator {
    
    // Should I return recipe or update it in the class?
    // inpRecipe is a constant
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
        
        // Return recipe or update it in recipeManager?
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
    static func gererateSuggestion() {}
    
    static func setPotentialMeals() {}
    
    static func degradePoints() {}
}
