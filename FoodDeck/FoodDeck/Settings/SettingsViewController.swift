//
//  SettingsViewController.swift
//  FoodDeck
//
//  Created by Gabrielle Magruder on 14/04/2020.
//  Copyright © 2020 computer science. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var optionsList = ["User Preferences", "Import/Export"]
    
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
            performSegue(withIdentifier: "toImportExport", sender: nil)
        }
    }
}

