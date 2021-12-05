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
    @IBOutlet weak var taptoUpload: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var accountEmail: UILabel!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
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
        usernameLabel.font = UIFont(name: "Courier", size: 23.0)
        taptoUpload.isHidden = true
        firstNameField.isEnabled = false
        lastNameField.isEnabled = false
        addressField.isEnabled = false
        
        uploadImageButton.isEnabled = false
        uploadImageButton.isHidden = true
        uploadImageButton.titleEdgeInsets = UIEdgeInsets(top: 30.0, left: 0, bottom: 0, right: 0)
        deleteAccountButton.setTitleColor(.red, for: .normal)
        
        
        
        firstNameField.placeholder = "Add a First Name"
        lastNameField.placeholder = "Add a Last Name"
        addressField.placeholder = "Enter a new address"
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
                let profileRef = storage.reference(withPath: "profilepic/\(user!.uid)/profilePic.jpg")
                let username = Auth.auth().currentUser?.displayName
                print(username)
                print("signal is here")
                
                self.addressLabel.text = address
                self.firstNameLabel.text = fname
                self.lastNameLabel.text = lname
                self.usernameLabel.text = username
                
                if(lname != ""){
                    self.lastNameField.text = lname
                }
                if(fname != ""){
                    self.firstNameField.text = fname
                }
                if(address != ""){
                    self.addressField.text = address
                }
                
                // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    print("Async after 1 second")
                    profileRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
                        if error != nil {
                            self.imageView.image = UIImage(named: "default-profile-picture")
                        } else {
                            self.imageView.image = UIImage(data: data!)
                        }
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
            uploadImageButton.isHidden = true
            uploadImageButton.isEnabled = false
            deleteAccountButton.isHidden = false
            signOutButton.isHidden = false
            taptoUpload.isHidden = true
            
        }else{
            firstNameField.isEnabled = true
            lastNameField.isEnabled = true
            addressField.isEnabled = true
            uploadImageButton.isHidden = false
            uploadImageButton.isEnabled = true
            editProfileButton.setTitle("Save Changes", for: .normal)
            
            deleteAccountButton.isHidden = true
            signOutButton.isHidden = true
            taptoUpload.isHidden = false
        }
        
        
        
    }
    
    
    @IBAction func tapSignOut(_ sender: Any) {
        
        let controller = UIAlertController(
            title: "Sign Out",
            message: "Are you sure you want to sign out of this account?",
            preferredStyle: .alert)
        controller.addAction(UIAlertAction(
                                title: "Cancel",
                                style: .cancel,
                                handler: nil))
        controller.addAction(UIAlertAction(
                                title: "Sign Out",
                                style: .default,
                                handler:{(action) in self.signOut()} ))
        present(controller, animated: true, completion: nil)
        
    }
    
    @IBAction func TapdeleteAccount(_ sender: Any) {
        
        let controller = UIAlertController(
            title: "Warning",
            message: "Are you sure you want to delete this account? This action cannot be reversed.",
            preferredStyle: .alert)
        controller.addAction(UIAlertAction(
                                title: "Cancel",
                                style: .cancel,
                                handler: nil))
        controller.addAction(UIAlertAction(
                                title: "Delete Account",
                                style: .destructive,
                                handler:{(action) in self.deleteAccount()} ))
        present(controller, animated: true, completion: nil)
        
        
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
    
    func signOut(){
        do
            {
                try Auth.auth().signOut()
                _ = navigationController?.popToRootViewController(animated: true)
                
            }
            catch let error as NSError
            {
                print("bye woeld")
                print(error.localizedDescription)
            }
    }
    
    func deleteAccount(){
        let user = Auth.auth().currentUser

        user?.delete { error in
          if let error = error {
            
            print("Error in deleting account")
            // An error happened.
          } else {
            // Account deleted.
            print("Account deleted")
            _ = self.navigationController?.popToRootViewController(animated: true)
          }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.showSettingsButton(show: false)
    }
    

   
}
