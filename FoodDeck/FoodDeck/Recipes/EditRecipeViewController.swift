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
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtDescription: UITextView!
    @IBOutlet weak var txtInstructions: UITextView!
    @IBOutlet weak var btnChooseIngredients: UIButton!
    static var dietary : String = ""
    let pickerOptions : [String] = ["Breakfast", "Lunch", "Dinner"]
    var pickerOptionSet : String = "Breakfast"
    var chooseIngredients = false
    @IBAction func btnSave(_ sender: Any) {
        var saveComplete : Bool = false
        if RecipeViewController.addButton == true {
            var cookTimeTmp : Int16?
            var prepTimeTmp : Int16?
            var servingsTmp : Int16?
            if let cookTime = Int16(txtCookTime.text!){
                cookTimeTmp? = cookTime
            }
            else{
                saveComplete = false
            }
            if let prepTime = Int16(txtPrepTime.text!){
                prepTimeTmp? = prepTime
            }
            else{
                saveComplete = false
            }
            if let servings = Int16(txtServings.text!){
                servingsTmp? = servings
            }
            else {
                saveComplete = false
            }
            
            if saveComplete == true {
                if RecipeManager.addRecipe(theAllergens: "", isAvailable: true, theCookTime: cookTimeTmp ?? 0, theDateCreated: "", theDietaryRequirements: EditRecipeViewController.dietary, isFavourite: false, theInstructions: txtInstructions.text!, theName: txtName.text!, thePrepTime: prepTimeTmp!, theRating: 0, theRecipeDescription: txtDescription.text, theScore: 100, theServings: servingsTmp!, theThumbnail: UIImage(), theTimeOfDay: pickerOptionSet, theIngredients: []){
                             chooseIngredients = true
                    btnChooseIngredients.isEnabled = true
                         }
                else {
                    //display error message about saving recipe
                }
                
            }
            else {
                //display error message
            }
         
        }
        else {
            //load ingredient information
            chooseIngredients = true
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
        if RecipeViewController.addButton == true {
            btnChooseIngredients.isEnabled = false
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
extension EditRecipeViewController : UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerOptions.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerOptions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerOptionSet = pickerOptions[row]
    }
}
