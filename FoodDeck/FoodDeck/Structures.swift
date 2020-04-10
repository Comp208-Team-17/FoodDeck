//
//  Structures.swift
//  FoodDeck
//
//  Created by Luke Wood on 04/04/2020.
//  Copyright © 2020 computer science. All rights reserved.
//

import UIKit
public struct RecipeStr{
     var allergen : String
     var available : Bool
     var cookTime : Int16
     var dateCreated : String
     var dietaryRequirements : String
     var favourite : Bool
     var instructions : String
     var name : String
     var prepTime : Int16
     var rating : Int16
     var recipeDescription : String
     var score : Int16
     var servings : Int16
     var thumbnail : UIImage?
     var timeOfDay : String
    var ingredients : [(String, Int16, Bool)]
     init(theAllergens : String, isAvailable : Bool, theCookTime : Int16, theDateCreated : String, theDietaryRequirements : String, isFavourite : Bool, theInstructions : String, theName : String, thePrepTime : Int16, theRating : Int16, theRecipeDescription : String, theScore : Int16, theServings :  Int16, theThumbnail : UIImage, theTimeOfDay : String, theIngredients : [(String, Int16, Bool)]){
         allergen = theAllergens
         available = isAvailable
         cookTime = theCookTime
         dateCreated = theDateCreated
         dietaryRequirements = theDietaryRequirements
         favourite = isFavourite
         instructions = theInstructions
         name = theName
         prepTime = thePrepTime
         rating = theRating
         recipeDescription = theRecipeDescription
         score = theScore
         servings = theServings
         thumbnail = theThumbnail
         timeOfDay = theTimeOfDay
         ingredients = theIngredients
     }
     init() {
         allergen = ""
         available = false
         cookTime = 0
         dateCreated = ""
         dietaryRequirements = ""
         favourite = false
         instructions = ""
         name = ""
         prepTime = 0
         rating = 0
         recipeDescription = ""
         score = 0
         servings = 0
         timeOfDay = ""
         ingredients = []
     }
 }
public struct IngredientStr{
    var name : String
    var unit : String
    var enabled : Bool
    init(theName : String, theUnit : String, isEnabled : Bool){
        name = theName
        unit = theUnit
        enabled = isEnabled
    }
    init(){
        name = ""
        unit = ""
        enabled = false
    }
}

public struct MealPackStr {
    var name: String
    var enabled: Bool
    
    init(theName: String, isEnabled: Bool){
        name = theName
        enabled = isEnabled
    }
    
    init(){
        name = ""
        enabled = false
    }
}
