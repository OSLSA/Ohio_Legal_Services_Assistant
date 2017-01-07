//
//  RulesToCTableViewController.swift
//  Ohio Legal Services Assistant
//
//  Created by Joshua Goodwin on 12/25/15.
//  Copyright © 2015 Ohio State Legal Services. All rights reserved.
//

import UIKit

class RulesToCTableViewController: UITableViewController {

    var rulesTitle: String!
    var tocDict = NSDictionary()
    var sortedToC = [String]()
    var ToCText = [String]()
    var tField: UITextField!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        // get Table of Contents for Selected Rule set
        let path = Bundle.main.path(forResource: rulesTitle, ofType: "plist")
        let wholeBook = NSDictionary(contentsOfFile: path!)
        ToCText = wholeBook!.object(forKey: "TableOfContents") as! [String]
        //tocDict = wholeBook!.objectForKey("TableOfContents") as! NSDictionary
        sortedToC = getToCKeys(ToCText)
//        sortedToC = unsorted.sort({ (str1, str2) -> Bool in
//            Int(str1) < Int(str2)
//        })
        tableView.estimatedRowHeight = 68.0
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getToCKeys(_ unsortedToC: [String]) -> [String] {
        var keys: [String] = []
        for key in unsortedToC {
            let number = ((key as NSString).doubleValue)
            let strKey = (number.truncatingRemainder(dividingBy: 1) == 0) ? String(Int(number)) : String(number)
            keys.append(strKey)
        }
        return keys
    }

    @IBAction func searchPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Search", message: "Enter your search term. This is a simple text search only. Please do not use special characters or wildcards.", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addTextField(configurationHandler: configurationTextField)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler:handleCancel))
        alert.addAction(UIAlertAction(title: "Search", style: UIAlertActionStyle.default, handler:{ (UIAlertAction)in
            print("Done !!")
            print("Item : \(self.tField.text)")
            self.searchSegue(self.tField.text!)
        }))
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
        
    }
    
    func searchSegue(_ searchTerm: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let destination = storyboard.instantiateViewController(withIdentifier: "SearchTableViewController") as! SearchTableViewController
        destination.rulesTitle = rulesTitle
        destination.searchTerm = searchTerm
        
        navigationController?.pushViewController(destination, animated: true)
    }
    
    
    func configurationTextField(_ textField: UITextField!)
    {
        print("generating the TextField")
        textField.placeholder = "Search term"
        tField = textField
    }
    
    
    func handleCancel(_ alertView: UIAlertAction!)
    {
        print("Cancelled !!")
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sortedToC.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 
        let cell = tableView.dequeueReusableCell(withIdentifier: "rulesToCCell", for: indexPath) as! RulesToCTableViewCell

        // Configure the cell...
        let row = (indexPath as NSIndexPath).row
//        let key: String = sortedToC[row]
        cell.rulesLabel.text = ToCText[row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle  = UIActivityIndicatorViewStyle.gray
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        let selectedRule = sortedToC[(indexPath as NSIndexPath).row]
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let destination = storyboard.instantiateViewController(withIdentifier: "RulesDetail") as! RulesDetailTableViewController
        destination.rulesTitle = rulesTitle
        destination.ruleNumber = selectedRule
        activityIndicator.stopAnimating()
        navigationController?.pushViewController(destination, animated: true)
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
