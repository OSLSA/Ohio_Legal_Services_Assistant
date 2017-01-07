//
//  GarnishmentViewController.swift
//  Ohio Legal Services Assistant
//
//  Created by Joshua Goodwin on 12/19/15.
//  Copyright © 2015 Ohio State Legal Services. All rights reserved.
//

import UIKit
import Firebase

class GarnishmentViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var income: UITextField!
    @IBOutlet weak var hoursPerWeek: UITextField!
    @IBOutlet weak var results: UILabel!
    @IBOutlet weak var frequency: UIPickerView!
    
    var pickerData: [String] = ["Per hour", "Per Week", "Bi-weekly", "Per month", "Annually"]
    var multiplier : Int = 26
        
        override func viewDidLoad() {
            super.viewDidLoad()
            FIRAnalytics.logEvent(withName: kFIREventSelectContent, parameters: [
                kFIRParameterContentType: "Garnishment Calculator Opened" as NSObject
                ])
            self.frequency.delegate = self
            self.frequency.dataSource = self
            frequency.selectRow(3, inComponent: 0, animated: true)
            hideHours(hidden: true)
            // Do any additional setup after loading the view.
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
    // how many columns in ui picker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // the number of rows of data in the picker view
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    /*
     func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
     return pickerData[row]
     }
     */
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let attributedString = NSAttributedString(string: pickerData[row], attributes: [NSForegroundColorAttributeName : Colors.primaryText])
        return attributedString
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (row == 0) {
            // hours
            hideHours(hidden: false)
        } else {
            hideHours(hidden: true)
        }
    }
    
    func hideHours(hidden: Bool) {
        hoursPerWeek.isHidden = hidden
    }
    

        @IBAction func clearPressed(_ sender: UIBarButtonItem) {
            
            income.text = ""
            results.text = "Results:"
            frequency.selectRow(3, inComponent: 0, animated: true)
            hoursPerWeek.isHidden = true
            
        }
        
        @IBAction func calculatePressed(_ sender: UIButton) {
            let garn = GarnishmentCalculator()
            
            garn.setVariables((income.text! as NSString).doubleValue, frequency: frequency.selectedRow(inComponent: 0), hours: (hoursPerWeek.text! as NSString).doubleValue)
            FIRAnalytics.logEvent(withName: kFIREventSelectContent, parameters: [
                kFIRParameterContentType: "Garnishment Calculated" as NSObject
                ])
            results.text = garn.getGarnishmentResults()
            
            results.lineBreakMode = .byWordWrapping
            results.numberOfLines = 0
            
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
