//
//  ChatHistoryViewController.swift
//  UTSwap
//
//  Created by Jessica Trejo on 12/3/21.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage


class ChatThread {
    
    var itemId: String = ""
    var buyerId: String = ""
    var sellerId: String = ""
    var type:String = ""
    
    var itemName: String = ""
    var buyerName: String = ""
    var sellerName: String = ""

    init() {
        
    }
}

class ChatHistoryViewController:  BaseViewController, UITableViewDelegate, UITableViewDataSource {

    var chatThreads:[ChatThread] = []
    var ref: DatabaseReference!
    var currentChatThread: ChatThread? = nil
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        chatThreads = []
        
        var threads:[ChatThread] = []
        if (Auth.auth().currentUser != nil) {
            let user = Auth.auth().currentUser
            ref = Database.database().reference()
            ref.child("chats").child(user!.uid).observeSingleEvent(of: .value, with: { snapshot in
                // Get user value
                print(snapshot.childrenCount) // I got the expected number of items
                
                for other in snapshot.children.allObjects as! [DataSnapshot] {
                    let otherKey = other.key
                  
                    
                    for itemChat in other.children.allObjects as! [DataSnapshot] {
                        let itemKey = itemChat.key
                        let chatType = itemChat.value as? String
                        var chatThread = ChatThread()
                        print(chatType)
                        if chatType == "BUYER" {
                            chatThread.buyerId = otherKey
                            chatThread.sellerId = user!.uid
                            chatThread.itemId = itemKey
                            chatThread.type =  "BUYER"

                        } else if chatType == "SELLER" {
                            chatThread.buyerId = user!.uid
                            chatThread.sellerId = otherKey
                            chatThread.itemId = itemKey
                            chatThread.type =  "SELLER"
                        }
                        
                        print(chatThread.sellerId)
                        print(chatThread.itemId)

                        let itemRef = Database.database().reference()
                        itemRef.child("items").child(chatThread.sellerId).child(chatThread.itemId).observeSingleEvent(of: .value, with: { [self]
                            s in
                            
                            print(s.key)
                            print(s.childrenCount)
                            let title = s.childSnapshot(forPath: "itemTitle").value as? String
                            print(title)
                            chatThread.itemName = title ?? "Item Inquery"
                            
                            ref = Database.database().reference()
                            ref.child("users").child(chatThread.sellerId).observeSingleEvent(of: .value, with: { [self]
                                userSnapshot in
                                let avalue = userSnapshot.value as? NSDictionary
                                let mfname = avalue?["fname"] as? String ?? ""
                                print(mfname)
                                chatThread.sellerName = mfname
                                ref.child("users").child(chatThread.buyerId).observeSingleEvent(of: .value, with: { [self]
                                    userSnapshot in
                                    let bvalue = userSnapshot.value as? NSDictionary
                                    let ofname = bvalue?["fname"] as? String ?? ""
                                    print(ofname)
                                    chatThread.buyerName = ofname
                                    
                                    self.chatThreads.append(chatThread)
                                    self.tableView.reloadData()
                                })
                               
                            })
                            
                           

                        })
                        
                        
                    }
                    
                    
                }
                self.tableView.reloadData()
              }) { error in
                print(error.localizedDescription)
              }
        }

    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           print("row: \(indexPath.row)")
        let ct = chatThreads[indexPath.row]
        self.currentChatThread = ct
        performSegue(withIdentifier: "OnChatHistoryCellPressSegue", sender: self)
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatThreads.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatHistoryCellID", for: indexPath)
        let row = indexPath.row
        let ct = self.chatThreads[row]
        var suffix = ""
        if ct.type == "SELLER" {
            suffix = ct.sellerName
        } else {
            suffix = ct.buyerName
        }
        cell.textLabel?.text = "\(ct.itemName) \(suffix)"
        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "OnChatHistoryCellPressSegue" {
            let dest = segue.destination as! ChatViewController
            dest.chatThread = self.currentChatThread
        }
    }

    
}
