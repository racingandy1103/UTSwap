//
//  LandingViewController.swift
//  UTSwap
//
//  Created by Jessica Trejo on 10/29/21.
//

import UIKit
import CoreData

class LandingViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
        
     }

    func landingCoreData() {
        
        let fetchedResults = retrieveAccount()
        
    }
    
    func storeAccount(accountnameC: String, themeC:String, likedgoodsC: [NSNumber]) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let accountcore = NSEntityDescription.insertNewObject(
            forEntityName: "Account", into: context)
        
        // Set the attribute values
        accountcore.setValue(accountnameC, forKey: "accountname")
        accountcore.setValue(themeC, forKey: "theme")
        accountcore.setValue(likedgoodsC, forKey: "likedgoods")
        
        // Commit the changes
        do {
            try context.save()
        } catch {
            // If an error occurs
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
        
    }
    
    func retrieveAccount() -> [NSManagedObject] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName:"Person")
        var fetchedResults:[NSManagedObject]? = nil
        
        
        do {
            try fetchedResults = context.fetch(request) as? [NSManagedObject]
        } catch {
            // If an error occurs
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
        return(fetchedResults)!
        
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
