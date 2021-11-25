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
    

    @IBAction func tapHeartButton(_ sender: Any) {
        
        
        
       
        
        if self.heartButton.currentImage == UIImage(systemName: "suit.heart.fill"){
            UIView.animate(withDuration: 1.0) {
                self.heartButton.setImage(UIImage(systemName:"suit.heart"), for: .normal)
                        }
        }else{
            UIView.animate(withDuration: 1.0) {
                self.heartButton.setImage(UIImage(systemName:"suit.heart.fill"), for: .normal)
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
