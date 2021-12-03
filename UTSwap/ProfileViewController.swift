//
//  ProfileViewController.swift
//  UTSwap
//
//  Created by Jessica Trejo on 11/14/21.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import AVFoundation

class ProfileViewController: BaseViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    

    @IBOutlet weak var profilePic: UIImageView!
    
    @IBOutlet weak var accountEmail: UILabel!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var editProfileButton: UIButton!
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var deleteAccountButton: UIButton!
    @IBOutlet weak var uploadImageButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    
    let imagePicker = UIImagePickerController()
    
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imagePicker.delegate = self
        UILabel.appearance().font = UIFont(name: "Courier", size: 15.0)
        firstNameField.isEnabled = false
        lastNameField.isEnabled = false
        addressField.isEnabled = false
        passwordField.isEnabled = false
        uploadImageButton.isEnabled = false
        uploadImageButton.isHidden = true
        deleteAccountButton.setTitleColor(.red, for: .normal)
        
        
        firstNameField.placeholder = "Add a First Name"
        lastNameField.placeholder = "Add a Last Name"
        addressField.placeholder = "Enter a new address"
        passwordField.placeholder = "Enter new password"
        if (Auth.auth().currentUser != nil) {
            let user = Auth.auth().currentUser
            let storage = Storage.storage()
            let storageRef = storage.reference()
            
            ref = Database.database().reference()
            ref.child("users").child(user!.uid).observe(.value, with: { snapshot in
                // Get user value
                let value = snapshot.value as? NSDictionary
                let fname = value?["fname"] as? String ?? ""
                let lname = value?["lname"] as? String ?? ""
                let address = value?["address"] as? String ?? ""
                let userEmail = Auth.auth().currentUser?.email
                let profileRef = storageRef.child("profilepic").child(user!.uid).child("profilePic.jpg")
                
                
                self.addressLabel.text = address
                self.firstNameLabel.text = fname
                self.lastNameLabel.text = lname
                
                
                // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
                profileRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                  if let error = error {
                    self.imageView.image = UIImage(named: "default-profile-picture.png")
                  } else {
                    // Data for "images/island.jpg" is returned
                    let profImage = UIImage(data: data!)
                    self.imageView.image = profImage
                  }
                }
                
                if (fname == ""){
                    self.firstNameLabel.text = "No First Name Set"
                }
                if (lname == ""){
                    self.lastNameLabel.text = "No Last Name Set"
                }
                if (address == ""){
                    self.addressLabel.text = "No Address Set"
                }
                
                self.accountEmail.text = "\(userEmail ?? "not logged in")"

                // ...
              }) { error in
                print(error.localizedDescription)
              }
            }
        
        
        
    }
    
    @IBAction func editProfileInfo(_ sender: Any) {
        
        if(editProfileButton.titleLabel?.text == "Save Changes"){
            
            if (Auth.auth().currentUser != nil) {
                let user = Auth.auth().currentUser
                self.ref.child("users").child(user!.uid).setValue(["fname": self.firstNameField.text, "lname": self.lastNameField.text, "address": self.addressField.text])
                
                let storage = Storage.storage()
                let storageRef = storage.reference()
                let imgUUID = UUID.init().uuidString
                let userUid = Auth.auth().currentUser?.uid
                if imageView.image != nil {
                    
                    // inspired from firebase documentation
                    // https://firebase.google.com/docs/storage/ios/upload-files
                    
                    let imgData = imageView.image?.jpegData(compressionQuality: 0.75)
                    // Create a reference to the file you want to upload
                    let imgRef = storageRef.child("profilepic").child(user!.uid).child("profilePic.jpg")
                    
                    let metadata = StorageMetadata()
                    metadata.contentType = "profilepic/jpeg"
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
            }
            editProfileButton.setTitle("Update Credentials & Profile Picture", for: .normal)
            firstNameField.isEnabled = false
            lastNameField.isEnabled = false
            addressField.isEnabled = false
            passwordField.isEnabled = false
            uploadImageButton.isHidden = true
            uploadImageButton.isEnabled = false
            deleteAccountButton.isHidden = false
            signOutButton.isHidden = false
            
        }else{
            firstNameField.isEnabled = true
            lastNameField.isEnabled = true
            addressField.isEnabled = true
            passwordField.isEnabled = true
            uploadImageButton.isHidden = false
            uploadImageButton.isEnabled = true
            editProfileButton.setTitle("Save Changes", for: .normal)
            
            deleteAccountButton.isHidden = true
            signOutButton.isHidden = true
        }
        
        
        
    }
    
    
    @IBAction func tapImageUpload(_ sender: Any) {
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
        self.uploadImageButton.alpha = 0.010001
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.showSettingsButton(show: false)
    }
    

   
}
