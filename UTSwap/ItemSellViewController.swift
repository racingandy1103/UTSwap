//
//  ItemSellViewController.swift
//  UTSwap
//
//  Created by Peggy Chiang on 11/14/21.
//

import UIKit
import Firebase
import FirebaseDatabase
import AVFoundation

class ItemSellViewController: BaseViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    
    var pickerData: [String] = [String]()
    var location = ""
    let imagePicker = UIImagePickerController()
    let datePicker = UIDatePicker()
    
    // for DB
    var ref: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.textView.layer.borderColor = UIColor.lightGray.cgColor
        self.textView.layer.borderWidth = 1
        
        self.picker.delegate = self
        self.picker.dataSource = self
        pickerData = ["GDC", "Littlefield Fountain", "Union", "Speedway", "Jester"]
        
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
        
        createDatePicker()
        
        imagePicker.delegate = self
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 1.5
        imageView.layer.borderColor = UIColor.lightGray.cgColor
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
            ref.child("items").child(user!.uid).childByAutoId().setValue(["itemTitle": titleTextField.text!, "itemPrice": priceTextField.text!,"meetLocation":location, "itemDesc": textView.text!, "meetTime": textField.text!])
            
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
    
    @IBAction func uploadImage(_ sender: Any) {
        
        let controller = UIAlertController( // Alert message
            title: "Upload Image",
            message: "Choose a method",
            preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(
            title: "Cancel",
            style: .cancel,
            handler: nil)
        controller.addAction(cancelAction)
        let OKAction = UIAlertAction(
            title: "Photo Library",
            style: .default,
            handler: {action in
                self.imagePicker.allowsEditing = false
                self.imagePicker.sourceType = .photoLibrary
                self.present(self.imagePicker, animated: true, completion: nil)
            })
        controller.addAction(OKAction)
        let destroyAction = UIAlertAction(
            title: "Camera",
            style: .default,
            handler: {action in
                if UIImagePickerController.availableCaptureModes(for: .rear) != nil {
                    switch AVCaptureDevice.authorizationStatus(for: .video) {
                    case .notDetermined:
                        AVCaptureDevice.requestAccess(for: .video) {
                            accessGranted in
                            guard accessGranted == true else { return }
                        }
                    case .authorized:
                        break
                    default:
                        print("Access denied")
                        return
                    }
                    
                    self.imagePicker.allowsEditing = false
                    self.imagePicker.sourceType = .camera
                    self.imagePicker.cameraCaptureMode = .photo
                    
                    self.present(self.imagePicker, animated: true, completion: nil)
                
                } else {
                    
                    let alertVC = UIAlertController(
                        title: "No camera",
                        message: "Buy a better phone",
                        preferredStyle: .alert)
                    let okAction = UIAlertAction(
                        title: "OK",
                        style: .default,
                        handler: nil)
                    alertVC.addAction(okAction)
                    self.present(alertVC, animated: true, completion: nil)
                    
                }

            })
        controller.addAction(destroyAction)
        present(controller, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        let chosenImage = info[.originalImage] as! UIImage
        imageView.contentMode = .scaleAspectFit
        imageView.image = chosenImage
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}
