//
//  ItemBuyViewController.swift
//  UTSwap
//
//  Created by Jessica Trejo on 10/29/21.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage

class ItemBuyViewController: BaseViewController {
    
    // for DB
    var ref: DatabaseReference!
    
    
    public var currentItem:Item? = nil
    
    @IBOutlet weak var timeDesc: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descBox: UITextView!
    @IBOutlet weak var chatButton: UIButton!
    @IBOutlet weak var mapButton: UIButton!
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var heartLabel: UIButton!
    
    var imgUUID: String? = ""
    var itemOwnedByAuthUser = false
    var itemDetails:[String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        // Do any additional setup after loading the view.
        
        if(currentItem != nil) {
            if (Auth.auth().currentUser != nil && currentItem?.key != "" && currentItem?.ownerKey != "") {
                print("Item Buy :: reading items from db")
                let user = Auth.auth().currentUser
                let likedItemUUID = UUID.init().uuidString
                ref = Database.database().reference()
                ref.child("items").child(currentItem!.ownerKey).child(currentItem!.key).observeSingleEvent(of: .value, with: { snapshot in
                    // Get user value
                    print(snapshot.childrenCount) // I got the expected number of items

                        
                        
                    let title = snapshot.childSnapshot(forPath: "itemTitle").value as? String
                    if title != nil {
                        self.itemDetails.append(title!)
                        self.titleLabel.text = title
                        self.titleLabel.sizeToFit()

                    }else{
                        self.itemDetails.append("")
                    }
                    
                    let price = snapshot.childSnapshot(forPath: "itemPrice").value as? String
                    if price != nil {
                        self.itemDetails.append(price!)
                        self.priceLabel.text = "Price: $\(price!)"
                        self.priceLabel.sizeToFit()
                    }else{
                        self.itemDetails.append("")
                    }
                    
                    let location = snapshot.childSnapshot(forPath: "meetLocation").value as? String
                    if location != nil && location != "" {
                        self.itemDetails.append(location!)
                        self.locationLabel.text = "\(location!)"
                        self.locationLabel.sizeToFit()

                    } else {
                        self.itemDetails.append("")
                        self.locationLabel.isHidden = true
                        self.mapButton.isHidden = true
                    }
                    
                    let time = snapshot.childSnapshot(forPath: "meetTime").value as? String
                    if time != nil {
                        self.itemDetails.append(time!)
                        self.timeDesc.text = "Meet at \(time!)"
                        self.timeDesc.sizeToFit()

                    }else{
                        self.itemDetails.append("")
                    }
                    
                    let desc = snapshot.childSnapshot(forPath: "itemDesc").value as? String
                    if desc != nil {
                        self.itemDetails.append(desc!)
                        self.descBox.text = desc
                        self.descBox.sizeToFit()
                    }else{
                        self.itemDetails.append("")
                    }
                   
                    let imgUUID = snapshot.childSnapshot(forPath: "itemImgUUID").value as? String
                    if imgUUID != nil {
                        self.imgUUID = imgUUID
                    }
                    
                    let storage = Storage.storage()
                    let storageRef = storage.reference()
                    
                    if self.imgUUID != nil {
                        let imgRef = storageRef.child("itemimages").child("\(self.imgUUID!).jpg")
                        print(imgRef.fullPath)
                        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
                        imgRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
                          if let error = error {
                            // Uh-oh, an error occurred!
                            print("error \(error)")
                          } else {
                            // Data for "images/island.jpg" is returned
                            let image = UIImage(data: data!)
                            self.imgView.image = image
//                            let image = UIImage()
                          }
                        }
                    }
                    // ...
                  }) { error in
                    print(error.localizedDescription)
                  }
                
                if currentItem!.ownerKey == user?.uid {
                    itemOwnedByAuthUser = true
                }
                
                if itemOwnedByAuthUser {
                    chatButton.isHidden = true
                }
                
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToItemChatSegue" {
            let dest = segue.destination as! ChatViewController
            dest.currentItem = self.currentItem
        }
        
        else if segue.identifier == "ToItemMapSegue" {
            
                let dest = segue.destination as! LocationMapViewController
            if self.locationLabel.text != nil {
                dest.meetLocation = self.locationLabel.text!
            }
        }
    }

    @IBAction func heartPressed(_ sender: Any) {
        
        if(heartLabel.currentImage == UIImage(systemName:"suit.heart")){
            UIView.animate(withDuration: 1.0) {
                self.heartLabel.setImage(UIImage(systemName:"suit.heart.fill"), for: .normal)
                            }
            
            if (Auth.auth().currentUser != nil) {
                let user = Auth.auth().currentUser
                let likedItemUUID = UUID.init().uuidString
                itemDetails.append(likedItemUUID)
                print("onSaveItemPress - reading items from db")
                
                ref = Database.database().reference()
                
                var dataToAdd = ["itemTitle": itemDetails[0], "itemPrice": itemDetails[1],"meetLocation": itemDetails[2], "itemDesc": itemDetails[4], "meetTime": itemDetails[3]]

                
                    dataToAdd["itemImgUUID"] = imgUUID
                

                ref.child("likeditems").child(user!.uid).child(likedItemUUID).setValue(dataToAdd)
                ref.child("likeditemsid").child(user!.uid).child(likedItemUUID)
            }
            
        }else{
            UIView.animate(withDuration: 1.0) {
                self.heartLabel.setImage(UIImage(systemName:"suit.heart"), for: .normal)
                            }
            if (Auth.auth().currentUser != nil) {
                
                let user = Auth.auth().currentUser
                ref = Database.database().reference()
                ref.child("likeditems").child(user!.uid).child(itemDetails[5]).removeValue()
            }
        }
        
        
    }
    
    @IBAction func buyPressed(_ sender: Any) {
        
        let controller = UIAlertController(
            title: "Confirm purchase", message: "Are you sure you would like to purchase this item?", preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        controller.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in

            // Set item status to sold
            self.ref = Database.database().reference()
            var dataToAdd = ["itemStatus": "sold"]
            self.ref.child("items").child(self.currentItem!.ownerKey).child(self.currentItem!.key).updateChildValues(dataToAdd)
            
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
