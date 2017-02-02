//
//  FederalPovertyLevelCalculator.swift
//  Ohio Legal Services Assistant
//
//  Created by Joshua Goodwin on 12/15/15.
//  Copyright © 2015 Ohio State Legal Services. All rights reserved.
//

import Foundation

class FederalPovertyLevelCalculator {
    
    let fpl2015 = [11770, 4160]
    let fpl2014 = [11660, 4060]
    let fpl2016 = [11880, 4140]
    let fpl2017 = [12060, 4180]
    
    var year = ""
    var annualIncome: Double = 0.0
    var size = 0
    
    func getResultsString() -> String {
        return "\(getResultsDouble())"
    }
    
    func getResultsDouble() -> Double {
        let povertyStart = getValues(year, pos: 0);
        let povertyIncrement = getValues(year, pos:1);
        
        let fpl = ((size - 1) * povertyIncrement) + povertyStart;
        
        return Double(round(((annualIncome / Double(fpl)) * 100) * 100)) / 100;
    }
    
    func getValues(_ y: String, pos: Int) -> Int {
        
        switch(y) {
        case "2014":
            return fpl2014[pos]
        case "2015":
            return fpl2015[pos]
        case "2016":
            return fpl2016[pos]
        case "2017":
            return fpl2017[pos]
        default:
            return 0
        }
    }
    
    func setValues(_ year: String, annualIncome: Double, size: Int) {
        self.year = year
        self.annualIncome = annualIncome
        self.size = size
    }
    
}
