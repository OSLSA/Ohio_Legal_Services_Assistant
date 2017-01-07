//
//  ACAViewController.swift
//  Ohio Legal Services Assistant
//
//  Created by Joshua Goodwin on 12/19/15.
//  Copyright © 2015 Ohio State Legal Services. All rights reserved.
//

import UIKit
import Firebase

class ACAViewController: UIViewController {

    @IBOutlet weak var motherAGI: UITextField!
    @IBOutlet weak var motherExcludedForeignIncome: UITextField!
    @IBOutlet weak var motherTaxEemptInterest: UITextField!
    @IBOutlet weak var motherUntaxedSS: UITextField!
    @IBOutlet weak var motherFilingStatus: UISegmentedControl!
    @IBOutlet weak var motherDependentsLabel: UILabel!
    @IBOutlet weak var fatherAGI: UITextField!
    @IBOutlet weak var fatherExemptInterest: UITextField!
    @IBOutlet weak var fatherExemptForeignInterest: UITextField!
    @IBOutlet weak var fatherUntaxedSS: UITextField!
    @IBOutlet weak var fatherFilingStatus: UISegmentedControl!
    @IBOutlet weak var fatherDependentsLabel: UILabel!
    @IBOutlet weak var motherMAGI: UILabel!
    @IBOutlet weak var fatherMAGI: UILabel!
    @IBOutlet weak var motherFPL: UILabel!
    @IBOutlet weak var fatherFPL: UILabel!
    @IBOutlet weak var motherStdDeduct: UILabel!
    @IBOutlet weak var fatherStdDeduct: UILabel!
    @IBOutlet weak var motherExemptions: UILabel!
    @IBOutlet weak var fatherExemptions: UILabel!
    @IBOutlet weak var motherTaxableIncome: UILabel!
    @IBOutlet weak var fatherTaxableIncome: UILabel!
    @IBOutlet weak var motherTaxOwed: UILabel!
    @IBOutlet weak var fatherTaxOwed: UILabel!
    @IBOutlet weak var motherMedicaid: UILabel!
    @IBOutlet weak var fatherMedicaid: UILabel!
    @IBOutlet weak var motherPTC: UILabel!
    @IBOutlet weak var fatherPTC: UILabel!
    @IBOutlet weak var fatherDependentsStepper: UIStepper!
    @IBOutlet weak var motherDependentsStepper: UIStepper!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FIRAnalytics.logEvent(withName: kFIREventSelectContent, parameters: [
            kFIRParameterContentType: "ACA Calculator Opened" as NSObject
            ])
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func motherDependentsStepperPressed(_ sender: UIStepper) {
        
        switch (sender) {
            
        case motherDependentsStepper:
            motherDependentsLabel.text = "Dependents: \(Int(sender.value))"
            break
        case fatherDependentsStepper:
            fatherDependentsLabel.text = "Dependents: \(Int(sender.value))"
            break
        default:
            break
        }
    }
    
    @IBAction func calculatePressed(_ sender: UIButton) {
        
        let motherACA = ACACalculator()
        let motherInformation = [(motherAGI.text! as NSString).doubleValue,
            (motherExcludedForeignIncome.text! as NSString).doubleValue,
            (motherTaxEemptInterest.text! as NSString).doubleValue,
            (motherUntaxedSS.text! as NSString).doubleValue,
            motherDependentsStepper.value]
        
        motherACA.setVariables(motherInformation, filing: motherFilingStatus.selectedSegmentIndex)
        
        let fatherACA = ACACalculator()
        let fatherInformation = [(fatherAGI.text! as NSString).doubleValue,
            (fatherExemptForeignInterest.text! as NSString).doubleValue,
            (fatherExemptInterest.text! as NSString).doubleValue,
            (fatherUntaxedSS.text! as NSString).doubleValue,
            fatherDependentsStepper.value]
        fatherACA.setVariables(fatherInformation, filing: fatherFilingStatus.selectedSegmentIndex)
        FIRAnalytics.logEvent(withName: kFIREventSelectContent, parameters: [
            kFIRParameterContentType: "ACA Calculator Checked" as NSObject
            ])
        displayResults(fatherACA, mother: motherACA)
        
    }
    
    func displayResults(_ father: ACACalculator, mother: ACACalculator) {
        motherMAGI.text = "\(Int(mother.getMagi()))"
        fatherMAGI.text = "\(Int(father.getMagi()))"
        motherFPL.text = "\(mother.getFPLString())"
        fatherFPL.text = "\(father.getFPLString())"
        motherMedicaid.text = "\(mother.getMedicaid())"
        fatherMedicaid.text = "\(father.getMedicaid())"
        motherExemptions.text = "\(mother.getExemptions())"
        fatherExemptions.text = "\(father.getExemptions())"
        fatherStdDeduct.text = "\(father.getDeductions())"
        motherStdDeduct.text = "\(mother.getDeductions())"
        motherPTC.text = "\(mother.getPTC())"
        fatherPTC.text = "\(father.getPTC())"
        motherTaxableIncome.text = "\(Int(mother.getTaxableAmount()))"
        fatherTaxableIncome.text = "\(Int(father.getTaxableAmount()))"
        motherTaxOwed.text = "\(Int(mother.getTaxOwed()))"
        fatherTaxOwed.text = "\(Int(father.getTaxOwed()))"
    }
    
    @IBAction func clearPressed (_ sender: UIBarButtonItem) {
        motherMAGI.text = " "
        fatherMAGI.text = " "
        motherFPL.text = " "
        fatherFPL.text = " "
        motherMedicaid.text = " "
        fatherMedicaid.text = " "
        motherExemptions.text = " "
        fatherExemptions.text = " "
        fatherStdDeduct.text = " "
        motherStdDeduct.text = " "
        motherPTC.text = " "
        fatherPTC.text = " "
        motherTaxableIncome.text = " "
        fatherTaxableIncome.text = " "
        motherTaxOwed.text = " "
        fatherTaxOwed.text = " "
        motherAGI.text = ""
        motherExcludedForeignIncome.text = ""
        motherTaxEemptInterest.text = ""
        motherUntaxedSS.text = ""
        motherFilingStatus.selectedSegmentIndex = 0
        motherDependentsLabel.text = "Dependents: 0"
        fatherAGI.text = ""
        fatherExemptInterest.text = ""
        fatherExemptForeignInterest.text = ""
        fatherUntaxedSS.text = ""
        fatherFilingStatus.selectedSegmentIndex = 0
        fatherDependentsLabel.text = "Dependents: 0"
        fatherDependentsStepper.value = 0
        motherDependentsStepper.value = 0
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
