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
            btnDeleteOut.setTitle("Cancel", for: .normal)
            deleteButton = true
        }
        else{
            btnDeleteOut.setTitle("Delete", for: .normal)
            deleteButton = false
        }
        
        
    }
    @IBOutlet weak var tblRecipes: UICollectionView!
    var deleteButton : Bool = false
    static var chosenRecipeName : String = ""
    static var recipes : [RecipeStr] = []
    static var addButton = false
    final override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(true)
        tblRecipes.reloadData()
        RecipeViewController.addButton = false
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
extension RecipeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         RecipeViewController.recipes = RecipeManager.getRecipe(theName: "", all: true)
        print (RecipeViewController.recipes.count)
    
          return RecipeViewController.recipes.count
      }
      
      func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = tblRecipes.dequeueReusableCell(withReuseIdentifier: "RecipeTblCell", for: indexPath) as! RecipeCollectionView
        cell.txtRecipeName.text = RecipeViewController.recipes[indexPath.item].name
        cell.txtRating.text = "\(RecipeViewController.recipes[indexPath.item].rating)"
        cell.recipeImage.image = RecipeViewController.recipes[indexPath.item].thumbnail ?? nil
        cell.recipeButtonDelegate = self
        return cell
        
        
      }
}
extension RecipeViewController: RecipeCollectionViewDelegate{

    func didTapRecipe(onCell: RecipeCollectionView) {
        RecipeViewController.chosenRecipeName = onCell.txtRecipeName.text!
        if deleteButton == true{
            RecipeManager.deleteRecipe(theName: RecipeViewController.chosenRecipeName)
            tblRecipes.reloadData()
        }
        else{
            performSegue(withIdentifier: "toRecipeDetail", sender: self)
        }
        
   }
}

