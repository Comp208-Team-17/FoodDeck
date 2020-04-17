//
//  RecipeIngredientsTable.swift
//  FoodDeck
//
//  Created by Luke Wood on 14/04/2020.
//  Copyright © 2020 computer science. All rights reserved.
//

import UIKit
protocol RecipeIngredientTableDelegate : AnyObject {
    func didTapInclude(sender: Any)
    func didTapOptional(sender : Any)
}
class RecipeIngredientsTable: UITableViewCell {
    @IBOutlet weak var txtName: UILabel!
    @IBOutlet weak var txtEnabled: UILabel!
    @IBOutlet weak var txtIncluded: UILabel!
    @IBOutlet weak var txtOptional: UILabel!
    @IBOutlet weak var btnInclude: UIButton!
    @IBOutlet weak var btnOptional: UIButton!
    @IBAction func btnIncludeAction(_ sender: Any) {
        if btnInclude.titleLabel!.text == "Include"{
            btnInclude.setTitle("Exclude", for: .normal)
        }
        else{
            btnInclude.setTitle("Include", for: .normal)
        }
        buttonDelegate?.didTapInclude(sender: self)
    }
    @IBAction func btnOptionAction(_ sender: Any) {
        buttonDelegate?.didTapOptional(sender: self)
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
