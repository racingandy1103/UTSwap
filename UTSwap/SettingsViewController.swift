//
//  SettingsViewController.swift
//  UTSwap
//
//  Created by Jessica Trejo on 10/29/21.
//

import UIKit


class SettingsViewController: BaseViewController {
    
    let colors:[UIColor] = [UIColor.blue, UIColor.white,UIColor.red,UIColor.cyan, UIColor.yellow, UIColor.systemPink, UIColor.orange]
    
        
    
    
    @IBOutlet weak var colorBox: UIImageView!
    @IBOutlet weak var darkModeToggle: UISwitch!
    
    @IBAction func onEditColor(_ sender: Any) {
        let c = getRandomColor()
        self.setAccent(color: c)
    }
    
    func getRandomColor() -> UIColor {
        let c = colors[Int.random(in: 0..<colors.count)]
        return c
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.darkModeToggle.isOn = self.isDarkModeOn()
    }
    func setAccent(color: UIColor) {
        self.setNavColor(color: color)
        self.setCurrentAccentColor(color: color)
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
        let c = self.getCurrentAccentColor()
        self.setAccent(color: c)
    }
    
    
}
