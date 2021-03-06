

//
//  AddToShoppingListViewController.swift
//  FoodDeck
//
//  Created by Elkehya, Sara Mruan M on 16/04/2020.
//  Copyright © 2020 computer science. All rights reserved.
//

import UIKit
import CoreData

class AddIngredientToRecipeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    
    
    @IBOutlet weak var table: UITableView!
    
    
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var managedContext: NSManagedObjectContext?
    
    // all ingredients in ingredient list
    var allIngredients: [Ingredient] = []
    // all existing ingredients in recipe
    var inRecipe: [Ingredient] = []
    var possibleIngredients: [Ingredient] = []
    
    
    var resultSearchController = UISearchController()
    var filteredList: [Ingredient] = []
    
    override func viewWillDisappear(_ animated: Bool) {
         self.resultSearchController.isActive = false
         self.resultSearchController.definesPresentationContext = false
     }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        managedContext = appDelegate.persistentContainer.viewContext
        resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.searchBar.sizeToFit()
            controller.searchBar.placeholder = "Search ingredients here.."
            controller.obscuresBackgroundDuringPresentation = false
            controller.hidesNavigationBarDuringPresentation = false
            controller.definesPresentationContext = true
            table.tableHeaderView = controller.searchBar
            
            return controller
        })()
        self.definesPresentationContext = true
        self.resultSearchController.isActive = false
        let fetchIngredientList: NSFetchRequest<Ingredient>  = Ingredient.fetchRequest()
        do {
            allIngredients = try managedContext!.fetch(fetchIngredientList)
            getAvailableIngredients()
            table.reloadData()
        } catch {
            print("could not retrieve ingredients")
        }
    }
    
    func getAvailableIngredients() {
        
        let recipeIngredients = EditRecipeIngredientsViewController.localRecipe?.contains?.array as! [RecipeIngredient]
        for index in 0..<recipeIngredients.count {
            inRecipe.append(recipeIngredients[index].ingredient!)
        }
        
        // convert arrays to sets and get the symmetric difference between them
        let setRecipeList = Set(inRecipe)
        let setIngredientList = Set(allIngredients)
        possibleIngredients = Array(setRecipeList.symmetricDifference(setIngredientList))
        
    }
    
    
    // display a filtered list when the search bar is active
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(resultSearchController.isActive) {
            return  filteredList.count
        } else {
            
            return possibleIngredients.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        if(resultSearchController.isActive) {
            cell.textLabel?.text = filteredList[indexPath.row].name
        } else {
            
            cell.textLabel?.text = possibleIngredients[indexPath.row].name
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(resultSearchController.isActive) {
            createAlert(theIngredient: filteredList[indexPath.row])
        } else {
            
            createAlert(theIngredient: possibleIngredients[indexPath.row])
        }
        
        
    }
    
    func createAlert(theIngredient: Ingredient) {
        // create the alert
        let alert = UIAlertController(title: theIngredient.name, message: theIngredient.unit!  == "G" ? "Enter quantity in grams:" : "Enter number of items:", preferredStyle: UIAlertController.Style.alert)
        
        // Create alert properites
        // Error label - replaces normal message
        let errorLabel = UILabel(frame: CGRect(x: 0, y: 43, width: 270, height:18))
        errorLabel.textAlignment = .center
        errorLabel.textColor = .red
        errorLabel.font = errorLabel.font.withSize(13)
        alert.view.addSubview(errorLabel)
        errorLabel.isHidden = true
        
        // allow user to enter numeric input into alert
        alert.addTextField { (textField) in
            textField.placeholder = "quantity..."
            textField.keyboardType = .numberPad
        }
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "Save", style: UIAlertAction.Style.default, handler: { (_) in
            guard let input = alert.textFields?[0].text else { return }
            
            if input == "" {
                // display error message
                alert.message = " "
                errorLabel.isHidden = false
                errorLabel.text = "Quantity field is empty"
                self.present(alert, animated: true, completion: nil)
                
            }
                // make sure value is correct format
            else if let value = Int16(input), value > 0 {
            RecipeIngredientManager.addRecipeIngredient(ingredient: theIngredient, recipe: EditRecipeIngredientsViewController.localRecipe!, amount: value, optional: false)
                self.navigationController?.popViewController(animated: true)
            }
                
            else {
                // display error message
                alert.message = " "
                errorLabel.isHidden = false
                errorLabel.text = "Incorrect quantity format"
                self.present(alert, animated: true, completion: nil)
            }
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    
    
    // reload data after applying filter
    func updateSearchResults(for searchController: UISearchController) {
        let text = searchController.searchBar.text!
        if text == "" {
            filteredList = possibleIngredients
            self.table.reloadData()
        }
        else {
            filteredList = possibleIngredients.filter{ ( ($0.name?.lowercased().contains(text.lowercased()))! ) }
            self.table.reloadData()
        }
    }
    
}
