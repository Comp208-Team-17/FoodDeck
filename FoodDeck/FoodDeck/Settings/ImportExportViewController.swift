//
//  ImportExportViewController.swift
//  FoodDeck
//
//  Created by Luke Wood on 25/04/2020.
//  Copyright © 2020 computer science. All rights reserved.
//

import UIKit

class ImportExportViewController: UIViewController {

    @IBAction func btnMealPacks(_ sender: Any) {
        ImportExportManager.loadMealPacks()
    }
    @IBAction func btnImport(_ sender: Any) {
        ImportExportManager.restoreCustomBackup(backupName: "backup")
    }
    @IBAction func btnExport(_ sender: Any) {
        ImportExportManager.backup(backupName: "backup")
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnMakeMealPacks(_ sender: Any) {
        MealPackManager.makeMealPacks()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
