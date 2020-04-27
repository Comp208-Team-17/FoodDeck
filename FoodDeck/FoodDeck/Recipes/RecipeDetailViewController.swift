//
//  RecipeDetailViewController.swift
//  FoodDeck
//
//  Created by Luke Wood on 13/04/2020.
//  Copyright © 2020 computer science. All rights reserved.
//

import UIKit

class RecipeDetailViewController: UIViewController {

    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var lblPrep: UILabel!
    @IBOutlet weak var lblCook: UILabel!
    @IBOutlet weak var lblServings: UILabel!
    @IBAction func btnFavourite(_ sender: Any) {
      setFavourite()
    }
    @IBAction func btnOneStar(_ sender: Any) {
        setStars(numberOfStars: 1)
    }
    @IBAction func btnTwoStars(_ sender: Any) {
         setStars(numberOfStars: 2)
    }
    @IBAction func btnThreeStars(_ sender: Any) {
        setStars(numberOfStars: 3)
    }
    @IBAction func btnFourStars(_ sender: Any) {
        setStars(numberOfStars: 4)
    }
    @IBAction func btnFiveStars(_ sender: Any) {
        setStars(numberOfStars: 5)
    }
    @IBAction func btnResetRating(_ sender: Any) {
        setStars(numberOfStars: 0)
    }
    var favourite : Bool = false
    @IBOutlet weak var btnFavouriteOutlet: UIButton!
    @IBOutlet var btnStarsOutlet: [UIButton]!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet var imgDietary: [UIImageView]!
    @IBOutlet weak var txtIngredients: UITextView!
    @IBOutlet weak var txtDescriptionInstructions: UITextView!
    @IBOutlet weak var tblIngredients: UITableView!
    
