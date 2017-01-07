//
//  FoodStampsTableViewController.swift
//  Ohio Legal Services Assistant
//
//  Created by Ohio State Legal Services on 1/6/16.
//  Copyright © 2016 Ohio State Legal Services. All rights reserved.
//

import UIKit
import Firebase

class FoodStampsTableViewController: UITableViewController {
    
    @IBOutlet weak var agSizeLabel: UILabel!
    @IBOutlet weak var agSizeStepper: UIStepper!
    @IBOutlet weak var agedBlindDisabledSwitch: UISwitch!
    @IBOutlet weak var categoricalEligibilitySwitch: UISwitch!
    @IBOutlet weak var earnedIncome: UITextField!
    @IBOutlet weak var unearnedIncome: UITextField!
    @IBOutlet weak var rent: UITextField!
    @IBOutlet weak var propertyTaxes: UITextField!
    @IBOutlet weak var propertyInsurance: UITextField!
    @IBOutlet weak var dependentCare: UITextField!
    @IBOutlet weak var childSupport: UITextField!
    @IBOutlet weak var medicalExpenses: UITextField!
    @IBOutlet weak var homelessSwitch: UISwitch!
    @IBOutlet weak var heatingSwitch: UISwitch!
    @IBOutlet weak var electricSwitch: UISwitch!
    @IBOutlet weak var waterSwitch: UISwitch!
    @IBOutlet weak var garbageSwitch: UISwitch!
    @IBOutlet weak var phoneSwitch: UISwitch!
    @IBOutlet weak var results: UILabel!
    @IBOutlet weak var buttonVersion: UIButton!
    
    var version : String = Arrays.foodStampVersions[0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FIRAnalytics.logEvent(withName: kFIREventSelectContent, parameters: [
            kFIRParameterContentType: "Food Stamps Calculator Opened" as NSObject
            ])
        buttonVersion.setTitle(Arrays.foodStampVersions[0], for : .normal)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func agedBlindDisabledSwitched(_ sender: UISwitch) {
        
        //TODO toggle medical line
        if (agedBlindDisabledSwitch.isOn) {
            // enable medical expenses
            medicalExpenses.isEnabled = true
        } else {
            //disable medical expenses
            medicalExpenses.isEnabled = false
        }
    }
    
    @IBAction func calculatePressed(_ sender: UIButton) {
        
        let calculator = FoodStampCalculator()
        
        //let tempVersion = versionSegmentControl.titleForSegment(at: versionSegmentControl.selectedSegmentIndex)
        
        //let version = tempVersion!.substring(to: tempVersion!.characters.index(tempVersion!.startIndex, offsetBy: 10))
        print(version)
        let variables: [String: Any] = ["agedBlindDisabled": agedBlindDisabledSwitch.isOn,
            "earnedIncome": earnedIncome.text!,
            "unearnedIncome": unearnedIncome.text!,
            "agSize": Int(agSizeStepper.value),
            "medicalExpenses": medicalExpenses.text!,
            "dependentCare": dependentCare.text!,
            "childSupport": childSupport.text!,
            "isHomeless": homelessSwitch.isOn,
            "rent": rent.text!,
            "propertyInsurance": propertyInsurance.text!,
            "propertyTaxes": propertyTaxes.text!,
            "categoricallyEligible": categoricalEligibilitySwitch.isOn,
            "phone": phoneSwitch.isOn,
            "heating": heatingSwitch.isOn,
            "electric": electricSwitch.isOn,
            "water": waterSwitch.isOn,
            "garbage": garbageSwitch.isOn,
            "version": version]

        calculator.setVariables(variables)
        FIRAnalytics.logEvent(withName: kFIREventSelectContent, parameters: [
            kFIRParameterContentType: "Food Stamps Calculated" as NSObject
            ])
        results.text = "\(calculator.returnResults())"
        
    }
    
    @IBAction func agSizePressed(_ sender: UIStepper) {
        
        agSizeLabel.text = "AG Size: \(Int(sender.value))"
    }

    @IBAction func versionPressed(_ sender: UIButton) {
        
         //Create the AlertController
         let actionSheetController: UIAlertController = UIAlertController(title: "Version", message: "Choose the year to calculate from", preferredStyle: .actionSheet)
         
         //Create and add the Cancel action
         let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
         //Just dismiss the action sheet
         }
         
         for version in Arrays.foodStampVersions {
         
            let newAction : UIAlertAction = UIAlertAction(title: version, style: .default) { (action:UIAlertAction) in
                self.version = version.substring(to: version.characters.index(version.startIndex, offsetBy: 10))
                self.buttonVersion.setTitle(version, for: .normal)
            }
            
            //let newAction
            
            actionSheetController.addAction(newAction)
         
         }
        
         //Present the AlertController
         self.present(actionSheetController, animated: true, completion: nil)
        
    }
  

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 20
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
