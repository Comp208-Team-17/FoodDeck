//
//  RecipeDetailIngredientsTable.swift
//  FoodDeck
//
//  Created by Luke Wood on 24/04/2020.
//  Copyright © 2020 computer science. All rights reserved.
//

import UIKit

class RecipeDetailIngredientsTable: UITableViewCell {

    @IBOutlet weak var txtName: UILabel!
    @IBOutlet weak var txtAmount: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
