//
//  HomepageViewController.swift
//  UTSwap
//
//  Created by Andy Hsieh on 2021/11/12.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import AVFoundation

protocol ButtonSetter {
    func setButton()
}


var LikedGoodsSegueID = "LikedGoodsPopoverSegue"

class HomepageViewController: BaseViewController, UIPopoverControllerDelegate, ButtonSetter {
    @IBOutlet weak var profilePicImageView: UIImageView!
    @IBOutlet weak var accountNameLabel: UILabel!
    @IBOutlet weak var likedGoodsLabel: UILabel!
    @IBOutlet weak var sellingGoodsLabel: UILabel!
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var sellButton: UIButton!
    @IBOutlet weak var chatButton: UIButton!
    @IBOutlet weak var notificationsButton: UIButton!
    @IBOutlet weak var advertiseImageView: UIImageView!
    @IBOutlet weak var heartButton: UIButton!
    
    var ref: DatabaseReference!
    var timgUUID: String? = ""
    var likedGoods : [Item] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        if (Auth.auth().currentUser != nil) { // Sets username
            if (Auth.auth().currentUser?.displayName != nil) {
                accountNameLabel.text = "Welcome, " + "\n " + (Auth.auth().currentUser?.displayName)!
            }
        }
        
        
        profilePicImageView.layer.masksToBounds = true
        profilePicImageView.layer.cornerRadius = profilePicImageView.bounds.width / 2
        
        buyButton.layer.cornerRadius = 0.5*buyButton.bounds.size.width
        buyButton.clipsToBounds = true
        buyButton.backgroundColor?.withAlphaComponent(0.5)
        
        sellButton.layer.cornerRadius = 0.5*buyButton.bounds.size.width
        sellButton.clipsToBounds = true
        sellButton.backgroundColor?.withAlphaComponent(0.5)
        
        
        
        
        heartButton.setImage(UIImage(systemName:"suit.heart"), for: .normal)
        var imagesArr = [UIImage(named: "furniture0")!, UIImage(named: "furniture1")!, UIImage(named: "furniture2")!]
        
        for n in 0...imagesArr.count-1{
            imagesArr[n] = imagesArr[n].resize(200, 200)!
        }
        advertiseImageView.image = imagesArr[0]
        advertiseImageView.animationImages = imagesArr
        self.advertiseImageView.clipsToBounds = true
        self.advertiseImageView.animationRepeatCount = 0
        advertiseImageView.animationDuration = 3
        advertiseImageView.startAnimating()
        
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (Auth.auth().currentUser != nil) {
            let user = Auth.auth().currentUser
            let storage = Storage.storage()
            
            let profileRef = storage.reference(withPath: "profilepic/\(user!.uid)/profilePic.jpg")
            
            profileRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
                if error != nil {
                    self.profilePicImageView.image = UIImage(named: "default-profile-picture")
                } else {
                    self.profilePicImageView.image = UIImage(data: data!)
                }
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == LikedGoodsSegueID {
            let popoverVC = segue.destination as! LikedGoodsPopoverTableViewController
            popoverVC.delegate = self
            popoverVC.modalPresentationStyle = .popover
            popoverVC.popoverPresentationController?.delegate = self as? UIPopoverPresentationControllerDelegate
        }
    }
    

    @IBAction func tapHeartButton(_ sender: Any) {
        
        UIView.animate(withDuration: 1.0) {
            self.heartButton.setImage(UIImage(systemName:"suit.heart.fill"), for: .normal)
                        }
        addItemsFromDBIntoList()
        let vc = LikedGoodsPopoverTableViewController()
        vc.preferredContentSize = CGSize(width: 400,height: 500)
                vc.modalPresentationStyle = .popover
                if let pres = vc.presentationController {
                    pres.delegate = self
                    
                }
                self.present(vc, animated: true)
                if let pop = vc.popoverPresentationController {
                    pop.sourceView = (sender as! UIView)
                    pop.sourceRect = (sender as! UIView).bounds
                    
                }
        
        }
    func setButton() {
        UIView.animate(withDuration: 1.0) {
            self.heartButton.setImage(UIImage(systemName:"suit.heart"), for: .normal)
                        }
    }
    
    func addItemsFromDBIntoList() {
        
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

extension UIImage {
    func resize(_ width: CGFloat, _ height:CGFloat) -> UIImage? {
        let widthRatio  = width / size.width
        let heightRatio = height / size.height
        let ratio = widthRatio > heightRatio ? heightRatio : widthRatio
        let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}

extension BaseViewController : UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}
