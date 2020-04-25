//
//  CardDetailViewController.swift
//  FoodDeck
//
//  Created by Gabrielle Magruder on 24/04/2020.
//  Copyright © 2020 computer science. All rights reserved.
//

import UIKit

class CardDetailViewController: UIViewController {
    var recipe: RecipeStr?
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var cookTimeLabel: UILabel!
    @IBOutlet weak var prepTimeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var instructionsLabel: UILabel!
    
   
    override func viewDidLoad() {
        image.image = recipe?.thumbnail
        self.title = recipe?.name
        prepTimeLabel.text = "Prep Time:\(recipe?.prepTime ?? 0) mins"
        cookTimeLabel.text = "\(recipe?.cookTime ?? 0) mins"
        descriptionLabel.text = recipe?.recipeDescription
        instructionsLabel.text = recipe?.instructions
        // Ingredients label?
    }
}
