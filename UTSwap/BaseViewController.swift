//
//  NavigationViewController.swift
//  UTSwap
//
//  Created by Jessica Trejo on 10/29/21.
//

import UIKit

public let categories = [
    "Furniture", "Clothing", "Electronics", "Book",
    "Misc."
]

class BaseViewController: UIViewController {
    
    var currentColor: UIColor = .lightGray
    
    
    public static let THEME_COLORS = [
        "BLUE": UIColor.blue,
        "RED": UIColor.red,
        "SYSTEM_PINK": UIColor.systemPink,
        "WHITE": UIColor.white,
        "CYAN": UIColor.cyan,
        "ORANGE": UIColor.orange,
        "GRAY": UIColor.gray
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        navigationController?.navigationBar.barTintColor = getCurrentAccentColor()
        
        if(navigationItem.rightBarButtonItem == nil) {
            showSettingsButton(show: true)
        }
    }
    
    func getThemeName() -> String {
        return UserDefaults.standard.string(forKey: "accentColor") ?? "ORANGE"
    }
        
    func getCurrentAccentColor() -> UIColor {
        let key = UserDefaults.standard.string(forKey: "accentColor")
        return BaseViewController.THEME_COLORS[key ?? "BLUE"]!
    }
    
    
    func setTheme(theme: String) {
        let _: Void = UserDefaults.standard.setValue(theme, forKey: "accentColor")

        setCurrentAccentColor(color: (BaseViewController.THEME_COLORS[theme] ?? BaseViewController.THEME_COLORS["BLUE"])!)
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
    
    @objc func buttonTappedAction() {
        showSettingsScreen()
    }

  }


