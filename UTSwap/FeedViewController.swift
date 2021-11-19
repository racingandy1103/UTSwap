//
//  FeedViewController.swift
//  UTSwap
//
//  Created by Peggy Chiang on 11/14/21.
//

import UIKit
import Firebase
import FirebaseDatabase

let reuseIdentifier = "MyCell"
let initialItems = ["1","2","3"]


class Item {
    
    public var itemTitle:String = ""
    
    public var key:String = ""

    init(title:String) {
        self.itemTitle = title
    }
}


class FeedViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    // for DB
    var ref: DatabaseReference!
    
    var items:[String] = []


    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        var itemList:[String] = []
        for i in initialItems {
            itemList.append(i)
        }
        
        addItemsFromDBIntoList()
        
        self.items = itemList
    }
    
    func addItemsFromDBIntoList() {
        var itemsToAdd:[Item] = []
        if (Auth.auth().currentUser != nil) {
            print("reading items from db")
            ref = Database.database().reference()
            ref.child("items").observeSingleEvent(of: .value, with: { snapshot in
                // Get user value
                print(snapshot.childrenCount) // I got the expected number of items
                for rest in snapshot.children.allObjects as! [DataSnapshot] {
                   
                    for i in rest.children.allObjects as! [DataSnapshot] {
                        let title = i.childSnapshot(forPath: "itemTitle").value as! String
                        var a = Item(title: title)
                        a.key = snapshot.key
                        itemsToAdd.append(a)
                        self.items.append(title)
                    }
                   
                }
                
                self.collectionView.reloadData()
                // ...
              }) { error in
                print(error.localizedDescription)
              }
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let containerwidth = collectionView.bounds.width //width of screen
        let cellSize = (containerwidth-10)/2 //same as below
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FeedCollectionViewCell
        let imageview:UIImageView=UIImageView(frame: CGRect(x: 0, y: 0, width: cellSize, height: cellSize));
        
        // Note: this will be set to category selected from tableview
        let img : UIImage? = UIImage(named:"furniture\(indexPath.row)")
        if img != nil {
            imageview.image = img
        }
        
        let title : UITextView = UITextView(frame: CGRect(x: 0, y: cellSize-30, width: cellSize, height: cellSize))
        title.text = "\(items[indexPath.row])"
    
        cell.contentView.addSubview(imageview)
        cell.contentView.addSubview(title)

        cell.layer.borderColor = UIColor.orange.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8
        
        cell.layer.masksToBounds = false // turn clipping off so what i'm about to do becomes visible
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOpacity = 0.7
        cell.layer.shadowOffset = CGSize(width:5, height: 5) //5 pixes to right & 5 down
        cell.layer.shadowRadius = 4
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // Note: instead of printing this, will segue to item's buy page
        print("You selected cell #\(indexPath.row)!")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let layout = UICollectionViewFlowLayout()
        let containerwidth = collectionView.bounds.width
        let cellSize = (containerwidth-10)/2
        
        layout.itemSize = CGSize(width: cellSize, height: cellSize)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        collectionView.collectionViewLayout = layout
    }

}
