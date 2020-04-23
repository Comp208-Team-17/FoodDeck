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
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var recipes : [RecipeStr] = []
    var currentRecipe = 0
    
    // Create of list of potential recipes for user
    func generateNewSuggestions(){
        recipes = SuggestionGenerator.gererateSuggestion()
        if (recipes.count == 0){
            ErrorManager.errorMessageStandard(theTitle: "Error", theMessage: "Not enough data to make suggestions. Please add more ingredients or add more recipes", caller: self)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        generateNewSuggestions()
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
    }
    
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) {
        if (gesture.direction == UISwipeGestureRecognizer.Direction.right) {
            print("Right")
        }
        
        else if (gesture.direction == UISwipeGestureRecognizer.Direction.left) {
            print("Left")
        }
    }
    
    
    
    
    
}
