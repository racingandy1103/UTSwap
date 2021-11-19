//
//  signUpViewController.swift
//  UTSwap
//
//  Created by Peggy Chiang on 11/7/21.
//

import UIKit
import Firebase
import UserNotifications

class signUpViewController: UIViewController, UNUserNotificationCenterDelegate {
    
    @IBOutlet weak var textFieldLoginUser: UITextField!
    @IBOutlet weak var textFieldLoginPass: UITextField!
    @IBOutlet weak var confPassTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        UNUserNotificationCenter.current().delegate = self
    }
    
    @IBAction func signUp(_ sender: Any) {
        let userField = textFieldLoginUser.text
        let passField = textFieldLoginPass.text
        let confField = confPassTextField.text
        if passField == confField { // Creates account when passwords are same
            Auth.auth().createUser(withEmail: userField!, password: passField!) { user, error in
                if error == nil {
                    Auth.auth().signIn(withEmail: self.textFieldLoginUser.text!,
                                       password: self.textFieldLoginPass.text!)
                    //self.performSegue(withIdentifier: "segue2Identifier", sender: nil)
                    print("yay")
                    // create an object that holds the data for our notification
                    let notification = UNMutableNotificationContent()
                    notification.title = "Sign-up Successful"
                    notification.subtitle = "Sign-up Status"
                    notification.body = "You have successfully created an account on UTSwap!"
                    
                    // set up the notification's trigger
                    let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
                    
                    // set up a request to tell iOS to submit the notification with that trigger
                    let request = UNNotificationRequest(identifier: "notification1", content: notification, trigger: notificationTrigger)
                    
                    
                    // submit the request to iOS
                    UNUserNotificationCenter.current().add(request) { (error) in
                        print("Request error: ",error as Any)
                    }
                    print("Submitted")
                }
            }
        } else {
            let alert = UIAlertController(
              title: "Sign up failed",
                message: "Please type in the same password",
              preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title:"OK",style:.default))
            self.present(alert, animated: true, completion: nil)
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
