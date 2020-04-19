//
//  RecipeCollectionViewCollectionViewCell.swift
//  FoodDeck
//
//  Created by Luke Wood on 11/04/2020.
//  Copyright © 2020 computer science. All rights reserved.
//

import UIKit
protocol RecipeCollectionViewDelegate : AnyObject {
    func didTapRecipe(onCell : RecipeCollectionView)
}
class RecipeCollectionView: UICollectionViewCell {
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var txtRating: UILabel!
    @IBOutlet weak var txtRecipeName: UILabel!
    weak var recipeButtonDelegate : RecipeCollectionViewDelegate?
    @IBAction func btnMain(_ sender: Any) {
        recipeButtonDelegate?.didTapRecipe(onCell: self)
    }
    
}
