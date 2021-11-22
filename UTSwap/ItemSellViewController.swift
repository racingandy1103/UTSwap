//
//  ItemSellViewController.swift
//  UTSwap
//
//  Created by Peggy Chiang on 11/14/21.
//

import UIKit
import Firebase
import FirebaseDatabase

class ItemSellViewController: BaseViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate, {
    
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!

    var pickerData: [String] = [String]()
    var location = ""
    
    let datePicker = UIDatePicker()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createDatePicker()
        
        self.textView.layer.borderColor = UIColor.lightGray.cgColor
        self.textView.layer.borderWidth = 1
        
        self.picker.delegate = self
        self.picker.dataSource = self
        pickerData = ["GDC", "Littlefield Fountain", "Union", "Speedway", "PCL", "UT Tower"]
        
        textField.attributedPlaceholder = NSAttributedString(
            string: "Date & Time",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
        
        priceTextField.attributedPlaceholder = NSAttributedString(
            string: "Price",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
        
        titleTextField.attributedPlaceholder = NSAttributedString(
            string: "Title",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
        
        textView.text = "Enter your description here..."
        textView.textColor = UIColor.lightGray
        
        textView.delegate = self
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter your description here..."
            textView.textColor = UIColor.lightGray
        }
    }
    

    @IBAction func onSaveItemPress(_ sender: Any) {
        if (Auth.auth().currentUser != nil) {
            let user = Auth.auth().currentUser
            print("reading items from db")
            ref = Database.database().reference()
            ref.child("items").child(user!.uid).childByAutoId().setValue(["itemTitle": titleField.text!, "itemPrice": priceField.text!,"meetLocation":location, "itemDesc": itemDesc.text!, "meetTime": datepicker.date.timeIntervalSince1970])
            
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
    
    func createDatePicker() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneButton], animated: true)
        
        textField.inputAccessoryView = toolbar
        
        textField.inputView = datePicker
        
        datePicker.datePickerMode = .dateAndTime
        datePicker.preferredDatePickerStyle = .wheels
    }
    
    @objc func donePressed(){
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        
        textField.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
}
