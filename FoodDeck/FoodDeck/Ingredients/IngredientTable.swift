//
//  IngredientTable.swift
//  FoodDeck
//
//  Created by Luke Wood on 08/04/2020.
//  Copyright © 2020 computer science. All rights reserved.
//

import UIKit

protocol IngredientTableDelegate : AnyObject {
    func didTapDeleteButton(onCell : IngredientTable)
    func didTapEditButton(onCell : IngredientTable)
}
class IngredientTable: UITableViewCell {
    var tempIngredient : [IngredientStr] = []
    var enabledButton : Bool = false
    @IBOutlet weak var btnDeleteOutlet: UIButton!
    @IBOutlet weak var btnEditOutlet : UIButton!
    @IBOutlet weak var btnDisableOutlet: UIButton!
    @IBAction func btnDisable(_ sender: Any) {
        
        if enabledButton == false {
            btnDisableOutlet.setTitle("Enable", for: .normal)
            enabledButton = true
            IngredientManager.updateIngredient(originalName: tempIngredient[0].name, isEnabled: false, theName: tempIngredient[0].name, theUnit: tempIngredient[0].unit)
        }
        else{
            btnDisableOutlet.setTitle("Disable", for: .normal)
            enabledButton = false
               IngredientManager.updateIngredient(originalName: tempIngredient[0].name, isEnabled: true, theName: tempIngredient[0].name, theUnit: tempIngredient[0].unit)
        }
        deleteButtonDelegate?.didTapDeleteButton(onCell: self)
    }
    weak var deleteButtonDelegate : IngredientTableDelegate?
    weak var editButtonDelegate : IngredientTableDelegate?
    var ingredientsList : [IngredientStr] = []
    @IBAction func btnEdit(_ sender: Any) {
        editButtonDelegate?.didTapEditButton(onCell: self)
    }
    @IBAction func btnDelete(_ sender: Any) {
        IngredientManager.deleteIngredient(theName: txtIngredientName.text!)
        deleteButtonDelegate?.didTapDeleteButton(onCell: self)
        
    }
    @IBOutlet weak var txtUnit: UILabel!
    @IBOutlet weak var txtEnabled: UILabel!
    @IBOutlet weak var txtIngredientName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        tempIngredient = IngredientManager.getIngredient(theName: txtIngredientName.text!, enabled: false, all: false)
        if tempIngredient.count > 0{
            if tempIngredient[0].enabled == false {
                       btnDisableOutlet.setTitle("Enable", for: .normal)
                       enabledButton = true
            }
        }
       
    }

}
 
