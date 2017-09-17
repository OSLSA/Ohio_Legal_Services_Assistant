//
//  OWFViewController.swift
//  Ohio Legal Services Assistant
//
//  Created by Joshua Goodwin on 12/19/15.
//  Copyright © 2015 Ohio State Legal Services. All rights reserved.
//

import UIKit
import Firebase

class OWFViewController: UIViewController {

    
    @IBOutlet var versionButton: UIButton!
    @IBOutlet weak var agSizeLabel: UILabel!
    @IBOutlet weak var earnedIncome: UITextField!
    @IBOutlet weak var dependentCare: UITextField!
    @IBOutlet weak var deemedIncome: UITextField!
    @IBOutlet weak var unearnedIncome: UITextField!
    @IBOutlet weak var agStepper: UIStepper!
    @IBOutlet weak var results: UILabel!
    
    var version : String = Arrays.OWFVersion[0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
            AnalyticsParameterContentType: "OWF Calculator Opened" as NSObject
            ])
        versionButton.setTitle(version, for: .normal)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clearPressed(_ sender: UIBarButtonItem) {
        agSizeLabel.text = "AG Size: 1"
        agStepper.value = 1
        version = Arrays.OWFVersion[0]
        versionButton.setTitle(version, for: .normal)
        earnedIncome.text = ""
        unearnedIncome.text = ""
        dependentCare.text = ""
        deemedIncome.text = ""
        results.text = ""
    }
    
    @IBAction func versionPressed(_ sender: UIButton) {
        
        //Create the AlertController
        let actionSheetController: UIAlertController = UIAlertController(title: "Version", message: "Choose the year to calculate from", preferredStyle: .actionSheet)
        
        //Create and add the Cancel action
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            //Just dismiss the action sheet
        }
        
        for version in Arrays.OWFVersion {
            
            let newAction : UIAlertAction = UIAlertAction(title: version, style: .default) { (action:UIAlertAction) in
                self.version = version.substring(to: version.characters.index(version.startIndex, offsetBy: 10))
                self.versionButton.setTitle(version, for: .normal)
            }
            
            //let newAction
            
            actionSheetController.addAction(newAction)
            
        }
        
        //Present the AlertController
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    @IBAction func calculatePressed(_ sender: UIButton) {
        
        let ver = version.substring(to: version.characters.index(version.startIndex, offsetBy: 5))
        
        let calculator = OWFCalculator()
        
        calculator.setVariables(Int(agStepper.value),
            
            earnedIncome: (earnedIncome.text! as NSString).doubleValue,
            
            dependentCare: (dependentCare.text! as NSString).doubleValue,
            
            deemedIncome: (deemedIncome.text! as NSString).doubleValue,
            
            unearnedIncome: (unearnedIncome.text! as NSString).doubleValue,
            
            version: ver)

        Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
            AnalyticsParameterContentType: "OWF Calculated" as NSObject
            ])
        results.text = calculator.calculateOWF()
        results.lineBreakMode = .byWordWrapping
        results.numberOfLines = 0
        
    }
    
    @IBAction func stepperPressed(_ sender: UIStepper) {
        agSizeLabel.text = ("AG Size: \(Int(agStepper.value))")
    }
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
}
