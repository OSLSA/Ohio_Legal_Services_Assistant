//
//  GarnishmentCalculator.swift
//  Ohio Legal Services Assistant
//
//  Created by Joshua Goodwin on 12/19/15.
//  Copyright © 2015 Ohio State Legal Services. All rights reserved.
//

import Foundation

class GarnishmentCalculator {

    // variables and constants
let federalHourlyMinnimumWage = 7.25
var income = 0.0
var frequency = 0
var hours = 0.0

func setVariables(_ income: Double, frequency: Int, hours: Double) {
    self.income = income
    self.frequency = frequency
    self.hours = hours
}

func getGarnishmentResults() -> String {
    
    let multiplier = getMultiplier(frequency)
    
    // calcaulte weekly income if paid hourly
    if (frequency == 0) {income *= hours}
    
    let minWageAmount = federalHourlyMinnimumWage * Double(multiplier)
    
    let exemptPercent = income * 0.75
    let exempt = minWageAmount > exemptPercent ? minWageAmount : exemptPercent
    let garnishable = exempt > 0.0 ? income - exempt : 0.0
    
    if (garnishable <= 0.0) {
        return "None of the income is garnishable pursuant to O.R.C. 2329.66(A)(13)."
    } else {
        return "$\(exempt) of the income is exempt, which means $\(garnishable) is garnishable pursuant to O.R.C. 2329.66(A)(13)."
    }
    
}

func getMultiplier(_ frequency: Int) -> Int {
    
    switch (frequency) {
        // multiplier based on RC 2923.66(A)(13)
    case 0, 1:
        return 30
    case 2:
        return 60
    case 3:
        return 130
    default:
        return 60
    }
}
}
