//
//  AddToPantryViewController.swift
//  FoodDeck
//
//  Created by Elkehya, Sara Mruan M on 06/04/2020.
//  Copyright © 2020 computer science. All rights reserved.
//

import UIKit
import CoreData

class AddToPantryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
   
    
    
    @IBOutlet weak var table: UITableView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var managedContext: NSManagedObjectContext?
    
    // all ingredients in ingredient list
    var allIngredients: [Ingredient] = []
    // all ingredients in pantry
    var pantryList: Pantry?
    // list of ingredients that are in the ingredient list but not in the pantry
    // stops the user from trying to add an existing ingredient twice
    var possibleIngredients: [Ingredient] = []
    
    
    var resultSearchController = UISearchController()
    var filteredList: [Ingredient] = []
    
    override func viewWillAppear(_ animated: Bool) {
        managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchIngredientList: NSFetchRequest<Ingredient>  = Ingredient.fetchRequest()
        do {
            allIngredients = try managedContext!.fetch(fetchIngredientList)
            possibleIngredients = (pantryList?.ingredients?.difference(from: allIngredients) ?? [])
            table.reloadData()
        } catch {
            print("could not retrieve ingredients")
        }
    }
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

       // initial search bar setup
        resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.searchBar.sizeToFit()
            controller.searchBar.placeholder = "Search ingredients here.."
            controller.hidesNavigationBarDuringPresentation = false
            table.tableHeaderView = controller.searchBar

            return controller
        })()
    }
    
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
        if presentingViewController == nil {
            // create the alert
            let alert = UIAlertController(title: theIngredient.name, message: "Quantity in \(String(describing: theIngredient.unit))", preferredStyle: UIAlertController.Style.alert)
            
            // allow user to enter numeric input into alert
            alert.addTextField { (textField) in
                textField.placeholder = "quantity..."
                textField.keyboardType = .numberPad
            }

            // add an action (button)
            alert.addAction(UIAlertAction(title: "Save", style: UIAlertAction.Style.default, handler: { (_) in
                // add igredient to pantry list
                self.pantryList?.addToContains(theIngredient)
                do {
                    try self.managedContext?.save()
                    self.navigationController?.popViewController(animated: true)
                } catch {
                    print("Ingredient could not be added to the pantry")
                }
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))

            // show the alert
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
    
    
    // reload data after applying filter
    func updateSearchResults(for searchController: UISearchController) {
        filteredList = possibleIngredients.filter{ ($0.name?.lowercased().contains(searchController.searchBar.text!) ?? false) }
           self.table.reloadData()
       }

}

extension Array where Element: Hashable {
    func difference(from other: [Element]) -> [Element] {
        let thisSet = Set(self)
        let otherSet = Set(other)
        return Array(thisSet.symmetricDifference(otherSet))
    }
    
}
