//
//  RulesDetailTableViewController.swift
//  Ohio Legal Services Assistant
//
//  Created by Joshua Goodwin on 12/24/15.
//  Copyright © 2015 Ohio State Legal Services. All rights reserved.
//

import UIKit

class RulesDetailTableViewController: UITableViewController {

    var ruleNumber: String!
    var rulesTitle: String!
    var ruleArray: [String]!
    var tField: UITextField!
    var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.hidesWhenStopped = true;
        activityIndicator.activityIndicatorViewStyle  = UIActivityIndicatorViewStyle.gray;
        activityIndicator.center = view.center;
        view.addSubview(activityIndicator)
        
        // initialize array with text of rules
        ruleArray = getRuleArray()
        
        // Do any additional setup after loading the view.
        tableView.estimatedRowHeight = 68.0
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getRuleArray() -> [String] {
        let path = Bundle.main.path(forResource: rulesTitle, ofType: "plist")
        let wholeBook = NSDictionary(contentsOfFile: path!)
        activityIndicator.stopAnimating()
        return wholeBook!.object(forKey: "Rule\(ruleNumber!)") as! [String]
    }

    @IBAction func searchPressed(_ sender: AnyObject) {
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
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return ruleArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ruleCell", for: indexPath) as! RulesDetailTableViewCell

        // Configure the cell...
        let row = (indexPath as NSIndexPath).row
        let fullString = ruleArray[row]
        let secondIndex = fullString.characters.index(fullString.startIndex, offsetBy: 1)
        let partialString = fullString.substring(from: secondIndex)
        let style = NSMutableParagraphStyle()
        let firstIndex = fullString.characters.index(fullString.startIndex, offsetBy: 0)
        let familyName =  "Helvetica Neue"
        let html = "<span style=\"font-family: \(familyName); font-size:12pt;\"> \(partialString) </span>"
        let margin: CGFloat = CGFloat(("\(fullString[firstIndex])" as NSString).doubleValue)
        style.headIndent = (margin - 1) * 12.0
        style.firstLineHeadIndent = (margin - 1) * 12.0
        let para = NSMutableAttributedString()
        let attrString = try! NSMutableAttributedString(data: html.data(using: String.Encoding.unicode, allowLossyConversion: true)!,
            options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
            documentAttributes: nil)
        para.append(attrString)
        para.addAttribute(NSParagraphStyleAttributeName, value: style, range: NSRange(location: 0,length: para.length))
        cell.ruleLabel.attributedText = para
        
        return cell
    }
    
    /*override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }*/

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
