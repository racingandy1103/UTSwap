//
//  SettingsViewController.swift
//  UTSwap
//
//  Created by Jessica Trejo on 10/29/21.
//

import UIKit
import Firebase
import FirebaseDatabase



class SettingsViewController: BaseViewController {
    
    let colors:[UIColor] = [UIColor.blue, UIColor.white,UIColor.red,UIColor.cyan, UIColor.yellow, UIColor.systemPink, UIColor.orange]
    
    var ref: DatabaseReference!

    
    @IBOutlet weak var colorBox: UIImageView!
    @IBOutlet weak var darkModeToggle: UISwitch!
    
    static let fontList: [UIFont] = [
        UIFont.monospacedSystemFont(ofSize: 12.0, weight: .regular),
        UIFont.systemFont(ofSize: 12.0, weight: .regular),
        UIFont(name: "Menlo", size: 12.0) ?? UIFont.systemFont(ofSize: 12.0, weight: .regular)
    ]
    
    var currentFont: UIFont = fontList[0]
    
    @IBOutlet weak var chatBubble1: UITextView!
    
    @IBAction func onFontEditPressed(_ sender: Any) {
        randomizeFont()
    }
    
    @IBOutlet weak var chatBubble2: UITextView!
    @IBAction func onEditColor(_ sender: Any) {
        self.setTheme(theme: self.getRandomTheme())
        setUIColors(color: self.getCurrentAccentColor())
    }
    
    func randomizeFont() {
        currentFont = SettingsViewController.fontList.randomElement()!
        chatBubble1.font = currentFont
        chatBubble2.font = currentFont
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.darkModeToggle.isOn = self.isDarkModeOn()
        setUIColors(color: self.getCurrentAccentColor())
        
        chatBubble1.layer.borderWidth = 1.0
        chatBubble1.layer.masksToBounds = false
        chatBubble1.layer.borderColor = UIColor.white.cgColor
        chatBubble1.layer.cornerRadius = chatBubble1.bounds.height / 2
        chatBubble1.clipsToBounds = true
        
        
        chatBubble2.layer.borderWidth = 1.0
        chatBubble2.layer.masksToBounds = false
        chatBubble2.layer.borderColor = UIColor.white.cgColor
        chatBubble2.layer.cornerRadius = chatBubble1.bounds.height / 2
        chatBubble2.clipsToBounds = true
        
        chatBubble1.contentInset = UIEdgeInsets(top: 10, left: 12, bottom: 10, right: 12)
        chatBubble2.contentInset = UIEdgeInsets(top: 10, left: 12, bottom: 10, right: 12)
        
//        var fixedWidth = chatBubble1.frame.size.width
//        var newSize = chatBubble1.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
//        chatBubble1.frame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
//
//        fixedWidth = chatBubble2.frame.size.width
//        newSize = chatBubble2.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
//        chatBubble2.frame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        
        chatBubble1.font = currentFont
        chatBubble2.font = currentFont
        
        


    }
    
    func setUIColors(color: UIColor) {
        darkModeToggle.onTintColor = color
        colorBox.backgroundColor = color
    }
    
    @IBOutlet weak var fontLabel: UILabel!
    
    @IBAction func editFont(_ sender: Any) {
    }
    
    @IBAction func onDarkModeToggle(_ sender: Any) {
        self.setDarkMode(bool: !self.isDarkModeOn())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        showSettingsButton(show: false)
        colorBox.layer.masksToBounds = true
        colorBox.layer.borderWidth = 1.5
        
        ref = Database.database().reference()
        ref.child("TestData").observeSingleEvent(of: .value, with: { snapshot in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let data = value?["DataChunk1"] as? String ?? ""
            self.chatBubble1.text = data
            // ...
          }) { error in
            print(error.localizedDescription)
          }
    }
    
    
}
