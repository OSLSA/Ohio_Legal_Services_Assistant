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
    
    func pmt(rate : Double, nper : Double, pv : Double, fv : Double, type : Double) -> Double {
        
        // P ∗ ( r ( 1 + r ) ^n ) / ( ( 1 + r ) ^n − 1 )
        let newRate = (rate / 100) / 12
        let pvif = pow((1+newRate),nper)
        let result = pv * ((newRate * pvif) / ((pvif)-1))
        return(result)
        
    };
    
    func F(x: Double) -> Double {
        
        //def F(x) {        return amount * x * Math.pow(1 + x,numPay)/(Math.pow(1 + x,numPay) - 1) - payment}
        let result = amountBorrowed * x * pow(1+x,numberOfPayments) / (pow(1+x,numberOfPayments) - 1) - getMonthlyPayment()
        print("F: \(result)")
        return result
    }
    
    func F_1(x: Double) -> Double {
        let result = amountBorrowed * ( pow(1 + x,numberOfPayments)/(-1 + pow(1 + x,numberOfPayments)) - numberOfPayments * x * pow(1 + x,-1 + 2*numberOfPayments)/pow(-1 + pow(1 + x,numberOfPayments),2) + numberOfPayments * x * pow(1 + x,-1 + numberOfPayments)/(-1 + pow(1 + x,numberOfPayments)))
        return result
    }
    
    func getAPRate() -> Double {
        let error = 0.000001
        var approx = 0.05/12
        var prev_approx = 0.4/12
    
        for _ in 1 ..< 100 {
            prev_approx = approx
            approx = prev_approx - F(x: prev_approx)/F_1(x: prev_approx)
            let diff = abs(approx-prev_approx)
            if (diff < error) {break}
        }
    
        return approx
    }
    
    
    // calculate APR
    
    func getAPR() -> Double {
        
        return Double(round((getAPRate() * 12 * 100) * 10000)) / 10000;
        
    }
    
    func getMonthlyPayment() -> Double {
        
        let tempMonthlyPayment = pmt(rate: baseRate,nper: numberOfPayments,pv: (amountBorrowed + costs),fv: 0,type: 0);
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
