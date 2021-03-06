//
//  ItemSellViewController.swift
//  UTSwap
//
//  Created by Peggy Chiang on 11/14/21.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import AVFoundation

class ItemSellViewController: BaseViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var uploadimgButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var locationButton: UIButton!
    
    var pickerData: [String] = [String]()
    var category = "Furniture"
    let imagePicker = UIImagePickerController()
    let datePicker = UIDatePicker()
    var location = ""
    
    // for DB
    var ref: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.textView.layer.borderColor = UIColor.orange.cgColor
        self.textView.layer.borderWidth = 1
        
        self.picker.delegate = self
        self.picker.dataSource = self
        pickerData = ["Furniture", "Clothing", "Electronics", "Book", "Misc."]

        textField.layer.borderColor = UIColor.orange.cgColor
        textField.layer.borderWidth = 1.0
        textField.font = UIFont(name:"Courier",size:15)
        textField.attributedPlaceholder = NSAttributedString(
            string: "Date & Time",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray, NSAttributedString.Key.font: UIFont(name:"Courier",size:15)]
        )
        
        priceTextField.layer.borderColor = UIColor.orange.cgColor
        priceTextField.layer.borderWidth = 1.0
        priceTextField.font = UIFont(name:"Courier",size:15)
        priceTextField.attributedPlaceholder = NSAttributedString(
            string: "Price",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray, NSAttributedString.Key.font: UIFont(name:"Courier",size:15)]
        )
        
        titleTextField.layer.borderColor = UIColor.orange.cgColor
        titleTextField.layer.borderWidth = 1.0
        titleTextField.font = UIFont(name:"Courier",size:15)
        titleTextField.attributedPlaceholder = NSAttributedString(
            string: "Title",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray, NSAttributedString.Key.font: UIFont(name:"Courier",size:15)]
        )
                
        textView.text = "Enter your description here..."
        textView.font = UIFont(name:"Courier",size:15)
        textView.textColor = UIColor.lightGray
        textView.delegate = self
        
        createDatePicker()
        
        imagePicker.delegate = self
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 1.5
        imageView.layer.borderColor = UIColor.orange.cgColor
        
        /*if categories.contains(categoryTextField.text!) == false {
            categories.append(categoryTextField.text!)
        }*/
    }

    // Setting textView default color
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = ""
            if UserDefaults.standard.bool(forKey: "darkModeOn") == true {
                textView.textColor = UIColor.white
            } else {
                textView.textColor = UIColor.black
            }
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter your description here..."
            textView.textColor = UIColor.lightGray
            textView.font = UIFont(name:"Courier",size:15)
        }
    }
    
    // Saves item info into database
    @IBAction func onSaveItemPress(_ sender: Any) {
        if (Auth.auth().currentUser != nil) {
            let user = Auth.auth().currentUser
            print("onSaveItemPress - reading items from db")
            
            let storage = Storage.storage()
            let storageRef = storage.reference()
            let imgUUID = UUID.init().uuidString
            if imageView.image != nil {
                
                // inspired from firebase documentation
                // https://firebase.google.com/docs/storage/ios/upload-files
                
                let imgData = imageView.image?.jpegData(compressionQuality: 0.75)
                // Create a reference to the file you want to upload
                let imgRef = storageRef.child("itemimages").child("\(imgUUID).jpg")
                
                let metadata = StorageMetadata()
                metadata.contentType = "image/jpeg"
                // Upload the file to the path "images/{userId}/{imgUUID}.png"
                let uploadTask = imgRef.putData(imgData!, metadata: metadata) { (metadata, error) in
                  guard let metadata = metadata else {
                    // Uh-oh, an error occurred!
                    print(error)
                    return
                  }
                  // Metadata contains file metadata such as size, content-type.
                  let size = metadata.size
                  // You can also access to download URL after upload.
                    imgRef.downloadURL { (url, error) in
                    guard let downloadURL = url else {
                      // Uh-oh, an error occurred!
                      return
                    }
                  }
                }
            }
           
            ref = Database.database().reference()            
            
            var dataToAdd = ["itemTitle": titleTextField.text!, "itemPrice": priceTextField.text!,"meetLocation": location, "itemDesc": textView.text!, "meetTime": textField.text!, "itemCategory": category]

            if imageView.image != nil {
                dataToAdd["itemImgUUID"] = imgUUID
            }

            ref.child("items").child(user!.uid).childByAutoId().setValue(dataToAdd)
            _ = navigationController?.popViewController(animated: true)
            

        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Creating location picker options
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label = UILabel()
        if let v = view as? UILabel { label = v }
        label.font = UIFont (name: "Courier", size: 15)
        label.text =  pickerData[row]
        label.textAlignment = .center
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        category = pickerData[row] // saves location
        print(category)
    }
    
    // Creating date & time picker options
    func createDatePicker() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.backgroundColor = .white
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneButton], animated: true)
        doneButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name:"Courier",size:15)], for: .normal)
        doneButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name:"Courier",size:15)], for: .highlighted)
        
        textField.inputAccessoryView = toolbar
        datePicker.datePickerMode = .dateAndTime
        datePicker.frame.size = CGSize(width: 0, height: 100)
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(sender:)), for: .valueChanged)
        textField.inputView = datePicker
        if #available(iOS 14.0, *) {
            datePicker.preferredDatePickerStyle = .compact
            datePicker.backgroundColor = .white
        } else {
            // Fallback on earlier versions
        }
    }
    @objc func datePickerValueChanged(sender: UIDatePicker){
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        textField.text = formatter.string(from: sender.date)
    }
    @objc func donePressed(){
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        textField.text = formatter.string(from: datePicker.date)
        textField.font = UIFont(name:"Courier",size:15)
        self.view.endEditing(true)
    }
    
    // To upload image with options of photo library and camera
    @IBAction func uploadImage(_ sender: Any) {
        
        let controller = UIAlertController(
            title: "Upload Image",
            message: "Choose a method",
            preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(
            title: "Cancel",
            style: .cancel,
            handler: nil)
        controller.addAction(cancelAction)
        let photoLibAction = UIAlertAction( // Set image from photo library
            title: "Photo Library",
            style: .default,
            handler: {action in
                self.imagePicker.allowsEditing = false
                self.imagePicker.sourceType = .photoLibrary
                self.present(self.imagePicker, animated: true, completion: nil)
            })
        controller.addAction(photoLibAction)
        let cameraAction = UIAlertAction( // Set image from camera
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
        controller.addAction(cameraAction)
        present(controller, animated: true, completion: nil)
    }
    
    // Set image to image chosen from photo library
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        let chosenImage = info[.originalImage] as! UIImage
        imageView.contentMode = .scaleAspectFit
        imageView.image = chosenImage
        self.uploadimgButton.alpha = 0.010001
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func locationPick(_ sender: Any) {
        let controller = UIAlertController( // Alert message
            title: "Location Picker",
            message: "Select your desired location",
            preferredStyle: .alert)
        controller.addAction(UIAlertAction(
                                title: "GDC",
                                style: .default,
                                handler: {action in
                                    self.location = "GDC"
                                    self.locationButton.setTitle("GDC", for: .normal)
                                }))
        controller.addAction(UIAlertAction(
                                title: "Speedway",
                                style: .default,
                                handler: {action in
                                    self.location = "Speedway"
                                    self.locationButton.setTitle("Speedway", for: .normal)
                                }))
        controller.addAction(UIAlertAction(
                                title: "Jester",
                                style: .default,
                                handler: {action in
                                    self.location = "Jester"
                                    self.locationButton.setTitle("Jester", for: .normal)
                                }))
        controller.addAction(UIAlertAction(
                                title: "Union",
                                style: .default,
                                handler: {action in
                                    self.location = "Union"
                                    self.locationButton.setTitle("Union", for: .normal)
                                }))
        controller.addAction(UIAlertAction(
                                title: "Cancel",
                                style: .cancel,
                                handler: nil))
        present(controller, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(textField:UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
