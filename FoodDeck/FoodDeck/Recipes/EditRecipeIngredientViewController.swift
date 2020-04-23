//
//  EditRecipeIngredientsViewController.swift
//  FoodDeck
//
//  Created by Luke Wood on 14/04/2020.
//  Copyright © 2020 computer science. All rights reserved.
//

import UIKit

class EditRecipeIngredientsViewController: UIViewController {


    @IBOutlet weak var tblIngredients: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    static var localRecipe : Recipe?
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(true)
       
        tblIngredients.reloadData()
        
    }
    var recipeIngredients : [(String, Int16, Bool, String, Bool)] = []
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
         EditRecipeIngredientsViewController.localRecipe = RecipeManager.getRecipeObject(theName: RecipeDetailViewController.localRecipe[0].name)[0]
        recipeIngredients = RecipeIngredientManager.getIngredients(recipe: EditRecipeIngredientsViewController.localRecipe!, enabled: false)
        return recipeIngredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblIngredients.dequeueReusableCell(withIdentifier: "recipeIngredientTable") as! RecipeIngredientsTable
        cell.txtName.text = recipeIngredients[indexPath.row].0
        cell.txtAmount.text = "\(recipeIngredients[indexPath.row].1)"
        cell.txtEnabled.text = "\(recipeIngredients[indexPath.row].2)"
        cell.txtUnit.text = "\(recipeIngredients[indexPath.row].3)"
        cell.txtOptional.text = "\(recipeIngredients[indexPath.row].4)"
        cell.buttonDelegate = self
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}
extension EditRecipeIngredientsViewController : RecipeIngredientTableDelegate {

    func didTapOptional(sender: RecipeIngredientsTable, optional : Bool) {
        RecipeIngredientManager.updateRecipeIngredient(recipeIngredient: RecipeIngredientManager.getRecipeIngredientObject(theIngredientName: sender.txtName.text!, recipe: EditRecipeIngredientsViewController.localRecipe!)[0], updatedAmount: Int16(sender.txtAmount.text!)!, updatedOptional: optional)
        
    }
}
