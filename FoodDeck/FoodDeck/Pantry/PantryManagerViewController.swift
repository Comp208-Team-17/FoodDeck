//
//  PantryManagerViewController.swift
//  FoodDeck
//
//  Created by Elkehya, Sara Mruan M on 06/04/2020.
//  Copyright © 2020 computer science. All rights reserved.
//

import UIKit
import CoreData


class PantryManagerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var managedContext: NSManagedObjectContext?
    
    
    @IBOutlet weak var table: UITableView!
    
    var inPantry: [PantryIngredient] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        managedContext = appDelegate.persistentContainer.viewContext
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        inPantry = PantryIngredient.getPantry()
        table.reloadData()
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // count all pantry ingredients
        return inPantry.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        let ingredient = inPantry[indexPath.row]
        cell.textLabel?.text = ingredient.belongsTo?.name
        cell.detailTextLabel?.textColor = .systemGreen
        cell.detailTextLabel?.text = "\(ingredient.amount) \(ingredient.belongsTo?.unit! ?? "")"
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        // remove from pantry
        if editingStyle == .delete {
            let ingredient = inPantry[indexPath.row]
            // remove relationship
            managedContext?.delete(ingredient)
            inPantry.remove(at: indexPath.row)
            // remove from table
            table.deleteRows(at: [indexPath], with: .none)
            do {
                try managedContext?.save()
            } catch {
                print("Ingredient could not be removed from the pantry")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let theIngredient = inPantry[indexPath.row].belongsTo!
        let pantryIngredient = inPantry[indexPath.row]
        
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
            textField.text = "\(pantryIngredient.amount)"
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
                // add igredient to pantry list
                pantryIngredient.setValue(value, forKey: "amount")
                
                do {
                    try self.managedContext!.save()
                    self.table.reloadRows(at: [indexPath], with: .none)
                    self.navigationController?.popViewController(animated: true)
                } catch {
                    print("Ingredient could not be added to the pantry")
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
        if segue.identifier == "toAddToPantry" {
            let detailViewController = segue.destination as! AddToPantryViewController
            // pass details to detail view
            detailViewController.inPantry = self.inPantry
            detailViewController.modalPresentationStyle = .fullScreen
        }
    }
    
    
}
