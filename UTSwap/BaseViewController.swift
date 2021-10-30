//
//  NavigationViewController.swift
//  UTSwap
//
//  Created by Jessica Trejo on 10/29/21.
//

import UIKit

class BaseViewController: UIViewController {
    
    var currentColor: UIColor = .lightGray
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barTintColor = currentColor
        
        if(navigationItem.rightBarButtonItem == nil) {
            showSettingsButton(show: true)
        }
        
       

    }
        
    func getCurrentAccentColor() -> UIColor {
        return self.currentColor
    }
    
    func setCurrentAccentColor(color: UIColor) {
        self.currentColor = color
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
