//
//  APRViewController.swift
//  Ohio Legal Services Assistant
//
//  Created by Joshua Goodwin on 12/19/15.
//  Copyright © 2015 Ohio State Legal Services. All rights reserved.
//

import UIKit
import Firebase

class APRViewController: UIViewController {

    @IBOutlet weak var amountBorrowed: UITextField!
    @IBOutlet weak var numberOfPayments: UITextField!
    
    @IBOutlet weak var resultsLabel: UILabel!
    @IBOutlet weak var baseRate: UITextField!
    @IBOutlet weak var costs: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
            AnalyticsParameterContentType: "APR Calculator Opened" as NSObject
            ])
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func warningPressed(_ sender: UIButton) {
        let warning = "This APR calculator is only for calculating simple APRs where there are regular payments and the payments are made monthly. If the payment period is not monthly or if there is either a different first or last payment, this calculator will not work. While tests show it is fairly accurate, the results should only be used as an estimate and should be compared against a professional calculator before using the results in court."
        let alertController = UIAlertController(title: "Warning", message: warning, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func clearPressed(_ sender: UIBarButtonItem) {
        
        amountBorrowed.text = ""
        numberOfPayments.text = ""
        costs.text = ""
        baseRate.text = ""
        resultsLabel.text = ""
    }
    
    func showAlert(alert: String) {
        let alertController = UIAlertController(title: "Missing Information", message: "The \(alert) field must be a number greater than zero", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func isAllDataEntered() -> Bool {

        guard let _ = Double(amountBorrowed.text!) else {
            showAlert(alert: "amount borrowed")
            return false
        }
        
        guard let _ = Double(numberOfPayments.text!) else {
            showAlert(alert: "number of payments")
            return false
        }
        
        let baseRateEntered = isBaseRateEntered()
        
        
        if (!baseRateEntered) {
            showAlert(alert: "base rate or number of payments")
        }

        return true
        
    }
    
    func isBaseRateEntered() -> Bool {
        guard let _ = Double(baseRate.text!) else {
            // base rate is not entered
            return false
        }
        return true
    }
    
    
    @IBAction func calculatePressed(_ sender: UIButton) {
        
        if (!isAllDataEntered()) {return}
        
        let borrowed = (amountBorrowed.text! as NSString).doubleValue
        let totalCosts = (costs.text! as NSString).doubleValue
        let rate = (baseRate.text! as NSString).doubleValue
        let numOfPays = (numberOfPayments.text! as NSString).doubleValue
        
        var result = String()
        if (isBaseRateEntered()) {
            let calculator = APRCalculator()
            calculator.setVariables(borrowed,
                                    costs: totalCosts,
                                    baseRate: rate,
                                    numberOfPayments: numOfPays)
            result = "The APR is \(calculator.getAPR())% and the monthly payment is $\(calculator.getRoundedMonthlyPayment()). The total amount paid is $\(calculator.getTotalPayments()), of which $  \(calculator.getTotalInterest()) is interest."
        }
        Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
            AnalyticsParameterContentType: "APR Calculated" as NSObject
            ])
        resultsLabel.text = result
        
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
