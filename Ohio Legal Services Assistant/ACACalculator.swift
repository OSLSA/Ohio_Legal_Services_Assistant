//
//  ACACalculator.swift
//  Ohio Legal Services Assistant
//
//  Created by Joshua Goodwin on 12/19/15.
//  Copyright © 2015 Ohio State Legal Services. All rights reserved.
//

import Foundation

class ACACalculator {
    let personalExemption = 3950
    let standardDeduction:[Int] = [6200, 12400, 6200, 9100]
    let singleAmounts:[Int] = [9075, 36900, 89350, 186350, 405100, 406750, 9999999]
    let marriedSep:[Int] = [9075, 36900, 74425, 113425, 202550, 228800, 9999999]
    let marriedJoint:[Int] = [18150, 73800, 148850, 226850, 405100, 457600, 9999999];
    let HOH:[Int] = [12950, 49400, 127550, 206600, 405100, 432200, 9999999];
    let rates:[Double] = [0.1, 0.15, 0.25, 0.28, 0.33, 0.35, 0.396]
    let medicaidStandard = 138.0
    let ptcStandard = 400.0
    
    var adjustedGrossIncome:Double = 0
    var foreignIncome: Double = 0
    var untaxedSS: Double = 0
    var taxExemptInterest: Double = 0
    var dependents:Int = 0
    var filingStatus: Int = 0
    var householdSize: Int = 0
    var fpl: FederalPovertyLevelCalculator = FederalPovertyLevelCalculator()
    
    func setVariables(_ startingValues: [Double], filing: Int) {
        
        adjustedGrossIncome = startingValues[0]
        foreignIncome = startingValues[1]
        taxExemptInterest = startingValues[2]
        untaxedSS = startingValues[3]
        dependents = Int(startingValues[4])
        setFilingStatus(filing)
        
    }
    
    func setFilingStatus(_ status: Int) {
        
        filingStatus = status
        
        switch (status) {
        case 0, 2, 3:
            householdSize = dependents + 1
            break
        case 1:
            householdSize = dependents + 2
            break
        default:
            householdSize = dependents
            break
        }
    }
    
    func getMagi() -> Double {
        return adjustedGrossIncome - foreignIncome - taxExemptInterest - untaxedSS
    }
    
    func getFPLString() -> String {
        //fpl.setValues("2015", annualIncome: getMagi(), size: householdSize)
        return fpl.getResultsString()
    }
    
    func getMedicaid() -> String {
        
        if (fpl.getResultsDouble() < medicaidStandard) {
            return "Yes"
        } else {
            return "No"
        }
        
    }
    
    func getPTC() -> String {
        if (fpl.getResultsDouble() < ptcStandard && fpl.getResultsDouble() > 100) {
            return "Yes"
        } else {
            return "No"
        }
    }
    
    func getExemptions() -> Int {
        return householdSize * personalExemption
    }
    
    func getDeductions() -> Int {
        return standardDeduction[filingStatus]
    }
    
    func getTaxableAmount() -> Double {
        let result = adjustedGrossIncome - Double(getDeductions()) - Double(getExemptions())
        if (result < 0.0) {return 0.0}
        return result
    }
    
    func getTaxOwed() -> Double {
        
        var topAmounts = getTopAmounts()
        var tempTaxable = getTaxableAmount()
        var tax = 0.0
        var i = 0;
        var priorBase = 0.0;
        while (tempTaxable > 0) {
            
            if (tempTaxable + priorBase >= Double(topAmounts[i])) {
                tax += (Double(topAmounts[i]) - priorBase) * rates[i]
                tempTaxable += priorBase - Double(topAmounts[i])
                priorBase = Double(topAmounts[i])
            } else {
                tax += tempTaxable * rates[i]
                tempTaxable = 0
            }
            i += 1;
        }
        
        return tax
    }
    
    func getTopAmounts() -> [Int] {
        
        switch (filingStatus) {
        case 0:
            return singleAmounts
        case 1:
            return marriedJoint
        case 2:
            return marriedSep
        default:
            return HOH
        }
    }
    
}
