//
//  File.swift
//  Ohio Legal Services Assistant
//
//  Created by Joshua Goodwin on 10/22/16.
//  Copyright © 2016 Ohio State Legal Services. All rights reserved.
//

import Foundation

class APRCalculatorPayment {

var numPay = Double()
var payment = Double()
var amount = Double()
var error : Double = pow(10,-5)
var approx : Double = 0.05/12 // guess that the APR is 5%
var prev_approx = Double()
var apr = Double()

    func setVariables(numPay : Double, payment : Double, amount : Double) {
        self.amount = amount
        self.numPay = numPay
        self.payment = payment
    }
    
    func F(x : Double) -> Double {
        return amount * x * pow(1 + x,numPay)/(pow(1 + x,numPay) - 1) - payment
    }
    
    func F_1(x : Double) -> Double {
        let partA = -1 + pow(1 + x,numPay)
        let partB = pow(1 + x,-1 + 2*numPay)
        let partC = pow(-1 + pow(1 + x,numPay),2)
        let partD = pow(1 + x,-1 + numPay)
        let partE = -1 + pow(1 + x,numPay)
        let partF = pow(1 + x,numPay)
        let partG = partF / partA
        let partH = Double(numPay) * x * partB
        let partI = Double(numPay) * x * partD
        return amount * ( partG - partH / partC + partI / partE)
    }
    
    func calculateAPR() -> Double {
        for _ in 1...100 {
            prev_approx = approx
            approx = prev_approx - F(x : prev_approx)/F_1(x : prev_approx)
            let diff = abs(approx-prev_approx)
            //println "new guess $approx diff is $diff"
            if (diff < error) {break}
        }
        apr = round(approx * 12 * 10000)/100
        return apr
    }
    
    func getTotalPayments() -> Double {
        return numPay * payment
    }
    
    func getInterestPaid() -> Double {
        return getTotalPayments() - amount
    }

}
