//
//  CountyListTableViewController.swift
//  Ohio Legal Services Assistant
//
//  Created by Joshua Goodwin on 10/2/16.
//  Copyright © 2016 Ohio State Legal Services. All rights reserved.
//

import UIKit
import Firebase

class CountyListTableViewController: UITableViewController {
    
    var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    var numberOfRows: Int = 1
    var ref: DatabaseReference!
    var names : [String] = []
    var countySelection : String = ""

    override func viewDidLoad() {
        activityIndicator.hidesWhenStopped = true;
        activityIndicator.activityIndicatorViewStyle  = UIActivityIndicatorViewStyle.gray;
        activityIndicator.center = view.center;
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        getCountyNames()
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print(numberOfRows)
        return numberOfRows
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "countyList", for: indexPath) as! CountyListTableViewCell
        print("cellForRowAt Run")
        if names.count > 0 {
            cell.countyNameLabel.text = names[indexPath.row]
            
        } else {
            cell.countyNameLabel.text = "Loading"
        }

        // Configure the cell...

        return cell
    }
    
    func refreshUI() {
        print("reload")
        DispatchQueue.main.async (execute: {
            self.tableView.reloadData()
            self.activityIndicator.stopAnimating()
        })
    }
    
    func getCountyNames() {
        var results : [String] = []
        ref = Database.database().reference()
        let query = ref.child("counties").queryOrdered(byChild: "name")
        // TODO Encapsulate the query in an NSTimer to deal with timeouts and async nature
        // don't forget activityviewindicator
        
        query.observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            var counties : [Counties] = []
            for county in snapshot.children {
                let c = Counties(snapshot: county as! DataSnapshot)
                self.names.append(c.countyName)
            }
            self.numberOfRows = self.names.count
            self.activityIndicator.stopAnimating()
            print("data loaded, and result.count = \(self.names.count) and results = \(self.names)")
            self.refreshUI()
            // ...
        }) { (error) in
            print("Firebase Error: \(error.localizedDescription)")
            self.activityIndicator.stopAnimating()
        }
    
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        countySelection = names[indexPath.row]
        self.performSegue(withIdentifier: "unwindToResources", sender: self)
        
    }

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
    }
    

}
