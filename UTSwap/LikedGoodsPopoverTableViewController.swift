//
//  LikedGoodsPopoverTableViewController.swift
//  UTSwap
//
//  Created by Andy Hsieh on 2021/11/24.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage

class LikedGoodsPopoverTableViewController: UITableViewController {
    
    private let likedgoodslist = ["placeholder1", "placeholder2", "placeholder3"]
    
    var likedGoods : [Item] = []
    var delegate: ButtonSetter?
    var ref: DatabaseReference!
    var timgUUID: String? = ""
    
    override func viewWillAppear(_ animated: Bool) {
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if (Auth.auth().currentUser != nil) {
            let user = Auth.auth().currentUser
            ref = Database.database().reference()
            print("reading items from db")
            ref = Database.database().reference()
            ref.child("likeditems").child(user!.uid).observeSingleEvent(of: .value, with: { snapshot in
                // Get user value
                print("here are childrens" + "\(snapshot.childrenCount)") // I got the expected number of items
                
                for rest in snapshot.children.allObjects as! [DataSnapshot] {
                    let ownerKey = rest.key
                    
                        let cat = rest.childSnapshot(forPath: "itemCategory").value as? String
                        let status = rest.childSnapshot(forPath: "itemStatus").value as? String
                        
                            
                        let key = rest.key
                        let title = rest.childSnapshot(forPath: "itemTitle").value as! String
                                
                                
                        let a = Item(title: title)
                        a.ownerKey = ownerKey
                        a.key = key
                        a.itemTitle = title
                        self.likedGoods.append(a)
                        print(self.likedGoods[0].itemTitle + " what")
                    
                }
                print(self.likedGoods[0].itemTitle + " what" + self.likedGoods[1].itemTitle)
                
                
                // ...
              }) { error in
                print(error.localizedDescription)
              }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            print("Async after 1 second")
            self.tableView.reloadData()
            print(self.likedGoods[0].itemTitle)
            self.tableView.reloadData()
            }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source
    
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return likedGoods.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = likedGoods[indexPath.row].itemTitle
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true, completion: nil)
        delegate?.setButton()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        delegate?.setButton()
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
