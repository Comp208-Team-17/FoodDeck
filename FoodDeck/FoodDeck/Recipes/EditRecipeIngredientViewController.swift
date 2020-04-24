//
//  EditRecipeIngredientsViewController.swift
//  FoodDeck
//
//  Created by Luke Wood on 14/04/2020.
//  Copyright © 2020 computer science. All rights reserved.
//

import UIKit

class EditRecipeIngredientsViewController: UIViewController {



    @IBAction func swVegan(_ sender: Any) {
    }
    @IBAction func swVeg(_ sender: Any) {
    }
    @IBAction func swGlutenFree(_ sender: Any) {
        
    }
    
    @IBOutlet weak var tblIngredients: UITableView!
    
    @IBOutlet var swDietary: [UISwitch]!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    static var localRecipe : Recipe?
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(true)
        let dietaryRequirements = RecipeManager.revertDietaryValue(value: RecipeDetailViewController.localRecipe[0].dietaryRequirements)
        tblIngredients.reloadData()
        for index in 0...2{
            swDietary[index].isOn = dietaryRequirements[index]
        }
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParent{
            let dietaryRequirements = RecipeManager.convertDietaryValue(vegan: swDietary[0].isOn, veg: swDietary[1].isOn, gluten: swDietary[2].isOn)
            if RecipeManager.updateRecipeDietary(theName: RecipeDetailViewController.localRecipe[0].name, theDietaryRequirements: dietaryRequirements) ==  false {
            }
        }
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
         EditRecipeIngredientsViewController.localRecipe = RecipeManager.getRecipeObject(theName: RecipeViewController.chosenRecipeName)[0]
        recipeIngredients = RecipeIngredientManager.getIngredients(recipe: EditRecipeIngredientsViewController.localRecipe!, enabled: false)
        return recipeIngredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblIngredients.dequeueReusableCell(withIdentifier: "recipeIngredientTable") as! RecipeIngredientsTable
        cell.txtName.text = recipeIngredients[indexPath.row].0
        cell.txtAmount.text = "\(recipeIngredients[indexPath.row].1)"
        if (recipeIngredients[indexPath.row].2) == false {
            cell.txtEnabled.text = "Disabled"
        }
        cell.txtUnit.text = "\(recipeIngredients[indexPath.row].3)"
        if (recipeIngredients[indexPath.row].4) == false {
            cell.txtOptional.isHidden = true
            cell.optional = false
            cell.btnOptional.setTitle("Make Optional", for: .normal)
        }
        
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
    func didTapDeleteButton(sender: RecipeIngredientsTable) {
        RecipeIngredientManager.removeIngredient(ingredient: IngredientManager.getIngredientObject(theName: sender.txtName.text!)[0], recipe: EditRecipeIngredientsViewController.localRecipe!)
        tblIngredients.reloadData()
    }
}
