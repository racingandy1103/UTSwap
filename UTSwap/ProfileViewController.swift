//
//  ProfileViewController.swift
//  UTSwap
//
//  Created by Jessica Trejo on 11/14/21.
//

import UIKit
import Firebase
import FirebaseDatabase

class ProfileViewController: BaseViewController {
    
    var ref: DatabaseReference!

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
    
    @IBOutlet weak var deleteAccountButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        UILabel.appearance().font = UIFont(name: "Courier", size: 15.0)
        firstNameField.isEnabled = false
        lastNameField.isEnabled = false
        addressField.isEnabled = false
        passwordField.isEnabled = false
        
        
        firstNameField.placeholder = "Enter New Name"
        lastNameField.placeholder = "Enter New Name"
        addressField.placeholder = "Enter new address"
        passwordField.placeholder = "Enter new password"
        if (Auth.auth().currentUser != nil) {
            let user = Auth.auth().currentUser

            ref = Database.database().reference()
            ref.child("users").child(user!.uid).observe(.value, with: { snapshot in
                // Get user value
                let value = snapshot.value as? NSDictionary
                let fname = value?["fname"] as? String ?? ""
                let lname = value?["lname"] as? String ?? ""
                let address = value?["address"] as? String ?? ""
                let userEmail = Auth.auth().currentUser?.email
//                let userPassword =　Auth.auth().currentUser?.
                
                self.addressLabel.text = address
                self.firstNameLabel.text = fname
                self.lastNameLabel.text = lname
                
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
            }
            editProfileButton.setTitle("Edit Profile", for: .normal)
            deleteAccountButton.isEnabled = true
            
        }else{
            firstNameField.isEnabled = true
            lastNameField.isEnabled = true
            addressField.isEnabled = true
            passwordField.isEnabled = true
            
            editProfileButton.setTitle("Save Changes", for: .normal)
            
            deleteAccountButton.isEnabled = false
        }
        
        
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.showSettingsButton(show: false)
    }
    

   
}
