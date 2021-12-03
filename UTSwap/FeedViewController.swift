//
//  FeedViewController.swift
//  UTSwap
//
//  Created by Peggy Chiang on 11/14/21.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage

let reuseIdentifier = "MyCell"
//let initialItems = [Item(title:"1"),Item(title:"2"),Item(title:"3")]


class Item {
    
    public var itemTitle:String = ""
    public var itemImgUUID: String = ""
    public var key:String = ""
    public var ownerKey:String = ""

    init(title:String) {
        self.itemTitle = title
    }
    
    func printDesc() {
        print("Item: \(ownerKey) \(key) \(itemTitle)")
        
    }

}


class FeedViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    // for DB
    var categoryName = String()
    var ref: DatabaseReference!
    var timgUUID: String? = ""
    var items:[Item] = []


    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        /*var itemList:[Item] = []
        for i in initialItems {
            itemList.append(i)
        }*/
        
        addItemsFromDBIntoList()
        
        //self.items = itemList
        print(self.items)
    }
    
    func addItemsFromDBIntoList() {
        if (Auth.auth().currentUser != nil) {
            let user = Auth.auth().currentUser
            ref = Database.database().reference()
            print("reading items from db")
            ref = Database.database().reference()
            ref.child("items").observeSingleEvent(of: .value, with: { snapshot in
                // Get user value
                print(snapshot.childrenCount) // I got the expected number of items
                
                for rest in snapshot.children.allObjects as! [DataSnapshot] {
                    let ownerKey = rest.key
                    if ownerKey != user?.uid {
                        for i in rest.children.allObjects as! [DataSnapshot] {
                            let cat = i.childSnapshot(forPath: "itemCategory").value as? String
                            if cat != nil {
                                if cat == self.categoryName{
                                    let key = i.key
                                    let title = i.childSnapshot(forPath: "itemTitle").value as! String
                                    let imgUUID = i.childSnapshot(forPath: "itemImgUUID").value as? String
                                    
                                    let a = Item(title: title)
                                    a.ownerKey = ownerKey
                                    a.key = key
                                    if imgUUID != nil {
                                        a.itemImgUUID = imgUUID!
                                    }
                                    self.items.append(a)
                                }
                            }
                        }
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
        
        let title : UITextView = UITextView(frame: CGRect(x: 0, y: cellSize-30, width: cellSize, height: cellSize))
        let item = items[indexPath.row]
        title.text = "\(item.itemTitle)"
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        
        let user = Auth.auth().currentUser
        if item.itemImgUUID != nil {
            let imgRef = storageRef.child("images").child(item.ownerKey).child("\(item.itemImgUUID).jpg")
            print(imgRef.fullPath)
            // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
            imgRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
              if let error = error {
                // Uh-oh, an error occurred!
                print("error \(error)")
              } else {
                // Data for "images/island.jpg" is returned
                let pic = UIImage(data: data!)
                imageview.image = pic
              }
            }
        }
        
    
        /*let img : UIImage? = UIImage(named:"furniture\(indexPath.row)")
        if img != nil {
            imageview.image = img
        }*/
        
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
        let i = self.items[indexPath.row]
        i.printDesc()
        showItemBuyForItem(item: i)
    }
    
    func showItemBuyForItem(item: Item)
    {
        let storyBoard = UIStoryboard(name: "ItemBuy", bundle:nil)
        let itemBuyScreen = storyBoard.instantiateViewController(withIdentifier: "itemBuyId") as! ItemBuyViewController
        itemBuyScreen.currentItem = item
        self.navigationController?.pushViewController(itemBuyScreen, animated: true)
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
