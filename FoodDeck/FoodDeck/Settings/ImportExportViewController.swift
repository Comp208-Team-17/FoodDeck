//
//  ImportExportViewController.swift
//  FoodDeck
//
//  Created by Luke Wood on 25/04/2020.
//  Copyright © 2020 computer science. All rights reserved.
//

import UIKit

class ImportExportViewController: UIViewController {

    @IBAction func btnImport(_ sender: Any) {
        ImportExportManager.restoreFromStore(backupName: "crap")
    }
    @IBAction func btnExport(_ sender: Any) {
        ImportExportManager.backup(backupName: "crap2")
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
