//
//  RecipeCollectionViewCollectionViewCell.swift
//  FoodDeck
//
//  Created by Luke Wood on 11/04/2020.
//  Copyright © 2020 computer science. All rights reserved.
//

import UIKit
protocol RecipeCollectionViewDelegate : class {
    func didTapRecipe(onCell : RecipeCollectionView)
}
class RecipeCollectionView: UICollectionViewCell {
    @IBAction func btnFavourite(_ sender: Any) {
        favourite = !favourite!
        if RecipeManager.updateRecipeFavourite(theName: txtRecipeName.text!, isFavourite: favourite!) == false{
        }
        if favourite! == true {
            btnFavouriteOut.setImage(UIImage(named:"heart-green"), for: .normal)
        }
        else{
            btnFavouriteOut.setImage(UIImage(named:"heart-green-outline"), for: .normal)
        }
    }
    
    var favourite : Bool?
    @IBOutlet weak var txtTime: UILabel!
    @IBOutlet weak var btnFavouriteOut: UIButton!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var txtRating: UILabel!
    @IBOutlet weak var txtRecipeName: UILabel!
    weak var recipeButtonDelegate : RecipeCollectionViewDelegate?
    @IBAction func btnMain(_ sender: Any) {
        recipeButtonDelegate?.didTapRecipe(onCell: self)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
