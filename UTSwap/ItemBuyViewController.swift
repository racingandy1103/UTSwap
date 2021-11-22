//
//  ItemBuyViewController.swift
//  UTSwap
//
//  Created by Jessica Trejo on 10/29/21.
//

import UIKit
import Firebase
import FirebaseDatabase

class ItemBuyViewController: BaseViewController {
    
    // for DB
    var ref: DatabaseReference!
    public var currentItem:Item? = nil
    
    @IBOutlet weak var timeDesc: UITextView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descBox: UITextView!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if(currentItem != nil) {
            if (Auth.auth().currentUser != nil && currentItem?.key != "" && currentItem?.ownerKey != "") {
                print("reading items from db")
                ref = Database.database().reference()
                ref.child("items").child(currentItem!.ownerKey).child(currentItem!.key).observeSingleEvent(of: .value, with: { snapshot in
                    // Get user value
                    print(snapshot.childrenCount) // I got the expected number of items
                    
                    let title = snapshot.childSnapshot(forPath: "itemTitle").value as? String
                    if title != nil {
                        self.titleLabel.text = title
                    }
                    
                    let price = snapshot.childSnapshot(forPath: "itemPrice").value as? String
                    if price != nil {
                        self.priceLabel.text = price
                    }
                    
                    let location = snapshot.childSnapshot(forPath: "meetLocation").value as? String
                    if location != nil {
                        self.locationLabel.text = location
                    }
                    
                    let time = snapshot.childSnapshot(forPath: "meetTime").value as? TimeInterval
                    if time != nil {
                        self.timeDesc.text = Date(timeIntervalSince1970: time!).description(with: Locale.current)
                    }
                    
                    let desc = snapshot.childSnapshot(forPath: "itemDesc").value as? String
                    if desc != nil {
                        self.descBox.text = desc
                    }
                   
                    let pic = snapshot.childSnapshot(forPath: "itemPic").value as? UIImageView
                    if pic != nil {
                        self.imgView = pic
                    }
                    // ...
                  }) { error in
                    print(error.localizedDescription)
                  }
            }
        }
    }
    
    @IBAction func buyPressed(_ sender: Any) {
        
        let controller = UIAlertController(
            title: "Confirm purchase", message: "Are you sure you would like to purchase this item?", preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        controller.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in

            // create an object that holds the data for our notification
            let notification = UNMutableNotificationContent()
            notification.title = "Purchase Complete"
            notification.body = "Your purchase has succesfully completed!"
            
            // set up the notification's trigger
            let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
            
            // set up a request to tell iOS to submit the notification with that trigger
            let request = UNNotificationRequest(identifier: "notification2",
                                                content: notification,
                                                trigger: notificationTrigger)
            
            
            // submit the request to iOS
            UNUserNotificationCenter.current().add(request) { (error) in
                print("Request error: ",error as Any)
            }
            print("Submitted")
            
            
        }))
        present(controller, animated: true, completion: nil)
    }
}
