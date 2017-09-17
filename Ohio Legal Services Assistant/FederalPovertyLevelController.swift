//
//  FederalPovertyLevelController.swift
//  Ohio Legal Services Assistant
//
//  Created by Joshua Goodwin on 12/15/15.
//  Copyright © 2015 Ohio State Legal Services. All rights reserved.
//


import UIKit
import Firebase

class FederalPovertyLevelViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet var hours: UITextField!
    @IBOutlet weak var versionController: UISegmentedControl!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var resultsLabel: UILabel!
    @IBOutlet var agStepper: UIStepper!
    @IBOutlet var annualIncome: UITextField!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet var hoursLabel: UILabel!
    
    var pickerData: [String] = ["Per hour", "Per Week", "Bi-weekly", "Per month", "Annually"]
    var multiplier: Int = 12
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
            AnalyticsParameterContentType: "FPL Calculator Opened" as NSObject
            ])
        sizeLabel.textColor = Colors.primaryText
        versionController.tintColor = Colors.primaryText
        resultsLabel.textColor = Colors.primaryText
        hoursLabel.textColor = Colors.primaryText
        agStepper.tintColor = Colors.primaryText
        self.picker.delegate = self
        self.picker.dataSource = self
        picker.selectRow(3, inComponent: 0, animated: true)
        hideHours(hidden: true)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func stepperPressed(_ sender: UIStepper) {
        sizeLabel.text = "Household Size: \(Int(agStepper.value))"
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
    
    // set the multiplier variable so that the income reported is annual
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch row {
        case 0:
            multiplier = 52
            hideHours(hidden: false)
            break
        case 1:
            multiplier = 52
            hideHours(hidden: true)
            break
        case 2:
            multiplier = 26
            hideHours(hidden: true)
            break
        case 3:
            multiplier = 12
            hideHours(hidden: true)
            break
        default:
            multiplier = 1
            hideHours(hidden: true)
            break
        }
    }
    
    func hideHours(hidden: Bool) {
        hours.isHidden = hidden
        hoursLabel.isHidden = hidden
    }
    
    func dataIsMissing() -> Bool {
        // see if income entered, alert if not
        guard let _ = Double(annualIncome.text!) else {
            // not a number or negative number, so no good
            showAlert(alert: "income")
            return true
        }
        if (picker.selectedRow(inComponent: 0) == 0) {
            // have to validate hours
            guard let _ = Double(hours.text!) else {
                // hours displayed but no hours entered
                showAlert(alert: "hours")
                return true
            }
        }
        
        return false
    }
    
    func showAlert(alert: String) {
        let alertController = UIAlertController(title: "Missing Information", message: "The \(alert) field must be a number greater than zero", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func clearPressed(_ sender: UIBarButtonItem) {
        picker.selectRow(3, inComponent: 0, animated: true)
        multiplier = 12
        annualIncome.text = ""
        resultsLabel.text = "Percentage of Poverty:"
        agStepper.value = 1
        sizeLabel.text = "Household Size: 1"
        hours.text = ""
        hideHours(hidden: true)
        versionController.selectedSegmentIndex = 2
    }
    
    @IBAction func calculatePressed(_ sender: UIButton) {
        // validate enough information is entered
        if (dataIsMissing()) {return}
    
        var baseIncome: Double
        // check to see if pay is hourly and multiply by hours if needed
        if (picker.selectedRow(inComponent: 0) == 0) {
            baseIncome = (annualIncome.text! as NSString).doubleValue * (hours.text! as NSString).doubleValue
        } else {
            baseIncome = (annualIncome.text! as NSString).doubleValue
        }
        
        let income = baseIncome * Double(multiplier)
        let fpl = FederalPovertyLevelCalculator()
        fpl.setValues(versionController.titleForSegment(at: versionController.selectedSegmentIndex)!,
            annualIncome: income,
            size: Int(agStepper.value))
        Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
            AnalyticsParameterContentType: "APR Calculator calculated" as NSObject
            ])
        resultsLabel.text = "Percentage of Poverty: \(fpl.getResultsString())%"
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
