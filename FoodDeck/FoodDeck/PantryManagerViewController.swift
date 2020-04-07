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
    
    var pantryList: Pantry?

    override func viewDidLoad() {
        super.viewDidLoad()
        managedContext = appDelegate.persistentContainer.viewContext
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.table.reloadData()
    }
    
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // count all pantry ingredients
        return pantryList?.ingredients?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        if let ingredient = pantryList?.ingredients?[indexPath.row] {
            cell.textLabel?.text = ingredient.name
            cell.detailTextLabel?.text = "\(pantryList?.amount ?? 0) \(String(describing: ingredient.unit))"
            
        }
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            
            // remove from pantry
            if editingStyle == .delete {
            guard let ingredient = pantryList?.ingredients?[indexPath.row] else { return }
            // remove relationship
            self.pantryList?.removeFromContains(ingredient)
                // remove from table
            table.deleteRows(at: [indexPath], with: .none)
            do {
                try managedContext?.save()
            } catch {
                print("Ingredient could not be removed from the pantry")
            }
//                guard let ingredient = pantryList?.ingredients?[indexPath.row], let context = ingredient.managedObjectContext else { return }
    //        context.delete(ingredient)
    //        table.deleteRows(at: [indexPath], with: .none)
    //
    //        do {
    //            try context.save()
    //            print("Saved to pantry")
    //
    //        } catch {
    //            print("could not delete from pantry")
    //            table.reloadRows(at: [indexPath], with: .none)
    //        }
          }
        }
  

}