    @IBAction func btnAddToShoppingList(_ sender: Any) {
        let alert = UIAlertController(title: "Add to shopping list?", message: "This action will add all ingredients in this recipe to your shopping list", preferredStyle: UIAlertController.Style.actionSheet)
        alert.addAction(UIAlertAction(title: "Add Items", style: UIAlertAction.Style.default, handler: {(_) in
            ShoppingListIngredient.addFromRecipe(recipeIngredients: self.allRecipeIngredients, on: self)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func btnReportCooked(_ sender: Any) {
        let alert = UIAlertController(title: "Confirm meal as cooked?", message: "This action will subtract the recipe ingregients from your pantry", preferredStyle: UIAlertController.Style.actionSheet)
        alert.addAction(UIAlertAction(title: "Confirm Cooked", style: UIAlertAction.Style.default, handler: {(_) in
            PantryIngredient.subtractRecipeIngredient(recipeIngredients: self.allRecipeIngredients, on: self)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
        
    }
    
   static var localRecipe : [RecipeStr] = []
    var allRecipeIngredients: [RecipeIngredient] = []
    override func viewDidLoad() {
        super.viewDidLoad()
            

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(true)
         RecipeDetailViewController.localRecipe = RecipeManager.getRecipe(theName: RecipeViewController.chosenRecipeName, all: false)
        if RecipeDetailViewController.localRecipe.count == 1 {
           
            self.navigationItem.title = RecipeDetailViewController.localRecipe[0].name
          //load table
            tblIngredients.reloadData()
            txtDescriptionInstructions.text = RecipeDetailViewController.localRecipe[0].recipeDescription + "\n" + RecipeDetailViewController.localRecipe[0].instructions
            if RecipeDetailViewController.localRecipe[0].thumbnail != nil {
                recipeImage.image = RecipeDetailViewController.localRecipe[0].thumbnail
            }
            setStars(numberOfStars: RecipeDetailViewController.localRecipe[0].rating)
            favourite = RecipeDetailViewController.localRecipe[0].favourite
            if favourite == true {
                btnFavouriteOutlet.setImage(UIImage(named:"heart-green"), for: .normal)
            }
            else{
                btnFavouriteOutlet.setImage(UIImage(named:"heart-green-outline"), for: .normal)
            }
            let dietaryOptions = RecipeManager.revertDietaryValue(value: RecipeDetailViewController.localRecipe[0].dietaryRequirements)
            for index in 0...2 {
                imgDietary[index].isHidden = !dietaryOptions[index]
            }
            lblPrep.text = "\(RecipeDetailViewController.localRecipe[0].prepTime)"
            lblCook.text = "\(RecipeDetailViewController.localRecipe[0].cookTime)"
            lblServings.text = "\(RecipeDetailViewController.localRecipe[0].servings)"
           /* if RecipeDetailViewController.localRecipe[0].mealPack != "" {
                btnEdit.isEnabled = false
            }
            else{
                btnEdit.isEnabled = true
            } */
            
            
        }
        else{
            let alertController = UIAlertController(title: "Recipe Error", message: "Could not retrieve meal information.", preferredStyle: UIAlertController.Style.alert)
                       alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                       self.present(alertController, animated: true, completion: nil)
            
            //Error message,
            //Return to previous view controller
        }
         allRecipeIngredients = RecipeManager.getRecipeObject(theName: RecipeViewController.chosenRecipeName)[0].contains?.array as! [RecipeIngredient]
    }
    func setFavourite(){
        if favourite == true {
                  favourite = false
                  btnFavouriteOutlet.setImage(UIImage(named: "heart-green-outline"), for: .normal)
                   //RecipeManager.updateRecipeFavourite(theName: RecipeDetailViewController.localRecipe[0].name, isFavourite: false)
            SuggestionGenerator.updatePoints(source: .favouriteOff, rating: 0, inpRecipe: RecipeDetailViewController.localRecipe[0])
                  //set as not favourite
              }
              else{
                  favourite = true
                  btnFavouriteOutlet.setImage(UIImage(named:"heart-green"), for: .normal)
             SuggestionGenerator.updatePoints(source: .favouriteOn, rating: 0, inpRecipe: RecipeDetailViewController.localRecipe[0])
            //RecipeManager.updateRecipeFavourite(theName: RecipeDetailViewController.localRecipe[0].name, isFavourite: true)
                  //set as favourite
              }
    }
    func setStars(numberOfStars : Int16){
       for index in 0..<Int(numberOfStars){
            btnStarsOutlet![index].setImage(UIImage(named:"star-green"), for: .normal)
        }
       for index in Int(numberOfStars)..<5{
            btnStarsOutlet![index].setImage(UIImage(named: "star-green-outline"), for: .normal)
        }
        if RecipeDetailViewController.localRecipe[0].rating != Int(numberOfStars){
            SuggestionGenerator.updatePoints(source: .rating, rating: Int(numberOfStars), inpRecipe: RecipeDetailViewController.localRecipe[0])
        }
       /* if RecipeManager.updateRecipeRating(theName: RecipeDetailViewController.localRecipe[0].name, theStars: numberOfStars) == false{
            let alertController = UIAlertController(title: "Rating error", message: "Attempted to rate non-existing recipe", preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        } */
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
extension RecipeDetailViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if RecipeDetailViewController.localRecipe.count > 0 {
             
            return RecipeDetailViewController.localRecipe[0].ingredients.count
        }
        else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblIngredients.dequeueReusableCell(withIdentifier: "tblCell") as! RecipeDetailIngredientsTable
        cell.txtName.text =  "\(RecipeDetailViewController.localRecipe[0].ingredients[indexPath.row].0)"
        if RecipeDetailViewController.localRecipe[0].ingredients[indexPath.row].3 == "U" {
            cell.txtAmount.text = "x\(RecipeDetailViewController.localRecipe[0].ingredients[indexPath.row].1)"
        }
        else{
                cell.txtAmount.text = "\(RecipeDetailViewController.localRecipe[0].ingredients[indexPath.row].1)g"
        }
    
        
        return cell
    }
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
}

