//
//  HomepageViewController.swift
//  UTSwap
//
//  Created by Andy Hsieh on 2021/11/12.
//

import UIKit

class HomepageViewController: BaseViewController {
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
        
        
        // Do any additional setup after loading the view.
        
        heartButton.setImage(UIImage(systemName:"suit.heart"), for: .normal)
        let imagesArr = [UIImage(named: "furniture0")!, UIImage(named: "furniture1")!, UIImage(named: "furniture2")!]
        
        advertiseImageView.image = UIImage(named: "furniture1")
        advertiseImageView.animationImages = imagesArr
        advertiseImageView.animationDuration = 3
        advertiseImageView.startAnimating()
        }
    

    @IBAction func tapHeartButton(_ sender: Any) {
        
        
        
        UIView.animate(withDuration: 1.0) {
            self.heartButton.setImage(UIImage(systemName:"suit.heart.fill"), for: .normal)
                    }
        
        if self.heartButton.currentImage == UIImage(systemName: "suit.heart.fill"){
            UIView.animate(withDuration: 1.0) {
                self.heartButton.setImage(UIImage(systemName:"suit.heart"), for: .normal)
                        }
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
