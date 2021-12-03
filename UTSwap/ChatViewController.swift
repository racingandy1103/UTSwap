//
//  ChatViewController.swift
//  UTSwap
//
//  Created by Jessica Trejo on 11/20/21.
//

import UIKit
import Firebase
import FirebaseDatabase


class Chat {
    var msg: String = ""
    var ownerKey: String = ""
    var msgTime: Int = 0
    init(msg: String) {
        self.msg = msg
    }
}

class ChatViewController:  BaseViewController, UITableViewDelegate, UITableViewDataSource {
    var chatThread: ChatThread? = nil
    var currentItem:Item? = nil
    var chats:[Chat] = []
    
    
    
    var buyerKey = ""
    var sellerKey = ""
    var itemKey = ""
   
    // for DB
    var ref: DatabaseReference!
    
    @IBOutlet weak var chatMessageField: UITextField!
    
  
    
    @IBOutlet weak var tableView: UITableView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        if (Auth.auth().currentUser != nil) {
            let authUser = Auth.auth().currentUser
            if(currentItem != nil) {
                buyerKey = authUser!.uid
                sellerKey = currentItem!.ownerKey
                itemKey = currentItem!.key
            } else if chatThread != nil {
                let ct =  chatThread!
                buyerKey = ct.buyerId
                sellerKey = ct.sellerId
                itemKey = ct.itemId
            }
            
            ref = Database.database().reference()
            ref.child("items").child(sellerKey).child(itemKey).child("chats").child(buyerKey).observe(.value, with: { snapshot in
                // Get user value
                print("ChatViewController")
                print(snapshot.childrenCount) // I got the expected number of chats
                var dbChats:[Chat] = []
                for rest in snapshot.children.allObjects as! [DataSnapshot] {
                    let msgData = rest.childSnapshot(forPath: "msgData").value as? String
                    let msgOwner = rest.childSnapshot(forPath: "msgOwner").value as? String
                    
                    let msgTime = rest.childSnapshot(forPath: "msgTime").value as? Int
                    if msgData != nil && msgOwner != nil && msgTime != nil {
                        let a = Chat(msg: msgData!)
                        a.ownerKey = msgOwner!
                        a.msgTime = msgTime!
                        dbChats.append(a)
                    }
                   
                }
                self.chats = dbChats.sorted(by: self.sortChatByTime(c1:c2:))
                self.tableView.reloadData()

                // ...
              }) { error in
                print(error.localizedDescription)
              }
        }

       
    }
   
    
    func sortChatByTime(c1:Chat, c2:Chat) -> Bool {
        return c1.msgTime < c2.msgTime
    }
    
    @IBAction func onSendMessage(_ sender: Any) {
        if(chatMessageField.text != nil) {
            if(Auth.auth().currentUser != nil && itemKey != "" && buyerKey != "" && sellerKey != "") {
                
                let user = Auth.auth().currentUser
                ref = Database.database().reference()
                
                

                ref.child("chats").child(buyerKey).child(sellerKey).child(itemKey).setValue("SELLER")
                
                ref.child("chats").child(sellerKey).child(buyerKey).child(itemKey).setValue("BUYER")
                
                
                let chatMsg = chatMessageField.text
                print("reading items from db for chats")
                ref.child("items").child(sellerKey).child(itemKey).child("chats").child(buyerKey).childByAutoId().setValue([
                        "msgData": chatMsg!,
                        "msgOwner": user!.uid,
                        "msgTime": Int(Date().timeIntervalSince1970)
                    ])
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatLogCellID", for: indexPath)
        let row = indexPath.row
        let ct = self.chats[row]
        cell.textLabel?.text = ct.msg
        cell.textLabel?.numberOfLines = 0
        cell.detailTextLabel?.text = ""
        cell.sizeToFit()

//        cell.backgroundColor = BaseViewController.BURNT_ORANGE
        return cell
    }
    
}
