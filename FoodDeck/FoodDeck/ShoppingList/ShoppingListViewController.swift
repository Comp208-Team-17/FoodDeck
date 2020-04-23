//
//  ShoppingListViewController.swift
//  FoodDeck
//
//  Created by Elkehya, Sara Mruan M on 16/04/2020.
//  Copyright © 2020 computer science. All rights reserved.
//

import UIKit
import CoreData

class ShoppingListCell: UITableViewCell {
    @IBOutlet weak var checkSwitch: UISwitch!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
}

class ShoppingListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var managedContext: NSManagedObjectContext?
    
    var boughtIngredients: [ShoppingListIngredient] = []
    var inShoppingList: [ShoppingListIngredient] = []
    
    @IBOutlet weak var table: UITableView!
    
    @IBOutlet weak var saveButton: UIButton!
    
    // action when button pressed
    @IBAction func save(_ sender: Any) {
        managedContext = appDelegate.persistentContainer.viewContext
        // if ingredients have been selected
        if boughtIngredients.count > 0 {
            for index in 0..<boughtIngredients.count {
                
                
                do {
                    // if ingredient already exists in pantry
                    if boughtIngredients[index].belongsTo?.pantryIngredient != nil {
                        let originalValue = (boughtIngredients[index].belongsTo?.pantryIngredient?.amount)!
                        let newValue = Int(originalValue) + Int(boughtIngredients[index].amount)
                        // check if within upper limit -> 32767
                        if newValue <= Int16.max {
                            // update its new amount
                            boughtIngredients[index].belongsTo?.pantryIngredient?.setValue(newValue, forKey: "amount")
                            deleteFromShoppingList(ingredient: boughtIngredients[index])
                        }
                        else {
                            // present error to user
                            let alert = UIAlertController(title: "Exceeds maximum quantity", message: "One or more of the ingredients selected could not be added to the pantry", preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                            
                            // show the alert
                            self.present(alert, animated: true, completion: nil)
                        }
                        
                    }
                        // ingredient does not exist in pantry
                    else {
                        // add to pantry
                        let pantryIngredientEntity = NSEntityDescription.entity(forEntityName: "PantryIngredient", in: self.managedContext!)!
                        let newPantryIngredient = NSManagedObject(entity: pantryIngredientEntity, insertInto: self.managedContext!)
                        newPantryIngredient.setValue(boughtIngredients[index].amount, forKey: "amount")
                        newPantryIngredient.setValue(boughtIngredients[index].belongsTo, forKey: "belongsTo")
                        deleteFromShoppingList(ingredient: boughtIngredients[index])
                    }
                    // save changes
                    try managedContext!.save()
                    
                } catch {
                    print("Pantry and shopping list could not be updated")
                }
                
                
            }
            // return to default state
            saveButton.isEnabled = false
            boughtIngredients.removeAll()
            table.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // set default values and fetch all shopping list ingrediens
    override func viewWillAppear(_ animated: Bool) {
        managedContext = appDelegate.persistentContainer.viewContext
        boughtIngredients.removeAll()
        saveButton.isEnabled = false
        
        inShoppingList = ShoppingListIngredient.getShoppingList()
        table.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // count all shopping list ingredients
        return inShoppingList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = table.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! ShoppingListCell
        let ingredient = inShoppingList[indexPath.row]
        cell.titleLabel?.text = ingredient.belongsTo?.name
        cell.subtitleLabel?.textColor = .systemGreen
        cell.subtitleLabel?.text = "\(ingredient.amount) \(ingredient.belongsTo?.unit! ?? "")"
        // switch properties
        cell.checkSwitch.setOn(false, animated: true)
        cell.checkSwitch.tag = indexPath.row
        // when switch state is changed, run switchChanged() method
        cell.checkSwitch.addTarget(self, action: #selector(self.switchChanged(_:)), for: .valueChanged)
        
        
        return cell
    }
    
    @objc func switchChanged(_ sender: UISwitch!){
        // switch is green
        if sender.isOn {
            // store in array
            boughtIngredients.append(inShoppingList[sender.tag])
        }
        else {
            boughtIngredients.remove(at: boughtIngredients.firstIndex(of: inShoppingList[sender.tag])!)
        }
        // disable button if no items selected
        if boughtIngredients.isEmpty { saveButton.isEnabled = false } else { saveButton.isEnabled = true }
    }
    
    func deleteFromShoppingList(ingredient: ShoppingListIngredient) {
        // remove instance
        managedContext?.delete(ingredient)
        // remove from list
        inShoppingList.remove(at: inShoppingList.firstIndex(of: ingredient)!)
        
        do {
            try managedContext?.save()
        } catch {
            print("Ingredient could not be removed from the shopping list")
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // remove from shopping list
        if editingStyle == .delete {
            let ingredient = inShoppingList[indexPath.row]
            deleteFromShoppingList(ingredient: ingredient)
            if boughtIngredients.contains(ingredient) {
                boughtIngredients.remove(at: boughtIngredients.firstIndex(of: ingredient)!)
            }
            // remove from table
            table.deleteRows(at: [indexPath], with: .none)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let theIngredient = inShoppingList[indexPath.row].belongsTo!
        let ShoppingListIngredient = inShoppingList[indexPath.row]
        
        // create the alert
        let alert = UIAlertController(title: theIngredient.name, message: "Quantity in \(theIngredient.unit!)", preferredStyle: UIAlertController.Style.alert)
        
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
            textField.text = "\(ShoppingListIngredient.amount)"
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
            else if let value = Int16(input) {
                // add igredient to shopping list
                ShoppingListIngredient.setValue(value, forKey: "amount")
                do {
                    try self.managedContext!.save()
                    self.table.reloadRows(at: [indexPath], with: .none)
                    self.navigationController?.popViewController(animated: true)
                } catch {
                    print("Ingredient could not be added")
                }
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // when '+' is clicked
        if segue.identifier == "toAddToShoppingList" {
            let detailViewController = segue.destination as! AddToShoppingListViewController
            // pass details to detail view
            detailViewController.inShoppingList = self.inShoppingList
            detailViewController.modalPresentationStyle = .fullScreen
        }
    }
    
    
}


