//
//  FederalPovertyLevelCalculator.swift
//  Ohio Legal Services Assistant
//
//  Created by Joshua Goodwin on 12/15/15.
//  Copyright © 2015 Ohio State Legal Services. All rights reserved.
//

import Foundation

class FederalPovertyLevelCalculator {
    
    
    var year = ""
    var annualIncome: Double = 0.0
    var size = 0
    var values: NSDictionary!
    
    func getResultsString() -> String {
        return "\(getResultsDouble())"
    }
    
    func getResultsDouble() -> Double {
        let version:String = "fpl" + year
        let value = values.object(forKey: version) as! NSArray
        let povertyStart = value[0] as! Int
        let povertyIncrement = value[1] as! Int;
        
        let fpl = ((size - 1) * povertyIncrement) + povertyStart;
        
        return Double(round(((annualIncome / Double(fpl)) * 100) * 100)) / 100;
    }
    
    func setValues(_ year: String, annualIncome: Double, size: Int, values: NSDictionary) {
        self.year = year
        self.annualIncome = annualIncome
        self.size = size
        self.values = values
    }
    
}
