//
//  SettingsViewController.swift
//  FoodDeck
//
//  Created by Gabrielle Magruder on 14/04/2020.
//  Copyright © 2020 computer science. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var optionsList = ["User Preferences", "Import", "Export"]
    
    @IBOutlet weak var table: UITableView!
    
    // Program options into table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return optionsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "settingsCell")
        let option = optionsList[indexPath.row]
        cell.textLabel?.text = option
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    // Perform segues based on current cell selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentCell = indexPath.row
        if (currentCell == 0){
            performSegue(withIdentifier: "toUserPref", sender: nil)
        }
        else if (currentCell == 1){
            let alert = UIAlertController(title: "Import Backup", message: "This action will completely replace all of your data including recipes and ingredients", preferredStyle: UIAlertController.Style.actionSheet)
            alert.addAction(UIAlertAction(title: "Confirm Import", style: UIAlertAction.Style.default, handler: {(_) in
                ImportExportManager.restoreCustomBackup(backupName: "backup")
                ErrorManager.errorMessageStandard(theTitle: "Restore Complete", theMessage: "You may have to restart the app to access the backup", caller: self)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
           
        }
        else if (currentCell == 2) {
            let alert = UIAlertController(title: "Create Backup", message: "This action will backup all your data", preferredStyle: UIAlertController.Style.actionSheet)
            alert.addAction(UIAlertAction(title: "Confirm Backup", style: UIAlertAction.Style.default, handler: {(_) in
                ImportExportManager.backup(backupName: "backup")
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
        }
    }
}

