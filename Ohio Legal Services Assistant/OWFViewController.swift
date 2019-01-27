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

    
    @IBOutlet var calculateButton: UIButton!
    @IBOutlet var versionButton: UIButton!
    @IBOutlet weak var agSizeLabel: UILabel!
    @IBOutlet weak var earnedIncome: UITextField!
    @IBOutlet weak var dependentCare: UITextField!
    @IBOutlet weak var deemedIncome: UITextField!
    @IBOutlet weak var unearnedIncome: UITextField!
    @IBOutlet weak var agStepper: UIStepper!
    @IBOutlet weak var results: UILabel!
    
    var version : String = ""
    var ref: DatabaseReference!
    var values: NSDictionary!
    var versionsDict: NSDictionary!
    var versions = [String]()
    var versionKeys = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
            AnalyticsParameterContentType: "OWF Calculator Opened" as NSObject
            ])
        isConnected { (connected) in
            if(connected){
                self.setUp()
            } else {
                if (self.versions.count > 0) {
                    self.setUp()
                } else {
                    func showAlert(alert: String) {
                        let alertController = UIAlertController(title: "Connection Required", message: "In order to access this form, you need an internet connection. Once accessed, it will then be available offline", preferredStyle: .alert)
                        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alertController.addAction(defaultAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                    showAlert(alert: "ALERT")
                    self.calculateButton.isEnabled = false
                    self.versionButton.isEnabled = false
                }
            }
        }
        
    }
    
    private func setUp() {
        ref = Database.database().reference()
        let mOWFRef = ref.child("OWF")
        mOWFRef.observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            self.values = (snapshot.value as? NSDictionary)!
            self.versionsDict = self.values.value(forKey: "Versions") as? NSDictionary
            self.setVersions()
        }) { (error) in
            print(error.localizedDescription)
        }
        
        versionButton.setTitle(version, for: .normal)
        // Do any additional setup after loading the view.
    }
    
    private func isConnected(completionHandler : @escaping (Bool) -> ()) {
        let connectedRef = Database.database().reference(withPath: ".info/connected")
        connectedRef.observe(.value, with: { snapshot in
            completionHandler((snapshot.value as? Bool)!)
        })
    }
    
    func setVersions() {
        
        var unsortedVersions = [String]()
        for (key, value) in versionsDict {
            unsortedVersions.append((key as? String)!)
        }
        versionKeys = unsortedVersions.sorted(by: >)
        for (key) in versionKeys {
            versions.append((versionsDict.object(forKey: key) as? String)!)
        }
        version = versions[0]
        versionButton.setTitle(version, for: .normal)
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clearPressed(_ sender: UIBarButtonItem) {
        agSizeLabel.text = "AG Size: 1"
        agStepper.value = 1
        version = versions[0]
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
        
        for version in versions {
            
            let newAction : UIAlertAction = UIAlertAction(title: version, style: .default) { (action:UIAlertAction) in
                self.version = version
                self.versionButton.setTitle(version, for: .normal)
            }
            
            //let newAction
            
            actionSheetController.addAction(newAction)
            
        }
        
        //Present the AlertController
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    @IBAction func calculatePressed(_ sender: UIButton) {

        let i: Int = versions.firstIndex(of: version)!
        let verKey: String = versionKeys[i]
        
        
        let calculator = OWFCalculator()
        
        calculator.setVariables(Int(agStepper.value),
            
            earnedIncome: (earnedIncome.text! as NSString).doubleValue,
            
            dependentCare: (dependentCare.text! as NSString).doubleValue,
            
            deemedIncome: (deemedIncome.text! as NSString).doubleValue,
            
            unearnedIncome: (unearnedIncome.text! as NSString).doubleValue,
            
            versionKey: verKey,
            
            constants: values)

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
