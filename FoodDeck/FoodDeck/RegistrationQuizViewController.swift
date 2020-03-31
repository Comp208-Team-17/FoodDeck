//
//  RegistrationQuizViewController.swift
//  FoodDeck
//
//  Created by Gabrielle Magruder on 30/03/2020.
//  Copyright © 2020 computer science. All rights reserved.
//

import UIKit

class RegistrationQuizViewController: UIViewController {

    @IBOutlet weak var mealPackTable: UITableView!
    @IBOutlet weak var allergyTable: UITableView!
    
    var mealRows = 0
    var allergyRows = 0
    
    
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
    
    // Get ingredients core data
    func getIngredients(){
        
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
            return mealRows
        }
            
        // Code for allergy table
        else {
            return allergyRows
        }
    }
    
    // Make cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        
        // Code for meal pack table
        if (tableView == self.mealPackTable) {
            cell = tableView.dequeueReusableCell(withIdentifier: "mealPackCell") as! MealPackCell
            
        }
            
        // Code for allergy table
        else {
            cell = tableView.dequeueReusableCell(withIdentifier: "allergyCell") as! AllergyCell
        }
        
        return cell
        
    }
    
    // Load core data then enter data into tables
    override func viewDidLoad() {
        super.viewDidLoad()
        getMealPacks()
        getIngredients()
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
    
}

class AllergyCell: UITableViewCell {
    @IBOutlet weak var allergyLabel: UILabel!
}
