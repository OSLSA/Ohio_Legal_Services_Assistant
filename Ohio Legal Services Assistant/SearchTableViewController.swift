//
//  SearchTableViewController.swift
//  Ohio Legal Services Assistant
//
//  Created by Joshua Goodwin on 5/29/16.
//  Copyright © 2016 Ohio State Legal Services. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController {

    var rulesTitle: String!
    var rulesTOC: [String]!
    var searchTerm: String!
    var wholeBook: NSDictionary!
    var foundRules: [[String]]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // get the entire rulebook to be searched
        getDictionary()
        
        // get the list of rules to be searched fromt he TOC
        rulesTOC = getRulesTOC()
        
        // perform search and return results as String[][]
        foundRules = findRulesWithTerm()
        
        // see if array is empty (no hits on search), add messages if empty
        if (foundRules.isEmpty) {
            foundRules.append(["  ", "  ", " No results were found for your search for \(searchTerm)"])
        }
        tableView.estimatedRowHeight = 68.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Do any additional setup after loading the view.
        tableView.estimatedRowHeight = 68.0
        tableView.rowHeight = UITableViewAutomaticDimension

    }
    
    func getDictionary() {
        let path = Bundle.main.path(forResource: rulesTitle, ofType: "plist")
        wholeBook = NSDictionary(contentsOfFile: path!)
    }
    
    func getRulesTOC() -> [String] {
        let toc = wholeBook.object(forKey: "TableOfContents") as! [String]
        var ruleNumbers: [String] = []
        for rule in toc {
            let number = ((rule as NSString).doubleValue)
            let strNumber = (number.truncatingRemainder(dividingBy: 1) == 0) ? String(Int(number)) : String (number)
            ruleNumbers.append(strNumber)
        }
        return ruleNumbers
    }
    
    func findRulesWithTerm() -> [[String]] {
        var results = [[String]]()
        for rule in rulesTOC {
            // array with the individual rule in it
            let individualRule = wholeBook!.object(forKey: "Rule\(rule)") as! [String]
            
            for line in individualRule {
                let test = runSearch(line)
                if (test) {
                    // search turned up a result, so save and break
                    // [rule number, line word found, rule title
                    let searcHit: [String] = [rule, line, individualRule[0]]
                    results.append(searcHit)
                    break
                }
            }
            
        }
        return results
    }
    
    func runSearch(_ rule: String) -> Bool {
        let modSearch = searchTerm.lowercased()
        let modRule = rule.lowercased()
        return modRule.contains(modSearch)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return foundRules.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! SearchTableViewCell

        // Configure the cell...
        let row = (indexPath as NSIndexPath).row
        cell.searchCell.attributedText = formatForHTML(foundRules[row][2])
        cell.searchCellDetail.attributedText = formatForHTML(foundRules[row][1])

        return cell
    }
    
    func formatForHTML(_ text: String) -> NSMutableAttributedString {
        let startingIndex = text.characters.index(text.startIndex, offsetBy: 1)
        let ruleDetail = text.substring(from: startingIndex)
        let familyName =  "Helvetica Neue"
        let html = "<span style=\"font-family: \(familyName); font-size:12pt;\"> \(ruleDetail) </span>"
        let style = NSMutableParagraphStyle()
        style.headIndent = 12.0
        style.firstLineHeadIndent = 12.0
        let para = NSMutableAttributedString()
        let attrString = try! NSMutableAttributedString(data: html.data(using: String.Encoding.unicode, allowLossyConversion: true)!, options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
        para.append(attrString)
        para.addAttribute(NSParagraphStyleAttributeName, value: style, range: NSRange(location: 0,length: para.length))
        return para
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRule = foundRules[(indexPath as NSIndexPath).row][0]
        if selectedRule == "  " {
            return
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let destination = storyboard.instantiateViewController(withIdentifier: "RulesDetail") as! RulesDetailTableViewController
            destination.rulesTitle = rulesTitle
            destination.ruleNumber = selectedRule
            navigationController?.pushViewController(destination, animated: true)
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
