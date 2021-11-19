//
//  ItemSellViewController.swift
//  UTSwap
//
//  Created by Peggy Chiang on 11/14/21.
//

import UIKit
import Firebase
import FirebaseDatabase

class ItemSellViewController: BaseViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var datepicker: UIDatePicker!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var priceField: UITextField!
    
    var pickerData: [String] = [String]()
    var location = ""
    
    // for DB
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.picker.delegate = self
        self.picker.dataSource = self
        pickerData = ["GDC", "Littlefield Fountain", "Union", "Loc 4", "Loc 5", "Loc 6"]
    }
    
    
    @IBAction func onSavePressed(_ sender: Any) {
        if (Auth.auth().currentUser != nil) {
            let user = Auth.auth().currentUser
            print("reading items from db")
            ref = Database.database().reference()
            ref.child("items").child(user!.uid).childByAutoId().setValue(["itemTitle": titleField.text!, "itemPrice": priceField.text!,"meetLocation":location])
            
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // This method is triggered whenever the user makes a change to the picker selection.
        // The parameter named row and component represents what was selected.
        location = pickerData[row] // saves location
        print(location)
    }
}
