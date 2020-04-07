//
//  RegistrationQuizViewController.swift
//  FoodDeck
//
//  Created by Gabrielle Magruder on 30/03/2020.
//  Copyright © 2020 computer science. All rights reserved.
//

import UIKit

class RegistrationQuizViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var mealPacksList: [MealPackStr] = []
    var ingredientsList : [IngredientStr] = []
    var allergyList: [IngredientStr] = []
    
    @IBOutlet weak var mealPackTable: UITableView!
    @IBOutlet weak var allergyTable: UITableView!
    
    
    // User skips quiz, continues to main app
    @IBAction func skipButton(_ sender: Any) {
        performSegue(withIdentifier: "toMainView", sender: nil)
    }
    
    // User submits quiz, save results, continues to main app
    @IBAction func submitButton(_ sender: Any) {
        MealPackManager.updateMealPack(newMealPacks: mealPacksList)
        updateAllergy()
        performSegue(withIdentifier: "toMainView", sender: nil)
    }
    
    @IBAction func addButton(_ sender: Any) {
        // Make alert
        let alert = UIAlertController(title: "Enter Allergy:", message: "Search for your allergy here", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.text = "Some default text"
        }
        
        // Add text field
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            print("Text field: \(textField?.text ?? "")")
        }))
        
        // Show alert
        self.present(alert, animated: true, completion: nil)
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
            
            // Code for enabling/disabling meal packs via switches
            mealCell.mealPackEnabled.setOn(mealPack.enabled, animated: true)
            mealCell.mealPackEnabled.tag = indexPath.row //Store current position of switch
            mealCell.mealPackEnabled.addTarget(self, action: #selector(self.switchChanged(_:)), for: .valueChanged)
            
            return mealCell
        }
            
        // Code for allergy table
        else {
            let allergyCell = tableView.dequeueReusableCell(withIdentifier: "allergyCell", for: indexPath)
            let allergy = allergyList[indexPath.row]
            allergyCell.textLabel?.text = allergy.name
            
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
        mealPacksList = MealPackManager.getMealPacks()
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



// Commit comment
// Custom cell classes for quiz
class MealPackCell: UITableViewCell {
    @IBOutlet weak var mealPackLabel: UILabel!
    @IBOutlet weak var mealPackEnabled: UISwitch!
    
}

class AllergyCell: UITableViewCell {
    @IBOutlet weak var allergyLabel: UILabel!
}