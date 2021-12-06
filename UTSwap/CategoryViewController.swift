//
//  CategoryViewController.swift
//  UTSwap
//
//  Created by Andy Hsieh on 2021/11/24.
//

import UIKit



class CategoryViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    

    @IBOutlet weak var categoryTableView: UITableView!
    
    let textCellIdentifier = "TextCell"
    let feedSegueIdentifier = "FeedSegueIdentifier"
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = categoryTableView.dequeueReusableCell(withIdentifier: textCellIdentifier, for: indexPath)
        let row = indexPath.row
        cell.textLabel?.text = categories[row]
        cell.textLabel?.font = UIFont(name:"Courier",size:15)
        return cell
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == feedSegueIdentifier,
           let destination = segue.destination as? FeedViewController,
           let categoryIndex = categoryTableView.indexPathForSelectedRow?.row {
            destination.categoryName = categories[categoryIndex]
        }
    }
}
