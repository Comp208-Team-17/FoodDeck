//
//  CardsViewController.swift
//  FoodDeck
//
//  Created by Gabrielle Magruder on 23/04/2020.
//  Copyright © 2020 computer science. All rights reserved.
//

import UIKit

class CardsViewController : UIViewController {
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var mealNameLabel: UILabel!
    @IBOutlet weak var prepTimeLabel: UILabel!
    @IBOutlet weak var cookTimeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UITextView!
    @IBOutlet weak var txtServings: UILabel!
    
    @IBOutlet weak var card: UIView!
    var recipes : [RecipeStr] = []
    var currentIndex = 0
    
    // Create of list of potential recipes for user
    func generateNewSuggestions(){
        recipes = SuggestionGenerator.gererateSuggestion()
        if (recipes.count == 0){
            ErrorManager.errorMessageStandard(theTitle: "Error", theMessage: "Not enough data to make suggestions. Please add more ingredients or add more recipes.", caller: self)
        }
    }
    
    func showCurrentRecipe() {
        var currentRecipe: RecipeStr
        
        if (recipes.count == 0) {
            currentRecipe = RecipeStr()
            
        }
        else {
            currentRecipe = recipes[currentIndex]
            // animation
            //UIView.transition(with: card, duration: 0.75, animations: {self.card.frame.origin.x = -400}, completion: nil)
        }
        
        // Show recipe properties
        image.image = currentRecipe.thumbnail
        mealNameLabel.text? = "\(currentRecipe.name)   \(currentRecipe.score)"
        prepTimeLabel.text? = "\(currentRecipe.prepTime) mins"
        cookTimeLabel.text? = "\(currentRecipe.cookTime) mins"
        descriptionLabel.text? = currentRecipe.recipeDescription
        txtServings.text = "\(currentRecipe.servings)"
        
    }
    
    // Set up segue and send selected recipe to the next view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCardDetailView" {
            let selectedRecipe = recipes[currentIndex]
            let secondViewController = segue.destination as! CardDetailViewController
            secondViewController.recipe = selectedRecipe
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        currentIndex = 0
        SuggestionGenerator.setPotentialMeals()
        generateNewSuggestions()
        showCurrentRecipe()
    }
    
    override func viewDidLoad() {
        // Add gesture recognizers
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.handleGesture(gesture:)))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)

        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.handleGesture(gesture:)))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)

        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(self.handleGesture(gesture:)))
        swipeUp.direction = .up
        self.view.addGestureRecognizer(swipeUp)

        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.handleGesture(gesture:)))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
        
        // optional border colour
        card.layer.masksToBounds = true
        card.layer.borderColor = UIColor(red: 0.7, green: 0.3, blue: 0.1, alpha: 1.0).cgColor
        card.layer.borderWidth = 1.0
    }
    
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) {
        var currentRecipe: RecipeStr
        
        if (recipes.count == 0) {
            return
        }
        else {
            currentRecipe = recipes[currentIndex]
        }
        
        // Swipe right - add points and show recipe detail
        if (gesture.direction == UISwipeGestureRecognizer.Direction.right) {
            SuggestionGenerator.updatePoints(source: pointSource.swipeRight, rating: Int(currentRecipe.rating), inpRecipe: currentRecipe)
            performSegue(withIdentifier: "toCardDetailView", sender: nil)
            print("Right")
        }
        
        // Swipe left - subtract points and show next recipe
        else if (gesture.direction == UISwipeGestureRecognizer.Direction.left) {
            SuggestionGenerator.updatePoints(source: pointSource.swipeLeft, rating: Int(currentRecipe.rating), inpRecipe: currentRecipe)
            
            currentIndex += 1
            
            // Regenerate recipes if all the suggestions have been used
            if (currentIndex + 1 > recipes.count) {
                generateNewSuggestions()
                currentIndex = 0
                print("End of recipes")
                // = []
            }
            showCurrentRecipe()
            print("Left")
        }
    }
}
