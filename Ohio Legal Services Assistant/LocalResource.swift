//
//  LocalResource.swift
//  Ohio Legal Services Assistant
//
//  Created by Joshua Goodwin on 10/2/16.
//  Copyright © 2016 Ohio State Legal Services. All rights reserved.
//

import UIKit
import Foundation
import FirebaseDatabase

struct LocalResource {

    var name : String
    var address : String
    var category : String
    var city : String
    var state : String
    var zip : String
    var phone : String
    var website : String
    var notes : String
    
    init(snapshot: DataSnapshot) {
        let sv = snapshot.value as! [String: AnyObject]
        name = sv["name"] as! String
        address = sv["address"] as! String
        category = sv["category"] as! String
        city = sv["city"] as! String
        state = sv["state"] as! String
        zip = sv["zip"] as! String
        phone = sv["phone"] as! String
        website = sv["website"] as! String
        notes = sv["notes"] as! String
    }
    
    init() {
        name = ""
        address = ""
        category = ""
        city = ""
        state = ""
        zip = ""
        phone = ""
        website = ""
        notes = ""
    }
    
}
