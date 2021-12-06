//
//  LoginViewController.swift
//  UTSwap
//
//  Created by Peggy Chiang on 11/3/21.
//

import UIKit
import Firebase

class LoginViewController: BaseViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textFieldLoginUser: UITextField!
    @IBOutlet weak var textFieldLoginPass: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textFieldLoginUser.delegate = self
        self.textFieldLoginPass.delegate = self
        
        //Looks for single or multiple taps.
         let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))

        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false

        view.addGestureRecognizer(tap)

        Auth.auth().addStateDidChangeListener() { //If user is logged in, changes to Main VC
          auth, user in
          
          if user != nil {
            self.performSegue(withIdentifier: "segueIdentifier", sender: nil)
            self.textFieldLoginUser.text = nil
            self.textFieldLoginPass.text = nil
          }
        }
    }
    
    func textFieldShouldReturn(userText: UITextField!) -> Bool {
        userText.resignFirstResponder()
        return true;
    }
    
    @IBAction func signIn(_ sender: Any) {
        guard let email = textFieldLoginUser.text,
              let password = textFieldLoginPass.text,
              email.count > 0,
              password.count > 0
        else {
          return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) {
          user, error in
          if let error = error, user == nil {
            let alert = UIAlertController(
              title: "Sign in failed",
              message: error.localizedDescription,
              preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title:"OK",style:.default))
            self.present(alert, animated: true, completion: nil)
          }
            if user != nil {
                self.performSegue(withIdentifier: "segueIdentifier", sender: nil)
            }
        }
    }
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

}
//
//extension LoginViewController: UITextFieldDelegate {
//
//  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//    if textField == textFieldLoginUser {
//      textFieldLoginPass.becomeFirstResponder()
//    }
//    if textField == textFieldLoginPass {
//      textField.resignFirstResponder()
//    }
//    return true
//  }
//}
