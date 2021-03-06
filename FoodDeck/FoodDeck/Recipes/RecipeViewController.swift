//
//  RecipeViewController.swift
//  FoodDeck
//
//  Created by Luke Wood on 11/04/2020.
//  Copyright © 2020 computer science. All rights reserved.
//

import UIKit

class RecipeViewController: UIViewController {
  
    @IBAction func btnAdd(_ sender: Any) {
        RecipeViewController.addButton = true
    }
    @IBOutlet weak var btnDeleteOut: UIButton!
    @IBAction func btnDelete(_ sender: Any) {
        if deleteButton == false{
            btnDeleteOut.setBackgroundImage(UIImage(systemName: "delete.right.fill"), for: .normal)
            deleteButton = true
        }
        else{
            btnDeleteOut.setBackgroundImage(UIImage(systemName: "delete.right"), for: .normal)
            deleteButton = false
        }
        
        
    }
    @IBAction func sgTimeOfDay(_ sender: Any) {
        tblRecipes.reloadData()
    }
    @IBAction func swVegan(_ sender: Any) {
        tblRecipes.reloadData()
    }
    @IBAction func swVeg(_ sender: Any) {
        tblRecipes.reloadData()
  
    }
    @IBAction func swGluten(_ sender: Any) {
        tblRecipes.reloadData()
        
    }
    @IBAction func btnPerformSearch(_ sender: Any) {
        txtSearch.resignFirstResponder()
        tblRecipes.reloadData()
        
    }
    func updateFilter(){
        RecipeViewController.recipes = RecipeManager.filter(theRecipes: RecipeManager.getRecipe(theName: "", all: true) , theTimeOfDayFilter: sgTimeOfDayOut.titleForSegment(at: sgTimeOfDayOut.selectedSegmentIndex)!, theVeganFilter: swDietary[0].isOn, theVegFilter: swDietary[1].isOn, theGlutenFilter: swDietary[2].isOn,theSearch: txtSearch.text ?? "")
    }
    var tempReverse : [RecipeStr] = []
    @IBOutlet var swDietary: [UISwitch]!
    @IBOutlet weak var sgTimeOfDayOut: UISegmentedControl!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var tblRecipes: UICollectionView!
    var deleteButton : Bool = false
    static var chosenRecipeName : String = ""
    static var recipes : [RecipeStr] = []
    static var addButton = false
    var filter : Bool = false
    final override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(true)
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tblRecipes.reloadData()
        RecipeViewController.addButton = false
    }
   
    // if return pressed on keyboard
    @IBAction func searchPrimaryActionTriggered(_ sender: AnyObject) {
        txtSearch.resignFirstResponder()
        tblRecipes.reloadData()
    }
    

}
extension RecipeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        updateFilter()
          return RecipeViewController.recipes.count
      }
      
      func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = tblRecipes.dequeueReusableCell(withReuseIdentifier: "RecipeTblCell", for: indexPath) as! RecipeCollectionView
        cell.txtRecipeName.text = RecipeViewController.recipes[indexPath.item].name
        cell.txtRating.text = "\(RecipeViewController.recipes[indexPath.item].rating)"
        cell.recipeImage.image = RecipeViewController.recipes[indexPath.item].thumbnail ?? nil
        cell.recipeButtonDelegate = self
        if RecipeViewController.recipes[indexPath.item].favourite == true {
            cell.btnFavouriteOut.setImage(UIImage(named: "heart-green"), for: .normal)
            cell.favourite = true
        }
        else{
            cell.btnFavouriteOut.setImage(UIImage(named: "heart-green-outline"), for: .normal)
            cell.favourite = false
        }
        
        let totalTime = Int(RecipeViewController.recipes[indexPath.item].cookTime) + Int(RecipeViewController.recipes[indexPath.item].prepTime)
        cell.txtTime!.text = totalTime <= Int16.max ?  "\(totalTime)" : "\(RecipeViewController.recipes[indexPath.item].cookTime)"
        return cell
        
        
      }
}
extension RecipeViewController: RecipeCollectionViewDelegate{

    func didTapRecipe(onCell: RecipeCollectionView) {
        RecipeViewController.chosenRecipeName = onCell.txtRecipeName.text!
        if deleteButton == true{
            if RecipeViewController.recipes.contains(where: {$0.name == RecipeViewController.chosenRecipeName && $0.mealPack != ""}){
                ErrorManager.errorMessageStandard(theTitle: "Meal Pack", theMessage: "This recipe cannot be deleted because it is part of a meal pack. Please disable the meal pack in settings", caller: self)
            }
            else{
                RecipeManager.deleteRecipe(theName: RecipeViewController.chosenRecipeName)
                tblRecipes.reloadData()
            }
        }
        else{
            performSegue(withIdentifier: "toRecipeDetail", sender: self)
        }
        
   }
}


