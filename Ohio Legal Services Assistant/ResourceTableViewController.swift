//
//  ResourceTableViewController.swift
//  Ohio Legal Services Assistant
//
//  Created by Joshua Goodwin on 9/28/16.
//  Copyright © 2016 Ohio State Legal Services. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ResourceTableViewController: UITableViewController {

    let sectionNames : [String] = ["Filters", "Results"]
    let firstSectionTitles : [String] = ["County: ", "Category: "]
    var categorySelected : String = "All"
    var countySelected : String = "All"
    var numberOfRows : Int = 0
    var ref: DatabaseReference!
    var allResources : [LocalResource] = []
    var resourceNames : [String] = []
    var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    var loaded : Bool = false
    let noResults : String = "Sorry, no resources found"
    
    override func viewDidLoad() {
        Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
            AnalyticsParameterContentType: "Local Resources Opened" as NSObject
            ])
        super.viewDidLoad()
        activityIndicator.hidesWhenStopped = true;
        activityIndicator.activityIndicatorViewStyle  = UIActivityIndicatorViewStyle.gray;
        activityIndicator.center = view.center;
        view.addSubview(activityIndicator)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

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
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0:
            return 2
        case 1:
            if (numberOfRows == 0) {
                return 1
            } else {
                return numberOfRows
            }
        default:
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionNames[section]
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resourcesIdentifier", for: indexPath) as! ResourcesTableViewCell

        // Configure the cell...
        let section = indexPath.section
        let row = indexPath.row
        var name = ""
        var detail = ""
        let filters: [String] = [countySelected, categorySelected]
        switch section {
        case 0:
            name = "\(firstSectionTitles[row])\(filters[row])"
            detail = ""
        default:
            if (countySelected != "All") {
                if self.loaded == true {
                 name = resourceNames[row]
                } else {
                    name = "Loading..."
                }
                detail = ""
                cell.accessoryType = .detailButton
                cell.isUserInteractionEnabled = true
                
            } else {
                name = "You must select a county first"
                detail = ""
                cell.accessoryType = .none
                cell.selectionStyle = .none
                cell.isUserInteractionEnabled = false
            }
        }
        cell.detailTitle.text = detail
        cell.cellTitle.text = name
        if (name == noResults) {
            print(noResults)
            cell.isUserInteractionEnabled = false
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                let destination = storyboard.instantiateViewController(withIdentifier: "CountyList") as! CountyListTableViewController
                navigationController?.pushViewController(destination, animated: true)
            default:
                let destination = storyboard.instantiateViewController(withIdentifier: "CategoryScene") as! CategoriesTableViewController
                navigationController?.pushViewController(destination, animated: true)
            }
        default:
            let destination = storyboard.instantiateViewController(withIdentifier: "ResourceDetail") as! ResourceDetailViewController
            destination.resource = allResources[indexPath.row]
            navigationController?.pushViewController(destination, animated: true)
        }
        
    }
    
    @IBAction func unwindToResources(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? CountyListTableViewController {
            self.countySelected = sourceViewController.countySelection
            loaded=false
            getResources()
            tableView.reloadData()
        }
    }
    
    @IBAction func unwindFromCategories(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? CategoriesTableViewController {
            self.categorySelected = sourceViewController.categorySelected
            getResources()
            tableView.reloadData()
        }
    }
    
    func getResources() {
        activityIndicator.startAnimating()
        var results : [String] = []
        ref = Database.database().reference().child("entities")
        let query = ref.queryOrdered(byChild: "county").queryEqual(toValue: countySelected)
        query.observeSingleEvent(of: .value, with: {(snapshot) in
            self.allResources.removeAll()
            self.resourceNames.removeAll()
            for resource in snapshot.children {
                let r = LocalResource(snapshot: resource as! DataSnapshot)
                if (self.categorySelected == "All" || self.categorySelected == r.category) {
                    self.allResources.append(r)
                    self.resourceNames.append(r.name)
                }
            }
            if self.resourceNames.count < 1 {
                self.resourceNames.append(self.noResults)
            }
            self.numberOfRows = self.resourceNames.count
            self.refreshUI()
            
        }) { (error) in
            print("FIREBASE ERROR")
        }
    }
    
    func refreshUI() {
        print("reload")
        DispatchQueue.main.async (execute: {
            self.loaded = true
            self.tableView.reloadData()
            self.activityIndicator.stopAnimating()
            
        })
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

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


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
    }
 */
    

}
