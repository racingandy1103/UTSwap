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
    
//    let colors:[UIColor] = [UIColor.blue, UIColor.white,UIColor.red,UIColor.cyan, UIColor.yellow, UIColor.systemPink, UIColor.orange]
    
    let colors:[UIColor] = [ UIColor.orange, UIColor.gray]
    
    var ref: DatabaseReference!

    
    @IBOutlet weak var colorBox: UIImageView!
    @IBOutlet weak var darkModeToggle: UISwitch!
    
    
    @IBOutlet weak var themeSegment: UISegmentedControl!
    
    @IBAction func onFontEditPressed(_ sender: Any) {
        pickFont()
    }

    func pickFont() {
        let controller = UIAlertController( // Alert message
            title: "Font",
            message: "Select your desired chat font",
            preferredStyle: .alert)
        controller.addAction(UIAlertAction(
                                title: "SYSTEM",
                                style: .default,
                                handler: {action in
                                    self.setFont("SYSTEM")
                                    self.updateFontLabel()
                                }))
        controller.addAction(UIAlertAction(
                                title: "MONO",
                                style: .default,
                                handler: {action in
                                    self.setFont("MONO")
                                    self.updateFontLabel()
                                }))
        controller.addAction(UIAlertAction(
                                title: "MENLO",
                                style: .default,
                                handler: {action in
                                    self.setFont("MENLO")
                                    self.updateFontLabel()
                                }))
        controller.addAction(UIAlertAction(
                                title: "Cancel",
                                style: .cancel,
                                handler: nil))
        present(controller, animated: true, completion: nil)
    }

    
    func randomizeFont() {
        let key = BaseViewController.FONT_NAMES.randomElement()!.key
        self.setFont(key)
        updateFontLabel()
    }
    
    func updateFontLabel() {
        let key = self.getFontKey()
        self.fontLabel.text = "Chat Font"
        if key != nil {
            self.fontLabel.text = self.fontLabel.text! + " - \(key!)"
        }
        self.fontLabel.text =  self.fontLabel.text! + ": "
        self.fontLabel.font = self.getFont()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.darkModeToggle.isOn = self.isDarkModeOn()
        setUIColors(color: self.getCurrentAccentColor())
        
        self.showProfileButton()
        updateFontLabel()

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
//            self.chatBubble1.text = data
            // ...
          }) { error in
            print(error.localizedDescription)
          }
        
        
        self.themeSegment.addTarget(self, action: #selector(segmentSelected(sender:)), for: .valueChanged)
        
        if self.getThemeName() == "ORANGE" {
            self.themeSegment.selectedSegmentIndex = 0
        } else {
            self.themeSegment.selectedSegmentIndex = 1
        }
        updateFontLabel()
    }
    
    
    @objc func segmentSelected(sender: UISegmentedControl)
    {
        let index = sender.selectedSegmentIndex
        if index == 0 {
            self.setTheme(theme: "ORANGE")
        } else {
            self.setTheme(theme: "GRAY")
        }
        setUIColors(color: self.getCurrentAccentColor())
    }
    
}
