//
//  OWFCalculator.swift
//  Ohio Legal Services Assistant
//
//  Created by Joshua Goodwin on 12/19/15.
//  Copyright © 2015 Ohio State Legal Services. All rights reserved.
//

import Foundation

class OWFCalculator {
    var constants: NSDictionary?
    var agSize = Int()
    var earnedIncome = Double()
    var dependentCare = Double()
    var deemedIncome = Double()
    var unearnedIncome = Double()
    var version = ""
    
    init() { }
    
    func setVariables(_ agSize: Int, earnedIncome: Double, dependentCare: Double, deemedIncome: Double, unearnedIncome: Double, version: String) {
        
        self.agSize = agSize
        self.deemedIncome = deemedIncome
        self.dependentCare = dependentCare
        self.earnedIncome = earnedIncome
        self.unearnedIncome = unearnedIncome
        self.version = version
        
        let text = "OWF\(version)"
        if let path = Bundle.main.path(forResource: text, ofType:"plist")
        {
            constants = NSDictionary(contentsOfFile: path)
            
        }
        
    }
    
    func calculateOWF() -> String {
        
        if (!initialEligibilityPassed()) {
            // failed initial eligibility test
            return "Ineligible as the gross earned income of $\(getGrossIncome()) exceeds the initial eligibility standard of $\(getInitialEligibilityStandard())"
        }
        
        if (countableIncomeBelowStandard()) {
            // eligible for OWF
            let amountOfPayment = getPaymentAmount()
            return "Eligible for OWF in the amount of $\(amountOfPayment) per month"
        } else {
            // ineligible for OWF
            return "Ineligible as the countable income of $\(getCountableIncome()) exceeds the payment standard of $\(getPaymentStandard())"
        }
        
    }
    
    func getPaymentAmount() -> Int {
        if (getCountableIncome() < 0) {
            return getPaymentStandard()
        } else {
            return getPaymentStandard() - getCountableIncome()
        }
    }
    
    func initialEligibilityPassed() -> Bool {
        // OAC 5101:1-23-20(H)(1)
        return getGrossIncome() < getInitialEligibilityStandard()
        
    }
    
    func getInitialEligibilityStandard() -> Int {
        return (constants?.object(forKey: "eligibilityStandard") as! [Int])[agSize]
    }
    
    func getPaymentStandard() -> Int {
        return (constants?.object(forKey: "paymentStandard") as! [Int])[agSize]
    }
    
    func getGrossIncome() -> Int {
        // OAC 5101:1-23-20(H)(1)
        return Int(floor(earnedIncome) -
            floor(dependentCare) +
            floor(deemedIncome) +
            floor(unearnedIncome))
    }
    
    func countableIncomeBelowStandard() -> Bool {
        /* 	see if countable income exceeds OWF payment standard
        OAC 5101:1-23-20(H)(2)
        return true if standard is met
        return false if test fails */
        return getCountableIncome() < getPaymentStandard()
        
    }
    
    func getCountableIncome() -> Int {
        
        // calculate countable income from OAC 5101:1-23-20(H)(2)(a)-(b)
        
        // make sure earnedincome isn't negative and calcaulte earned income disregard
        
        let adjustedEarnedIncome = floor((earnedIncome - 250) / 2)
        return Int(floor(adjustedEarnedIncome - dependentCare + unearnedIncome + deemedIncome))
    }
}
