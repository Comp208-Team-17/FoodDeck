//
//  RegistrationQuizViewController.swift
//  FoodDeck
//
//  Created by Gabrielle Magruder on 30/03/2020.
//  Copyright © 2020 computer science. All rights reserved.
//

import UIKit

class RegistrationQuizViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var mealPacksList: [MealPackStr] = [MealPackStr()]
    var ingredientsList : [IngredientStr] = [IngredientStr()]
    var allergyList: [IngredientStr] = [IngredientStr()]
    
    @IBOutlet weak var mealPackTable: UITableView!
    @IBOutlet weak var allergyTable: UITableView!
    
    
    // User skips quiz, continues to main app
    @IBAction func skipButton(_ sender: Any) {
        performSegue(withIdentifier: "toMainView", sender: nil)
    }
    
    // User submits quiz, save results, continues to main app
    @IBAction func submitButton(_ sender: Any) {
        updateMealPacks()
        updateAllergy()
        performSegue(withIdentifier: "toMainView", sender: nil)
    }
    
    
    // Get meal pack core data
    func getMealPacks(){
        
    }
    
    
    // Update meal pack availabilty on submit
    func updateMealPacks(){
        
    }
    
    // Update user allergies
    func updateAllergy(){
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Code for meal pack table
        if (tableView == self.mealPackTable) {
            return mealPacksList.count
        }
            
        // Code for allergy table
        else {
            return allergyList.count
        }
     
    }
    
    // Make cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Code for meal pack table
        if (tableView == self.mealPackTable) {
             let mealCell = tableView.dequeueReusableCell(withIdentifier: "mealPackCell") as! MealPackCell
            let mealPack = mealPacksList[indexPath.row]
            mealCell.mealPackLabel?.text = mealPack.name
            
            // Code for enabling/disabling meal packs
            mealCell.mealPackEnabled.setOn(mealPack.enabled, animated: true)
            mealCell.mealPackEnabled.tag = indexPath.row //Store current position of switch
            mealCell.mealPackEnabled.addTarget(self, action: #selector(self.switchChanged(_:)), for: .valueChanged)
            
            return mealCell
        }
            
        // Code for allergy table
        else {
            let allergyCell = tableView.dequeueReusableCell(withIdentifier: "allergyCell") as! AllergyCell
            let allergy = allergyList[indexPath.row]
            allergyCell.allergyLabel?.text = allergy.name
            
            return allergyCell
        }
    
    }
    
    // Update meal pack when it is enabled/disabled
    @objc func switchChanged(_ sender : UISwitch!){
        mealPacksList[sender.tag].enabled = sender.isOn
    }
    
    // Delete allergy from allergy table
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // Only run if the table view is the allergy table
        if (editingStyle == UITableViewCell.EditingStyle.delete && tableView == self.allergyTable) {
            allergyList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        }
    }
        
    // Load core data then enter data into tables
    override func viewDidLoad() {
        super.viewDidLoad()
        getMealPacks()
        ingredientsList = IngredientManager.getIngredient(theName: "", enabled: false, all: true)
    }
    
    //Skip straight to main app - better to do on splash page
    override func viewDidAppear(_ animated: Bool) {
        var skipQuiz = false
        if (skipQuiz == true){
            performSegue(withIdentifier: "toMainView", sender: nil)
        }
    }

}




// Custom cell classes for quiz
class MealPackCell: UITableViewCell {
    @IBOutlet weak var mealPackLabel: UILabel!
    @IBOutlet weak var mealPackEnabled: UISwitch!
    
}

class AllergyCell: UITableViewCell {
    @IBOutlet weak var allergyLabel: UILabel!
}
