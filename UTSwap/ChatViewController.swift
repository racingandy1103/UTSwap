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
    init(msg: String) {
        self.msg = msg
    }
}

class ChatViewController:  BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    var currentItem:Item? = nil
    var chats:[Chat] = []
   
    // for DB
    var ref: DatabaseReference!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableView.automaticDimension

        if(currentItem != nil) {
            if (Auth.auth().currentUser != nil && currentItem?.key != "" && currentItem?.ownerKey != "") {
                let user = Auth.auth().currentUser
                print("reading items from db")
                ref = Database.database().reference()
                ref.child("items").child(currentItem!.ownerKey).child(currentItem!.key).child("chats").child(user!.uid).observe(.value, with: { snapshot in
                    // Get user value
                    print("ChatViewController")
                    print(snapshot.childrenCount) // I got the expected number of chats
                    var dbChats:[Chat] = []
                    for rest in snapshot.children.allObjects as! [DataSnapshot] {
                        let msg = rest.childSnapshot(forPath: "msg").value as? String
                        if msg != nil {
                            print(msg)
                            let a = Chat(msg: msg!)
                            dbChats.append(a)
                        }
                       
                    }
                    self.chats = dbChats
                    self.tableView.reloadData()
                    // ...
                  }) { error in
                    print(error.localizedDescription)
                  }
            }
        }
    
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatCellId", for: indexPath) as! ChatCellTableViewCell
        let row = indexPath.row
        let ct = self.chats[row]
        cell.chatText.text = ct.msg
        cell.chatText.numberOfLines = 0
        
        
        cell.sizeToFit()
        cell.layoutIfNeeded()
        return cell
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    func tableView(tableView: UITableView,
        heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableView.automaticDimension
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
