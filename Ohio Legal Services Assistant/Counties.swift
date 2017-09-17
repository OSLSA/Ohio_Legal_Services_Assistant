//
//  Counties.swift
//  Ohio Legal Services Assistant
//
//  Created by Joshua Goodwin on 10/2/16.
//  Copyright © 2016 Ohio State Legal Services. All rights reserved.
//

import UIKit
import Foundation
import Firebase

struct Counties {
    
    var countyName : String
    var legalAid : String
    
    init(countyName : String, legalAid : String) {
        self.countyName = countyName
        self.legalAid =  legalAid
    }
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        countyName = snapshotValue["name"] as! String
        legalAid = snapshotValue["legalAid"] as! String
    }

}
