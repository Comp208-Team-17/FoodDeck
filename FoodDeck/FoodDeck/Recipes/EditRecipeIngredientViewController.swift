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
    var localRecipe : Recipe
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(true)
         localRecipe = RecipeManager.getRecipeObject(theName: RecipeDetailViewController.localRecipe[0].name)[0]
        
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
extension EditRecipeIngredientsViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let recipeIngredients : [(String, Int16, Bool, String, Bool)] = RecipeIngredientManager.getIngredients(recipe: localRecipe, enabled: false)
        let cell = tblIngredients.dequeueReusableCell(withIdentifier: "recipeIngredientTable") as! RecipeIngredientsTable
        cell.txtName.text = recipeIngredients[indexPath.row].0
        cell.txtAmount.text = "\(recipeIngredients[indexPath.row].1)"
        cell.txtEnabled.text = "\(recipeIngredients[indexPath.row].2)"
        return cell
    }
    
    
}
