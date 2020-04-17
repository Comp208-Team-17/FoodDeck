//
//  RecipeDetailViewController.swift
//  FoodDeck
//
//  Created by Luke Wood on 13/04/2020.
//  Copyright © 2020 computer science. All rights reserved.
//

import UIKit

class RecipeDetailViewController: UIViewController {

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
    @IBOutlet var btnStarsOutlet: [UIButton]!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var txtName: UILabel!
    @IBOutlet weak var txtDietary: UILabel!
    @IBOutlet weak var txtIngredients: UITextView!
    @IBOutlet weak var txtDescriptionInstructions: UITextView!
   static var localRecipe : [RecipeStr] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(true)
        var tempIngredients : String = ""
        
        RecipeDetailViewController.localRecipe = RecipeManager.getRecipe(theName: RecipeViewController.chosenRecipeName, all: false)
        if RecipeDetailViewController.localRecipe.count == 1 {
            txtName.text = RecipeDetailViewController.localRecipe[0].name
            if RecipeDetailViewController.localRecipe[0].dietaryRequirements == "000" {
                txtDietary.text = ""
            }
            else if RecipeDetailViewController.localRecipe[0].dietaryRequirements == "001"{
                txtDietary.text = "GF"
            }
            else if RecipeDetailViewController.localRecipe[0].dietaryRequirements == "010"{
                txtDietary.text = "V"
            }
            else if RecipeDetailViewController.localRecipe[0].dietaryRequirements == "011"{
                txtDietary.text = "V\nGF"
            }
            else if RecipeDetailViewController.localRecipe[0].dietaryRequirements == "100"{
                txtDietary.text = "VG"
            }
            else if RecipeDetailViewController.localRecipe[0].dietaryRequirements == "101"{
                txtDietary.text = "VG\nGF"
            }
            else if RecipeDetailViewController.localRecipe[0].dietaryRequirements == "110"{
                txtDietary.text = "VG\nV"
            }
            else if RecipeDetailViewController.localRecipe[0].dietaryRequirements == "111"{
                txtDietary.text = "VG\nV\nGF"
            }
            for index in 0..<RecipeDetailViewController.localRecipe[0].ingredients.count{
                tempIngredients += "\(RecipeDetailViewController.localRecipe[0].ingredients[index].1)"
                if RecipeDetailViewController.localRecipe[0].ingredients[index].3 == "U" {
                    tempIngredients += "Units of"
                    
                }
                else{
                    tempIngredients += "Grams of"
                }
                tempIngredients += "\(RecipeDetailViewController.localRecipe[0].ingredients[index].0) \n"
            }
            txtDescriptionInstructions.text = RecipeDetailViewController.localRecipe[0].recipeDescription + "\n" + RecipeDetailViewController.localRecipe[0].instructions
            if RecipeDetailViewController.localRecipe[0].thumbnail != nil {
                recipeImage.image = RecipeDetailViewController.localRecipe[0].thumbnail
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
    func setStars(numberOfStars : Int){
        for index in 0..<numberOfStars{
            btnStarsOutlet[index].imageView!.image = UIImage(named: "FilledStar.png")
        }
        for index in numberOfStars..<5{
            btnStarsOutlet[index].imageView!.image = UIImage(named: "EmptyStar.png")
        }
        if RecipeManager.updateRecpeStars(theName: txtName.text!, theStars: numberOfStars) == false{
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
