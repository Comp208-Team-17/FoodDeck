//
//  EditRecipeViewController.swift
//  FoodDeck
//
//  Created by Luke Wood on 14/04/2020.
//  Copyright © 2020 computer science. All rights reserved.
//

import UIKit

class EditRecipeViewController: UIViewController {
    
    @IBOutlet weak var selector: UIPickerView!
    @IBOutlet weak var txtServings: UITextField!
    @IBOutlet weak var txtPrepTime: UITextField!
    @IBOutlet weak var txtCookTime: UITextField!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtDescription: UITextView!
    @IBOutlet weak var txtInstructions: UITextView!
    @IBOutlet weak var btnChooseIngredients: UIButton!
    static var dietary : String = "000"
    let pickerOptions : [String] = ["Breakfast", "Lunch", "Dinner"]
    var pickerOptionSet : String = "Breakfast"
    var chooseIngredients = false
    
    @IBAction func btnPhoto(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    @IBAction func btnSave(_ sender: Any){
        var saveComplete : Bool = true
        var cookTimeTmp : Int16?
        var prepTimeTmp : Int16?
        var servingsTmp : Int16?
        if let cookTime = Int16(txtCookTime.text!), cookTime >= 0 {
            cookTimeTmp = cookTime
        }
        else{
            saveComplete = false
        }
        if let prepTime = Int16(txtPrepTime.text!), prepTime >= 0 {
            prepTimeTmp = prepTime
        }
        else{
            saveComplete = false
        }
        if let servings = Int16(txtServings.text!), servings >= 0{
            servingsTmp = servings
        }
        else {
            saveComplete = false
        }
        if saveComplete == true{
            if RecipeViewController.addButton == true {
                if RecipeManager.addRecipe(theAllergens: "", isAvailable: true, theCookTime: cookTimeTmp ?? 0, theDateCreated: "", theDietaryRequirements: EditRecipeViewController.dietary, isFavourite: false, theInstructions: txtInstructions.text!, theName: txtName.text!, thePrepTime: prepTimeTmp ?? 0, theRating: 0, theRecipeDescription: txtDescription.text!, theScore: 100, theServings: servingsTmp ?? 0, theThumbnail: recipeImage.image!, theTimeOfDay: pickerOptionSet, theIngredients: []) == false{
                    ErrorManager.errorMessageStandard(theTitle: "Recipe Error", theMessage: "Could not add new recipe - ensure you have not duplicated a recipe name.", caller: self)
                    
                }
                else {
                    RecipeViewController.addButton = false
                    btnChooseIngredients.isEnabled = true
                    RecipeDetailViewController.localRecipe = RecipeManager.getRecipe(theName: txtName.text!, all: false)
                    RecipeViewController.chosenRecipeName = txtName.text!
                }
            }
            else {
                //update recipe
                
                if RecipeManager.updateRecipeExceptIngredients(originalName: RecipeDetailViewController.localRecipe[0].name
                    ,newName: txtName.text!, theAllergens: "", isAvailable: RecipeDetailViewController.localRecipe[0].available, theCookTime: cookTimeTmp ?? 0 , theDateCreated: RecipeDetailViewController.localRecipe[0].dateCreated, theDietaryRequirements: "ignore", isFavourite: RecipeDetailViewController.localRecipe[0].favourite
                    , theInstructions: txtInstructions.text!, thePrepTime: prepTimeTmp ?? 0, theRating: RecipeDetailViewController.localRecipe[0].rating
                    , theRecipeDescription: txtDescription.text!, theScore: RecipeDetailViewController.localRecipe[0].score, theServings: servingsTmp ?? 0, theThumbnail: recipeImage.image!, theTimeOfDay: pickerOptionSet) == false {
                    ErrorManager.errorMessageStandard(theTitle: "Recipe Error", theMessage: "Error updating recipe, ensure you have not duplicated a recipe name", caller: self)
                }
                else{
                    RecipeDetailViewController.localRecipe = RecipeManager.getRecipe(theName: txtName.text!, all: false)
                    RecipeViewController.chosenRecipeName = txtName.text!
                }
            }
        }
        else {
            //display error message
            ErrorManager.errorMessageStandard(theTitle: "Recipe Error", theMessage: "Error updating recipe, please complete all fields", caller: self)
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
            txtCookTime.text = "\(RecipeDetailViewController.localRecipe[0].cookTime)"
            txtPrepTime.text = "\(RecipeDetailViewController.localRecipe[0].prepTime)"
            txtServings.text = "\(RecipeDetailViewController.localRecipe[0].servings)"
            switch(RecipeDetailViewController.localRecipe[0].timeOfDay){
            case "Breakfast":
                selector.selectRow(0, inComponent: 0, animated: true)
                pickerOptionSet = "Breakfast"
                break
            case "Lunch":
                selector.selectRow(1, inComponent: 0, animated: true)
                pickerOptionSet = "Lunch"
                break
            default :
                selector.selectRow(2, inComponent: 0, animated: true)
                pickerOptionSet = "Dinner"
            }
            
        }
        if RecipeViewController.addButton == true {
            
            btnChooseIngredients.isEnabled = false
        }
    }
    
    // dismiss keyboard when user taps outside it
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        txtServings.resignFirstResponder()
        txtCookTime.resignFirstResponder()
        txtPrepTime.resignFirstResponder()
        txtName.resignFirstResponder()
        txtDescription.resignFirstResponder()
        txtInstructions.resignFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // notify methods that textfield selected
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        // notify method that the text field is no longer selected
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        // recognise when text field loses focus
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    // return frame to its original position
    @objc func keyboardWillHide() {
        self.view.frame.origin.y = 0
    }
    
    // move frame upwards to accomodate keyboard
    @objc func keyboardWillChange(notification: NSNotification) {

        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if txtServings.isFirstResponder || txtPrepTime.isFirstResponder || txtCookTime.isFirstResponder {
                self.view.frame.origin.y = -keyboardSize.height
            }
        }
    }
    
    
    @IBAction func namePrimaryAction(_ sender: Any) {
        txtName.resignFirstResponder()
    }
    @IBAction func servingsPrimaryAction(_ sender: Any) {
        txtServings.resignFirstResponder()
    }
    @IBAction func prepTimePrimaryAction(_ sender: Any) {
        txtPrepTime.resignFirstResponder()
    }
    @IBAction func cookTimePrimaryAction(_ sender: Any) {
        txtCookTime.resignFirstResponder()
    }
    
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
extension EditRecipeViewController : UINavigationControllerDelegate , UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[.editedImage] as? UIImage else {
            ErrorManager.errorMessageStandard(theTitle: "Image Import Error", theMessage: "Could not import selected image, please try again or select another image", caller: self)
            return
        }
        recipeImage.image = image
    }
}
