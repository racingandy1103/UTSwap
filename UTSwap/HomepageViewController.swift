//
//  HomepageViewController.swift
//  UTSwap
//
//  Created by Andy Hsieh on 2021/11/12.
//

import UIKit
import Firebase
protocol ButtonSetter {
    func setButton()
}


var LikedGoodsSegueID = "LikedGoodsPopoverSegue"

class HomepageViewController: BaseViewController, UIPopoverControllerDelegate, ButtonSetter {
    @IBOutlet weak var accountNameLabel: UILabel!
    @IBOutlet weak var likedGoodsLabel: UILabel!
    @IBOutlet weak var sellingGoodsLabel: UILabel!
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var sellButton: UIButton!
    @IBOutlet weak var chatButton: UIButton!
    @IBOutlet weak var notificationsButton: UIButton!
    @IBOutlet weak var advertiseImageView: UIImageView!
    @IBOutlet weak var heartButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (Auth.auth().currentUser != nil) { // Sets username
            accountNameLabel.text = Auth.auth().currentUser?.displayName
        }

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
