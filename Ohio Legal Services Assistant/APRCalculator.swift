//
//  APRCalculator.swift
//  Ohio Legal Services Assistant
//
//  Created by Joshua Goodwin on 12/19/15.
//  Copyright © 2015 Ohio State Legal Services. All rights reserved.
//

import Foundation

class APRCalculator {
    var amountBorrowed = Double()
    var costs = Double()
    var baseRate = Double()
    var numberOfPayments = Double()
    
    func setVariables(_ amountBorrowed: Double, costs: Double, baseRate: Double, numberOfPayments: Double) {
        self.amountBorrowed = amountBorrowed
        self.costs = costs
        self.baseRate = baseRate
        self.numberOfPayments = numberOfPayments
    }
    
    // calculate APR
    
    func getAPR() -> Double {
        
        
        var testResult = Double()
        var testDiff = getRate()
        var testRate = getRate()
        var count = 1
        for _ in 1 ..< 1000 {
            testResult = ((testRate * pow(1 + testRate, numberOfPayments)) / (pow(1 + testRate, numberOfPayments) - 1)) - (getMonthlyPayment() / amountBorrowed)
            print(testResult)
            if (fabs(testResult) < 0.0000001) {break;}
            if (testResult < 0) {
                testRate += testDiff
            } else {
                testRate -= testDiff
            }
            testDiff /= 2
            count += 1
            
        }
        // return a rounded result
        print(count)
        return Double(round((testRate * 12 * 100) * 10000)) / 10000;
        
    }
    
    func getMonthlyPayment() -> Double {
        
        let tempMonthlyPayment = ((amountBorrowed + costs) * getRate() * pow(1 + getRate(), numberOfPayments)) / (pow(1 + getRate(), numberOfPayments)-1)
        return Double(round(tempMonthlyPayment * 100) / 100)

    }
    
    func getRoundedMonthlyPayment() -> Double {
        
        return Double(round(getMonthlyPayment() * 100) / 100)
    }
    
    func getTotalPayments() -> Double {
        
        return Double(round((getMonthlyPayment() * numberOfPayments) * 100) / 100)
        
    }
    
    func getTotalInterest() -> Double {
        
        return getTotalPayments() - amountBorrowed
        
    }
    
    func getRate() -> Double {
        return baseRate / 100 / 12
    }

}
