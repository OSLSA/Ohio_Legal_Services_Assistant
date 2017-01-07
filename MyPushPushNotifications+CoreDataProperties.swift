//
//  MyPushPushNotifications+CoreDataProperties.swift
//  Ohio Legal Services Assistant
//
//  Created by Joshua Goodwin on 6/11/16.
//  Copyright © 2016 Ohio State Legal Services. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension MyPushPushNotifications {

    @NSManaged var subscribedToAttorney: NSNumber?
    @NSManaged var subscribedToLegalServices: NSNumber?
    @NSManaged var subscribedToServiceProvider: NSNumber?

}
