//
//  FoodStampCalculator.swift
//  Ohio Legal Services Assistant
//
//  Created by Joshua Goodwin on 12/19/15.
//  Copyright © 2015 Ohio State Legal Services. All rights reserved.
//

import Foundation
import Darwin

class FoodStampCalculator {
    
    var variables = [String: Any]()
    var constants: NSDictionary?
    var agSize = 1
    
    func setVariables(_ variables: [String: Any]) {
        
        self.variables = variables
        let version = self.variables["version"] as! String
        let text = "FoodStamps\(version)"
        if let path = Bundle.main.path(forResource: text, ofType: "plist") {
            constants = NSDictionary(contentsOfFile: path)
        }
        agSize = self.variables["agSize"] as! Int
        
    }
    
    init() { }
    
    func returnResults() -> String {
        
        if (!passTotalGrossIncomeTest() && !(variables["agedBlindDisabled"] as! Bool)) {
            // failed due to gross income exceeds gross income limit
            let grossIncomeLimit = (constants?.object(forKey: "grossIncomeLimit") as! [Int])[agSize - 1]
            let results = "Ineligible as total gross income of $\(getTotalGrossIncome()) exceeds the gross income limit of $\(grossIncomeLimit)"
            return results
        }
        
        if (!passNetIncome()) {
            // failed due to net income exceeds net income limit
            let test = (constants?.object(forKey: "netStandard") as! [Int])[agSize - 1]
            let results = "Ineligible as total net income of $\(getNetIncome()) exceeds the net income limit of $\(test)"
            return results
        }
        
        return "Client is eligible for food stamps in the amount of $\(getBenefitAmount()) per month"
        
    }
    
    func passTotalGrossIncomeTest() -> Bool {
        /* OAC 5101:4-4-31
        (R) Method of calculating gross monthly income
        Except for AGs containing at least one member who is elderly or disabled as defined in rule 5101:4-1-03 of the Administrative Code, or considered categorically eligible, all AGs shall be subject to the gross income eligibility standard for the appropriate AG size. To determine the AG's total gross income, add the gross monthly income earned by all AG members and the total monthly unearned income of all AG members, minus income exclusions. If an AG has income from a farming operation (with gross proceeds of more than one thousand dollars per year) which operates at a loss, see rule 5101:4-6-11 of the Administrative Code. The total gross income is compared to the gross income eligibility standard for the appropriate AG size. If the total gross income is less than the standard, proceed with calculating the adjusted net income as described in paragraph (S) of this rule. If the total gross income is more than the standard, the AG is ineligible for program benefits and the case is either denied or terminated at this point. */
        
        var grossIncomeAmount = constants?.object(forKey: "grossIncomeLimit") as! Array<Int>
        return (getTotalGrossIncome() <= grossIncomeAmount[agSize - 1])
        
    }
    
    func getTotalGrossIncome() -> Int {

        let earnedIncome = floor(((variables["earnedIncome"] as! String) as NSString).doubleValue)
        let unearnedIncome = floor((variables["unearnedIncome"]! as! NSString).doubleValue)
        return Int(earnedIncome + unearnedIncome)
    }
    
    func passNetIncome() -> Bool {
        
        // 5101:4-4-31(S)
        
        
        //TODO
        var result = getNetIncome() <= (constants?.object(forKey: "netStandard") as! [Int])[agSize - 1]
        
        result = (variables["categoricallyEligible"] as! Bool) || result
        
        if (getTotalGrossIncome() <= (constants?.object(forKey: "grossIncome200") as! [Int])[agSize - 1] && (variables["agedBlindDisabled"] as! Bool)) {return true}
        
        return result;
        
    }
    
    func getNetIncome() -> Int {
        /*	5101:4-4-31(S)(2) Earned income deduction: Multiply the total gross
        *	monthly earned income by twenty per cent and subtract that amount
        *	from the total gross income. */
        
        var finalNetIncome = getTotalGrossIncome() - Int(floor((variables["earnedIncome"]! as! NSString).doubleValue * 0.2))
        
        /* (3) Standard deduction: Subtract the standard deduction. */
        
        finalNetIncome -= (constants?.object(forKey: "standardDeduction") as! Array<Int>)[agSize - 1];
        /* 	(4) Excess medical deduction: If the AG is entitled to an excess
        *	medical deduction, determine if total medical expenses exceed
        *	thirty-five dollars. If so, subtract that portion which exceeds
        *	thirty-five dollars. */
        
        var medicalExpenses = 0
        
        if (Int(floor((variables["medicalExpenses"]! as! NSString).doubleValue)) - (constants?.object(forKey: "excessMedicalDeduction") as! Int) >= 0) {
            
            medicalExpenses = (Int(floor((variables["medicalExpenses"] as! NSString).doubleValue))) - (constants?.object(forKey: "excessMedicalDeduction") as! Int)
            
        }
        
        finalNetIncome -= medicalExpenses
        
        /* (5) Dependent care deduction: Subtract monthly dependent care expenses, if any. */
        
        finalNetIncome -= Int(floor((variables["dependentCare"]! as! NSString).doubleValue))
        
        /* 	(6) Legally obligated child support deduction: Subtract the allowable
        *	monthly child support payments in accordance with rule 5101:4-4-23 of
        *	the Administrative Code. */
        
        finalNetIncome -= Int(floor((variables["childSupport"]! as! NSString).doubleValue))
        
        /* 	(7) Standard homeless shelter deduction: Subtract the standard homeless
        *	shelter deduction amount if any, up to the maximum of one hundred
        *	forty-three dollars if the AG is homeless and it incurs shelter costs during the month. */
        
        if (variables["isHomeless"] as! Bool) {
            
            finalNetIncome -= constants?.object(forKey: "standardShelterHomeless") as! Int
            
        }
        
        /*	(8) Determining any excess shelter cost: Total the allowable shelter
        *	expenses to determine shelter costs, unless a deduction has been
        *	subtracted in accordance with paragraph (S)(7) of this rule. Subtract
        *	from total shelter costs fifty per cent of the AG's monthly income after
        *	all the above deductions have been subtracted. The remaining amount, if any,
        *	is the excess shelter cost. If there is no excess shelter cost, go to the next step.
        *	(9) Applying any excess shelter cost :Subtract the excess shelter cost
        *	up to the maximum amount allowed (unless the AG is entitled to the full
        *	amount of its excess shelter expenses) from the AG's monthly income
        *	after all other applicable deductions. AGs not subject to the shelter
        *	limitation shall have the full amount exceeding fifty per cent of their
        *	adjusted income subtracted. The AG's net monthly income has been determined. */
        let shelterDeduction = calculateShelterDeduction(finalNetIncome)
        print("shelterExpenses in netIncome(): \(shelterDeduction)")
        finalNetIncome -= shelterDeduction
        return finalNetIncome
    }
    
