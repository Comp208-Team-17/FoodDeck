//
//  AddToIngredientsViewController.swift
//  FoodDeck
//
//  Created by Luke Wood on 08/04/2020.
//  Copyright © 2020 computer science. All rights reserved.
//

import UIKit

class AddToIngredientsViewController: UIViewController{
    var tempIngredient : [IngredientStr] = []
    var selectedUnitType : Int = 0
    static var selectedRowTxt : String = ""
    static var selectedEdit : Bool = false
    static var selectedEditPage: Bool = false
    let rowText : [String] = ["Grams", "Number of items"]
    var ingredientsList : [IngredientStr] = []
    @IBOutlet weak var unitSelect: UIPickerView!
    @IBOutlet weak var txtIngredient: UITextField!
    @IBOutlet weak var tblIngredients: UITableView!
    @IBAction func btnSave(_ sender: Any) {
        //Go back to previous page.
        if AddToIngredientsViewController.selectedEditPage == true {
            AddToIngredientsViewController.selectedEditPage = false
            if IngredientManager.updateIngredient(originalName: AddToIngredientsViewController.selectedRowTxt, isEnabled: tempIngredient.count == 1 ? tempIngredient[0].enabled : true, theName: txtIngredient.text!, theUnit: selectedUnitType == 0 ? "G" : "U") == true{
                navigationController?.popViewController(animated: true)
            }
            else{
                     let alertController = UIAlertController(title: "Ingredient Error", message: "You cannot change this ingredient to the name of an ingredient that already exists. Please try again", preferredStyle: UIAlertController.Style.alert)
                       alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                       self.present(alertController, animated: true, completion: nil)
            }
            
        }
        else if IngredientManager.addIngredient(isEnabled: true, theName: txtIngredient.text!, theUnit: selectedUnitType == 0 ? "G" :"U"){
                navigationController?.popViewController(animated: true)
           
        }
        else{
            let alertController = UIAlertController(title: "Ingredient Error", message: "Ingredient already exists, please try again.", preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated : Bool){
       
        super.viewDidAppear(animated)
        tblIngredients?.reloadData()
        if AddToIngredientsViewController.selectedEdit == true{
            AddToIngredientsViewController.selectedEdit = false
            tempIngredient = IngredientManager.getIngredient(theName: AddToIngredientsViewController.selectedRowTxt, enabled: false, all: false)
            txtIngredient.text = tempIngredient[0].name
            selectedUnitType = tempIngredient[0].unit == "G" ? 0 : 1
            unitSelect.selectRow(selectedUnitType, inComponent: 0, animated: true)
            AddToIngredientsViewController.selectedEditPage = true
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
extension AddToIngredientsViewController :  UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return rowText.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return rowText[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       selectedUnitType = row
    }
    
}

extension AddToIngredientsViewController : UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         ingredientsList = IngredientManager.getIngredient(theName: "", enabled: false, all: true)
        return ingredientsList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblIngredients.dequeueReusableCell(withIdentifier: "IngredientsTblCell") as! IngredientTable
        
        cell.txtIngredientName.text = "\(ingredientsList[indexPath.row].name)"
        cell.txtEnabled.text = ingredientsList[indexPath.row].enabled == true ? "Enabled" : "Disabled"
        cell.txtUnit.text = ingredientsList[indexPath.row].unit == "G" ? "Grams" : "#items"
        cell.deleteButtonDelegate = self
        cell.editButtonDelegate = self
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
        
}
extension AddToIngredientsViewController : IngredientTableDelegate{
    func didTapDeleteButton(onCell : IngredientTable) {
        tblIngredients?.reloadData()
    }
    func didTapEditButton(onCell: IngredientTable) {
        AddToIngredientsViewController.selectedRowTxt = onCell.txtIngredientName.text!
        AddToIngredientsViewController.selectedEdit = true
        performSegue(withIdentifier: "toAddEditIngredient", sender: nil)
    }
}
