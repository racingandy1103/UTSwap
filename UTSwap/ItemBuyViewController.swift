//
//  ItemBuyViewController.swift
//  UTSwap
//
//  Created by Jessica Trejo on 10/29/21.
//

import UIKit

class ItemBuyViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func buyPressed(_ sender: Any) {
        
        // create an object that holds the data for our notification
        let notification = UNMutableNotificationContent()
        notification.title = "Purchase Complete"
        notification.subtitle = "Purchase Details"
        notification.body = "Your purchase has succesfully completed!"
        
        // set up the notification's trigger
        let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 30, repeats: false)
        
        // set up a request to tell iOS to submit the notification with that trigger
        let request = UNNotificationRequest(identifier: "notification2",
                                            content: notification,
                                            trigger: notificationTrigger)
        
        
        // submit the request to iOS
        UNUserNotificationCenter.current().add(request) { (error) in
            print("Request error: ",error as Any)
        }
        print("Submitted")
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