    func calculateShelterDeduction(_ finalNetIncome: Int) -> Int {
        /*	OAC 5101:4-4-23 Food assistance: deductions from income.
        *	(E) Shelter costs: monthly shelter costs over fifty per cent of the assistance group's income
        *	after all other deductions contained in this rule have been allowed. If the assistance group
        *	does not contain an elderly or disabled member, as defined in rule 5101:4-1-03 of the
        *	Administrative Code, the shelter deduction cannot exceed the maximum shelter deduction provided.
        *	These assistance groups shall receive an excess shelter deduction for the entire monthly cost
        *	that exceeds fifty per cent of the assistance group income after all other deductions
        *	contained in this rule have been allowed. */
        
        var shelterExpenses = utilityAllowance() + Int(floor((variables["rent"] as! NSString).doubleValue))
        shelterExpenses += Int(floor((variables["propertyInsurance"] as! NSString).doubleValue)) + Int(floor((variables["propertyTaxes"] as! NSString).doubleValue))
        shelterExpenses -= (finalNetIncome / 2);
        
        shelterExpenses = Int(fmax(Double(shelterExpenses), 0.0))
        
        
        if (!(variables["agedBlindDisabled"] as! Bool)) {
            // subject to shelter max
            shelterExpenses = Int(fmin(constants?.object(forKey: "limitOnShelterDeduction") as! Double, Double(shelterExpenses)))
        }
        print("calculateShelterDeduction: \(shelterExpenses)")
        return shelterExpenses
        
    }
    
    func utilityAllowance() -> Int {
        
        let phone = (variables["phone"] as! Bool) ? 2 : 0
        let heating = (variables["heating"] as! Bool) ? 4 : 0
        let electric = (variables["electric"] as! Bool) ? 8 : 0
        let water = (variables["water"] as! Bool) ? 8 : 0
        let garbage = (variables["garbage"] as! Bool) ? 8 : 0
        
        let test = phone + heating + electric + water + garbage;
        
        switch (test) {
            
        case 0:
            return 0;
        case 2:
            return constants?.object(forKey: "standardTelephoneAllowance") as! Int
        case 4, 6, 12, 14, 20, 22, 28, 30:
            return constants?.object(forKey: "standardUtilityAllowance") as! Int
        case 8:
            return constants?.object(forKey: "singleUtilityAllowance") as! Int
        default:
            return constants?.object(forKey: "limitedUtilityAllowance") as! Int
            
        }
        
        
    }
    
    func getBenefitAmount() -> Int {
        /* 	OAC 5101:4-4-27
        *	(c) If the assistance group is subject to the net income standard, compare
        *	the assistance group's net monthly income to the maximum net monthly income
        *	standard. If the assistance group's net income is greater than the net
        *	monthly income standard, the assistance group is ineligible. If the
        *	assistance group's net income is equal to or less than the net monthly income
        *	standard, the assistance group is eligible. Multiply the net monthly income by
        *	thirty per cent.
        *	(d) Round the product up to the next whole dollar if it ends in one cent
        *	through ninety-nine cents */
        
        let netIncome = getNetIncome() < 0 ? 0 : getNetIncome();
        let allotmentConstant = (constants?.object(forKey: "faAllotment") as! [Int])[agSize - 1]
        print("\(netIncome)")
        let test = Int(ceil(Double(netIncome) * 0.3))
        
        var benefitAmount = allotmentConstant - test
        
        /* 	OAC 5101:4-4-27
        *	(f) If the benefit is for a one or two person assistance group and the
        *	computation results in a benefit of less than the minimum benefit
        *	allotment, round up to the minimum benefit amount. */
        
        if ((variables["agedBlindDisabled"] as! Bool) || (variables["categoricallyEligible"] as! Bool) || agSize <= 3) {
            
            benefitAmount = benefitAmount < constants?.object(forKey: "minnimumMonthlyAllotment") as! Int ? constants?.object(forKey: "minnimumMonthlyAllotment") as! Int : benefitAmount;
        }
        return benefitAmount
    }
    
}

func += <KeyType, ValueType> (left: inout Dictionary<KeyType, ValueType>, right: Dictionary<KeyType, ValueType>) { for (k, v) in right { left.updateValue(v, forKey: k) } }
