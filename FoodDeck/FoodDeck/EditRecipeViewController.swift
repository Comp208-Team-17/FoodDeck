//
//  EditRecipeViewController.swift
//  FoodDeck
//
//  Created by Luke Wood on 14/04/2020.
//  Copyright © 2020 computer science. All rights reserved.
//

import UIKit

class EditRecipeViewController: UIViewController {
    
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtDescription: UITextView!
    @IBOutlet weak var txtInstructions: UITextView!
    @IBAction func btnSave(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(true)
        if RecipeViewController.addButton == false {
            txtName.text = RecipeDetailViewController.localRecipe[0].name
            txtDescription.text = RecipeDetailViewController.localRecipe[0].recipeDescription
            txtInstructions.text = RecipeDetailViewController.localRecipe[0].instructions
            if RecipeDetailViewController.localRecipe[0].thumbnail != nil {
                recipeImage.image = RecipeDetailViewController.localRecipe[0].thumbnail
            }
            
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
