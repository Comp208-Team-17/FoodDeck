//
//  RecipeIngredientsTable.swift
//  FoodDeck
//
//  Created by Luke Wood on 14/04/2020.
//  Copyright © 2020 computer science. All rights reserved.
//

import UIKit
protocol RecipeIngredientTableDelegate : AnyObject {
    func didTapOptional(sender : RecipeIngredientsTable, optional: Bool)
}
class RecipeIngredientsTable: UITableViewCell {

    @IBOutlet weak var txtUnit: UILabel!
    @IBOutlet weak var txtAmount: UILabel!
    @IBOutlet weak var txtName: UILabel!
    @IBOutlet weak var txtEnabled: UILabel!
    @IBOutlet weak var txtIncluded: UILabel!
    @IBOutlet weak var txtOptional: UILabel!
    @IBOutlet weak var btnOptional: UIButton!
    @IBAction func btnOptionAction(_ sender: Any) {
        buttonDelegate?.didTapOptional(sender: self, optional: true)
    }
    weak var buttonDelegate : RecipeIngredientTableDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //check if amount should be visible and make optional button should be visible.
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
