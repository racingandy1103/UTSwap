//
//  ChatLogViewController.swift
//  UTSwap
//
//  Created by Jessica Trejo on 11/24/21.
//

import UIKit
import Firebase
import FirebaseDatabase


class ChatLogViewController: BaseViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    var currentItem:Item? = nil
    var chats:[Chat] = []
   
    // for DB
    var ref: DatabaseReference!
    
    var top: Float = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.addSubview(scrollViewContainer)
//        scrollViewContainer.addArrangedSubview(chatView)
//        scrollViewContainer.addArrangedSubview(chatView)
//        scrollViewContainer.addArrangedSubview(chatView)

//        scrollViewContainer.addArrangedSubview(blueView)
//        scrollViewContainer.addArrangedSubview(greenView)
//        scrollViewContainer.backgroundColor = .magenta
//
        scrollViewContainer.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        scrollViewContainer.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        scrollViewContainer.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        scrollViewContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true

        // this is important for scrolling
        scrollViewContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        addChat(true)
        addChat(false)
        addChat(true)
        addChat(false)
        addChat(false)
        addChat(true)
        addChat(true)

    }

    let scrollViewContainer: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    func container(_ onLeft: Bool) -> UIStackView {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 10
        return stack
    }
    


        
    
    func addChat(_ onLeft: Bool) {
        let view = UITextView()
        
        var val = ""
        for _ in 1...10 {
            val += "\n hello";
        }
        view.text = val
        view.textColor = .black
        view.backgroundColor = getRandomColor()
        view.sizeToFit()
        view.center.y = CGFloat(top) + scrollViewContainer.spacing
        let h = view.bounds.maxY
        
        top = Float(CGFloat(top) + h +  scrollViewContainer.spacing)
        
        
          
        scrollViewContainer.addSubview(view)
    }
   
    

//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        if(currentItem != nil) {
//            if (Auth.auth().currentUser != nil && currentItem?.key != "" && currentItem?.ownerKey != "") {
//                let user = Auth.auth().currentUser
//                print("reading items from db")
//                ref = Database.database().reference()
//                ref.child("items").child(currentItem!.ownerKey).child(currentItem!.key).child("chats").child(user!.uid).observe(.value, with: { snapshot in
//                    // Get user value
//                    print("ChatViewController")
//                    print(snapshot.childrenCount) // I got the expected number of chats
//                    var dbChats:[Chat] = []
//                    for rest in snapshot.children.allObjects as! [DataSnapshot] {
//                        let msg = rest.childSnapshot(forPath: "msg").value as? String
//                        if msg != nil {
//                            print(msg)
//                            let a = Chat(msg: msg!)
//                            dbChats.append(a)
//                        }
//
//                    }
//                    self.chats = dbChats
//                    self.renderChats()
//                    // ...
//                  }) { error in
//                    print(error.localizedDescription)
//                  }
//            }
//        }
//
//    }
    
//    func renderChats() {
//
//        scrollView.addSubview(<#T##view: UIView##UIView#>)
//    }
//
//    func getTextViewFromChat(chat: Chat) {
//        let tv = UITextView()
//    }
    

}

