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


    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var addressField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if (Auth.auth().currentUser != nil) {
            let user = Auth.auth().currentUser

            ref = Database.database().reference()
            ref.child("users").child(user!.uid).observe(.value, with: { snapshot in
                // Get user value
                let value = snapshot.value as? NSDictionary
                let fname = value?["fname"] as? String ?? ""
                let lname = value?["lname"] as? String ?? ""
                let address = value?["address"] as? String ?? ""
                
                self.addressField.text = address
                self.firstNameField.text = fname
                self.lastNameField.text = lname


                // ...
              }) { error in
                print(error.localizedDescription)
              }
            }
        
    }
    @IBAction func onSaveProfileInfo(_ sender: Any) {
        if (Auth.auth().currentUser != nil) {
            let user = Auth.auth().currentUser
            self.ref.child("users").child(user!.uid).setValue(["fname": self.firstNameField.text, "lname": self.lastNameField.text, "address": self.addressField.text])
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.showSettingsButton(show: false)
    }
    

   
}
