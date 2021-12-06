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
    
    var nameTable:Dictionary<String, String> = [:]
    
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var itemTitleLabel: UILabel!
    
    var inputPos = CGFloat()
    var originalPos = CGFloat()

    @objc func keyboardWillShow(sender: NSNotification) {
        guard let keyboardSize = (sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        self.view.frame.origin.y = 0.0 - keyboardSize.height
    }

    @objc func keyboardWillHide(sender: NSNotification) {
     
        self.view.frame.origin.y = 0.0 
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        print(self.chatMessageField.frame.minY)
        
        originalPos = chatMessageField.frame.minY
        print("originalPos \(originalPos)")
        //Looks for single or multiple taps.
         let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))

        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false

        view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil);

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);
        
        if (Auth.auth().currentUser != nil) {
            let authUser = Auth.auth().currentUser
            if(currentItem != nil) {
                buyerKey = authUser!.uid
                sellerKey = currentItem!.ownerKey
                itemKey = currentItem!.key
                itemTitleLabel.text = currentItem?.itemTitle
                ref = Database.database().reference()
                ref.child("users").child(sellerKey).observeSingleEvent(of: .value, with: { [self]
                    userSnapshot in
                    let avalue = userSnapshot.value as? NSDictionary
                    let mfname = avalue?["fname"] as? String ?? ""
                    nameTable[sellerKey] = mfname
                    ref.child("users").child(buyerKey).observeSingleEvent(of: .value, with: { [self]
                        userSnapshot in
                        let bvalue = userSnapshot.value as? NSDictionary
                        let ofname = bvalue?["fname"] as? String ?? ""
                        nameTable[buyerKey] = ofname
                        self.tableView.reloadData()
                    })
                })
                
            } else if chatThread != nil {
                let ct =  chatThread!
                buyerKey = ct.buyerId
                sellerKey = ct.sellerId
                itemKey = ct.itemId
                nameTable[buyerKey] = ct.buyerName
                nameTable[sellerKey] = ct.sellerName
                itemTitleLabel.text = ct.itemName

            }
            
            for key in nameTable.keys {
                if key == authUser?.uid {
                    nameTable[key] = "Me"
                }
            }
                        
            ref = Database.database().reference()
            ref.child("items").child(sellerKey).child(itemKey).child("chats").child(buyerKey).observe(.value, with: { snapshot in
                // Get user value
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
                ref.child("items").child(sellerKey).child(itemKey).child("chats").child(buyerKey).childByAutoId().setValue([
                        "msgData": chatMsg!,
                        "msgOwner": user!.uid,
                        "msgTime": Int(Date().timeIntervalSince1970)
                    ])
                chatMessageField.text = ""
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
        let prefix = "\(self.nameTable[ct.ownerKey] ?? "")"

        if(Auth.auth().currentUser != nil) {
            let user = Auth.auth().currentUser
            if user?.uid == ct.ownerKey {
                cell.detailTextLabel?.text = "\(prefix) : \(ct.msg)"
                cell.detailTextLabel?.numberOfLines = 0
                cell.textLabel?.text = ""
                cell.backgroundColor = BaseViewController.BURNT_ORANGE
            } else {
                cell.textLabel?.text = "\(prefix) : \(ct.msg)"
                cell.textLabel?.numberOfLines = 0
                cell.detailTextLabel?.text = ""
                cell.backgroundColor = BaseViewController.THEME_COLORS["GRAY"]
            }
            cell.textLabel?.textColor = UIColor.black
            cell.detailTextLabel?.textColor = UIColor.black
        }
        
        if (self.getFont() != nil) {
            cell.textLabel?.font = self.chatFont
            cell.detailTextLabel?.font = self.chatFont

        }
//        cell.backgroundColor = BaseViewController.BURNT_ORANGE
        return cell
    }
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
        originalPos = chatMessageField.frame.minY
        print("originalPos \(originalPos)")
    }
    
}
