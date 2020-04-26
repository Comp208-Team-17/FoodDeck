//
//  CardDetailViewController.swift
//  FoodDeck
//
//  Created by Gabrielle Magruder on 24/04/2020.
//  Copyright © 2020 computer science. All rights reserved.
//

import UIKit

class CardDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var recipe: RecipeStr?
    var recipeIngredients: [RecipeIngredient] = []
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var cookTimeLabel: UILabel!
    @IBOutlet weak var prepTimeLabel: UILabel!
    @IBOutlet weak var instructionText: UITextView!
    @IBOutlet weak var servingsLabel: UILabel!
    @IBOutlet weak var ingredientsTable: UITableView!
    @IBOutlet weak var vegan: UIImageView!
    @IBOutlet weak var gluten: UIImageView!
    @IBOutlet weak var vegetarian: UIImageView!
    
    @IBAction func cookedButton(_ sender: Any) {
        // Create alert
        let alert = UIAlertController(title: "Confirm meal as cooked?", message: "This action will subtract the recipe ingregients from your pantry", preferredStyle: UIAlertController.Style.actionSheet)
        
        // Add actions
        // Confirm button - remove ingredients from pantry
        alert.addAction(UIAlertAction(title: "Confirm Cooked", style: UIAlertAction.Style.default, handler: {(_) in
            PantryIngredient.subtractRecipeIngredient(recipeIngredients: self.recipeIngredients, on: self)
        }))
        
        // Cancel button
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
        
        // Show alert
        self.present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipe!.ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    override func viewDidLoad() {
        // Show recipe details
        image.image = recipe?.thumbnail
        self.title = recipe?.name
        prepTimeLabel.text = "\(recipe?.prepTime ?? 0)"
        cookTimeLabel.text = "\(recipe?.cookTime ?? 0)"
        servingsLabel.text = "\(recipe?.servings ?? 0)"
        instructionText.text = recipe!.instructions
        
        // Fetch recipe ingredients
        recipeIngredients = RecipeManager.getRecipeObject(theName: recipe!.name)[0].contains?.array as! [RecipeIngredient]
        
        // Hide dietary requirements which are not applicable
        let requirements = Array(recipe!.dietaryRequirements)
        
        // Vegetarain
        if (requirements[0] == "0") {
            vegetarian.isHidden = true
        }
        
        // Vegan
        if (requirements[1] == "0") {
            vegan.isHidden = true
        }
        
        // Gluten free
        if (requirements[2] == "0") {
            gluten.isHidden = true
        }
    }
}
