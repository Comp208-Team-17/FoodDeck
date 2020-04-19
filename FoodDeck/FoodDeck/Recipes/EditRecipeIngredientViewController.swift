//
//  EditRecipeIngredientsViewController.swift
//  FoodDeck
//
//  Created by Luke Wood on 14/04/2020.
//  Copyright © 2020 computer science. All rights reserved.
//

import UIKit

class EditRecipeIngredientsViewController: UIViewController {

    @IBAction func swThisMealAction(_ sender: Any) {
        
    }
    @IBOutlet weak var swThisMeal: UISwitch!
    @IBOutlet weak var tblIngredients: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(true)
        
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
