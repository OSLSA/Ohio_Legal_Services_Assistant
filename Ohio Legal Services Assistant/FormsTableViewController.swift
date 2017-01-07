//
//  FormsTableViewController.swift
//  Ohio Legal Services Assistant
//
//  Created by Joshua Goodwin on 3/26/16.
//  Copyright © 2016 Ohio State Legal Services. All rights reserved.
//

import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}


class FormsTableViewController: UITableViewController {

    var formDictionary = [String: String]() // formn name : file name
    var formNames = [String]()
    let sectionNames: [String] = ["Viewable", "Fillable"]
    let secondSectionTitles: [String] = ["Living Will/Health Care POA", "Durable POA"]
    let urls: [String] = ["https://lawhelpinteractive.org/Interview/InterviewHome?templateId=5718", "https://lawhelpinteractive.org/Interview/InterviewHome?templateId=5720"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // TODO in the long run, will need to set this up to pull user added forms
        formDictionary["Medicaid Help Sheet"] = "medicaid_help_sheet"
        formDictionary["Benefits Help Sheet"] = "standards_help_sheet"

        // get form names and sort them
        let unsortedNames = [String](formDictionary.keys)
        formNames = unsortedNames.sorted(by: { (str1, str2) -> Bool in
            Int(str1) < Int(str2)
        })
        
        // TODO consider uncommenting this to run the editor from here
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return formNames.count
        case 1:
            return secondSectionTitles.count
        default:
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionNames[section]
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // cel configuration
        let cell = tableView.dequeueReusableCell(withIdentifier: "formsCell", for: indexPath) as! FormsTableViewCell
        let section = indexPath.section
        let row = (indexPath as NSIndexPath).row
        var name = ""
        switch section {
        case 0:
            name = formNames[row]
            
        default:
            name = secondSectionTitles[row]
        }
        cell.formsCell.text = name

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let section = indexPath.section
        let row = indexPath.row
        switch section {
            
        case 0:
            let selectedForm = formNames[(indexPath as NSIndexPath).row]
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let destination = storyboard.instantiateViewController(withIdentifier: "FormViewerScene") as! FormsDetailViewController
            destination.formName = selectedForm
            destination.fileName = formDictionary[selectedForm]!
            navigationController?.pushViewController(destination, animated: true)
        default:
            let url = URL(string: urls[row])!
            UIApplication.shared.openURL(url)
        }
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
