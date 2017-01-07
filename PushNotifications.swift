//
//  PushNotifications.swift
//  Ohio Legal Services Assistant
//
//  Created by Joshua Goodwin on 6/11/16.
//  Copyright © 2016 Ohio State Legal Services. All rights reserved.
//

import Foundation
import CoreData


class PushNotifications: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    @NSManaged var subscribedToAttorney: Bool
    @NSManaged var subscribedToLegalServices: Bool
    @NSManaged var subscribedToServiceProvider: Bool

}
