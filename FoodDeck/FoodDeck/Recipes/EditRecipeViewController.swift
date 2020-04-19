//
//  EditRecipeViewController.swift
//  FoodDeck
//
//  Created by Luke Wood on 14/04/2020.
//  Copyright © 2020 computer science. All rights reserved.
//

import UIKit

class EditRecipeViewController: UIViewController {
    
    @IBOutlet weak var txtServings: UITextField!
    @IBOutlet weak var txtPrepTime: UITextField!
    @IBOutlet weak var txtCookTime: UITextField!
    @IBOutlet weak var swVegan: UISwitch!
    @IBOutlet weak var swVegetarian: UISwitch!
    @IBOutlet weak var swGluten: UISwitch!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtDescription: UITextView!
    @IBOutlet weak var txtInstructions: UITextView!
    @IBAction func btnSave(_ sender: Any) {
        if RecipeViewController.addButton == true {
            let dietary = RecipeManager.convertDietaryValue(vegan: swVegan.isOn, veg: swVegetarian.isOn, gluten: swGluten.isOn)
            var cookTimeTmp : Int16?
            var prepTimeTmp : Int16?
            var servingsTmp : Int16?
            if let cookTime = Int16(txtCookTime.text!){
                cookTimeTmp? = cookTime
            }
            if let prepTime = Int16(txtPrepTime.text!){
                prepTimeTmp? = prepTime
            }
            if let servings = Int16(txtServings.text!){
                
            }
            if RecipeManager.addRecipe(theAllergens: "", isAvailable: true, theCookTime: cookTimeTmp ?? 0, theDateCreated: "", theDietaryRequirements: dietary, isFavourite: false, theInstructions: txtInstructions.text!, theName: txtName.text!, thePrepTime: prepTimeTmp, theRating: 0, theRecipeDescription: txtDescription.text, theScore: 100, theServings: Int16, theThumbnail: <#T##UIImage#>, theTimeOfDay: <#T##String#>, theIngredients: <#T##[(String, Int16, Bool)]#>)
        }
            
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
