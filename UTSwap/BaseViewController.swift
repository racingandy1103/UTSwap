//
//  NavigationViewController.swift
//  UTSwap
//
//  Created by Jessica Trejo on 10/29/21.
//

import UIKit

extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
}
public let categories = [
    "Furniture", "Clothing", "Electronics", "Book",
    "Misc."
]

class BaseViewController: UIViewController {
    
    var currentColor: UIColor = .lightGray
    
    public static let BURNT_ORANGE =  UIColor(rgb: 0xBE5801)

    public static let THEME_COLORS = [
        "BLUE": UIColor.blue,
        "RED": UIColor.red,
        "SYSTEM_PINK": UIColor.systemPink,
        "WHITE": UIColor.white,
        "CYAN": UIColor.cyan,
        "ORANGE": BURNT_ORANGE,
        "GRAY": UIColor.gray
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barTintColor = getCurrentAccentColor()
        
        if(navigationItem.rightBarButtonItem == nil) {
            showSettingsButton(show: true)
        }
        setNavbarColor()

    }
    
    func setNavbarColor() {
        if self.getThemeName() == "ORANGE" {
            self.navigationController!.navigationBar.tintColor = UIColor.black
        } else {
            self.navigationController!.navigationBar.tintColor = BaseViewController.BURNT_ORANGE
        }
    }
    
    func getThemeName() -> String {
        return UserDefaults.standard.string(forKey: "accentColor") ?? "ORANGE"
    }
        
    func getCurrentAccentColor() -> UIColor {
        let key = UserDefaults.standard.string(forKey: "accentColor")
        return BaseViewController.THEME_COLORS[key ?? "ORANGE"]!
    }
    
    
    func setTheme(theme: String) {
        let _: Void = UserDefaults.standard.setValue(theme, forKey: "accentColor")

        setCurrentAccentColor(color: (BaseViewController.THEME_COLORS[theme] ?? BaseViewController.THEME_COLORS["ORANGE"])!)
        
        setNavbarColor()
    }
    
    func setCurrentAccentColor(color: UIColor) {
        navigationController?.navigationBar.barTintColor = color
    }

    
    func isDarkModeOn() -> Bool {
        let darkMode = UserDefaults.standard.bool(forKey: "darkModeOn")  as? Bool ?? true
        return darkMode
    }
    
    func setDarkMode(bool: Bool) {
        UserDefaults.standard.setValue(bool, forKey: "darkModeOn")
        toDarkMode(bool: bool)
    }
    
    func toDarkMode(bool: Bool) {
        if(bool) {
            overrideUserInterfaceStyle = .dark
        } else {
            overrideUserInterfaceStyle = .light
        }
    }
    
    func getRandomTheme() -> String {
        return BaseViewController.THEME_COLORS.keys.randomElement()!
    }
    
    func getRandomColor() -> UIColor {
        return BaseViewController.THEME_COLORS[self.getRandomTheme()] ?? BaseViewController.BURNT_ORANGE
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let isDarkOn = self.isDarkModeOn()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = isDarkOn ? .dark : .light
        } else {
            view.backgroundColor = isDarkOn ? UIColor.black : UIColor.white
        }
    }
    
    func setNavColor(color: UIColor) {
        navigationController?.navigationBar.barTintColor = color
    }
    
    
    func showSettingsScreen()
    {
        let storyBoard = UIStoryboard(name: "Settings", bundle:nil)
        let settingsScreen = storyBoard.instantiateViewController(withIdentifier: "settingsVC")
        self.navigationController?.pushViewController(settingsScreen, animated: true)
    }
    
    func showSettingsButton(show: Bool) {
        if(show) {
            navigationItem.rightBarButtonItem = UIBarButtonItem(
                image: UIImage(systemName: "gearshape"),
                style: .plain,
                target: self,
                action: #selector(buttonTappedAction)
            )
            
        } else {
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    func showProfileButton() {
        
            navigationItem.rightBarButtonItem = UIBarButtonItem(
                image: UIImage(systemName: "person.circle"),
                style: .plain,
                target: self,
                action: #selector(profileTappedAction)
            )
            
        
    }
    
    @objc func buttonTappedAction() {
        showSettingsScreen()
    }
    
    @objc func profileTappedAction() {
        showProfileScreen()
    }
    
    func showProfileScreen()
    {
       performSegue(withIdentifier: "toProfileSegue", sender: self)
    }
  }



