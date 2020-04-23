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
    func didTapDeleteButton(sender : RecipeIngredientsTable)
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
        if optional == true {
            optional = false
            btnOptional.setTitle("Make Optional", for: .normal)
            txtOptional.isHidden = true
        }
        else{
            optional = true
            btnOptional.setTitle("Make Mandatory", for: .normal)
            txtOptional.isHidden = false
        }
        buttonDelegate?.didTapOptional(sender: self, optional: optional)
    }
    @IBAction func btnDelete(_ sender: Any) {
        buttonDelegate?.didTapDeleteButton(sender: self)
    }
    weak var buttonDelegate : RecipeIngredientTableDelegate?
    var optional : Bool = false
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if txtOptional.isHidden == false {
            optional = true
            btnOptional.setTitle("Make Mandatory", for: .normal)
        }
        //check if amount should be visible and make optional button should be visible.
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
