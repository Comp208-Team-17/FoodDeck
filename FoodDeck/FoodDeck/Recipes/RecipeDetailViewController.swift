//
//  RecipeDetailViewController.swift
//  FoodDeck
//
//  Created by Luke Wood on 13/04/2020.
//  Copyright © 2020 computer science. All rights reserved.
//

import UIKit

class RecipeDetailViewController: UIViewController {

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
    
    @IBAction func btnAddToShoppingList(_ sender: Any) {
        ShoppingListIngredient.addFromRecipe(recipeIngredients: allRecipeIngredients, on: self)
    }
    
    @IBAction func btnReportCooked(_ sender: Any) {
        PantryIngredient.subtractRecipeIngredient(recipeIngredients: allRecipeIngredients, on: self)
        
    }
    
   static var localRecipe : [RecipeStr] = []
    var allRecipeIngredients: [RecipeIngredient] = []
    override func viewDidLoad() {
        super.viewDidLoad()
            RecipeDetailViewController.localRecipe = RecipeManager.getRecipe(theName: RecipeViewController.chosenRecipeName, all: false)
         allRecipeIngredients = RecipeManager.getRecipeObject(theName: RecipeViewController.chosenRecipeName)[0].contains?.array as! [RecipeIngredient]
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(true)
        var tempIngredients : String = ""
        
    
        if RecipeDetailViewController.localRecipe.count == 1 {
            self.navigationItem.title = RecipeDetailViewController.localRecipe[0].name
             /*
            for index in 0..<RecipeDetailViewController.localRecipe[0].ingredients.count{
                tempIngredients += "\(RecipeDetailViewController.localRecipe[0].ingredients[index].1)"
                if RecipeDetailViewController.localRecipe[0].ingredients[index].3 == "U" {
                    tempIngredients += "Units of"
                    
                }
                else{
                    tempIngredients += "Grams of"
                }
                tempIngredients += "\(RecipeDetailViewController.localRecipe[0].ingredients[index].0) \n"
            } */
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
                imgDietary[index].isHidden = dietaryOptions[index]
            }
            
        }
        else{
            let alertController = UIAlertController(title: "Recipe Error", message: "Could not retrieve meal information.", preferredStyle: UIAlertController.Style.alert)
                       alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                       self.present(alertController, animated: true, completion: nil)
            
            //Error message,
            //Return to previous view controller
        }
    }
    func setFavourite(){
        if favourite == true {
                  favourite = false
                  btnFavouriteOutlet.setImage(UIImage(named: "heart-green-outline"), for: .normal)
                   RecipeManager.updateRecipeFavourite(theName: RecipeDetailViewController.localRecipe[0].name, isFavourite: false)
                  //set as not favourite
              }
              else{
                  favourite = true
                  btnFavouriteOutlet.setImage(UIImage(named:"heart-green"), for: .normal)
            RecipeManager.updateRecipeFavourite(theName: RecipeDetailViewController.localRecipe[0].name, isFavourite: true)
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
        if RecipeManager.updateRecipeRating(theName: RecipeDetailViewController.localRecipe[0].name, theStars: numberOfStars) == false{
            let alertController = UIAlertController(title: "Rating error", message: "Attempted to rate non-existing recipe", preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
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

