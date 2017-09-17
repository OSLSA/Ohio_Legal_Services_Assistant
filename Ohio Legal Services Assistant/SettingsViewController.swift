//
//  SettingsViewController.swift
//  Ohio Legal Services Assistant
//
//  Created by Joshua Goodwin on 6/11/16.
//  Copyright © 2016 Ohio State Legal Services. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import FirebaseMessaging
import FirebaseInstanceID

class SettingsViewController: UIViewController {

    @IBOutlet weak var swAttorneys: UISwitch!
    @IBOutlet weak var swLegalServices: UISwitch!
    @IBOutlet weak var swLayProvider: UISwitch!
    @IBOutlet var pikaAddress: UITextField!

    var managedObjectContext : NSManagedObjectContext!
    var boolAttorney = NSManagedObject()
    var boolLegalService = NSManagedObject()
    var boolServiceProvider = NSManagedObject()
    var boolSwitches = [MyPushPushNotifications]()
    var pikaURL = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let appDel:AppDelegate = (UIApplication.shared.delegate as! AppDelegate)
        managedObjectContext = appDel.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PushNotifications")
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try managedObjectContext.fetch(fetchRequest) as? [MyPushPushNotifications]
            boolSwitches = results!
            print(boolSwitches.count)
            if boolSwitches.count > 0 {
                swAttorneys.isOn = (boolSwitches[0].subscribedToAttorney?.boolValue)!
                swLayProvider.isOn = (boolSwitches[0].subscribedToServiceProvider?.boolValue)!
                swLegalServices.isOn = (boolSwitches[0].subscribedToLegalServices?.boolValue)!
                
            } else {
                
            }
            
        } catch {
            
        }
        
        let urlFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PikaURL")
        urlFetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try managedObjectContext.fetch(urlFetchRequest)
            pikaURL = results as! [NSManagedObject]
            print(pikaURL)
            if pikaURL.count > 0 {
                let pika = pikaURL[0]
                pikaAddress.text = (pika.value(forKey: "address")) as? String
            }
        } catch {
            
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a new fetch request using the LogItem entity
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func legalServicesSwitched(_ sender: UISwitch) {
        changeSubscription("Legal_Aid_Advocate", status: sender.isOn, key: "subscribedToLegalServices")
    }
  
    @IBAction func layProviderSwitched(_ sender: UISwitch) {
        changeSubscription("Service_Provider", status: sender.isOn, key: "subscribedToServiceProvider")
        
    }
    
    @IBAction func attorneySwitched(_ sender: UISwitch) {
        changeSubscription("Attorney", status: sender.isOn, key: "subscribedToAttorney")
    }
    
    func changeSubscription(_ topic: String, status: Bool, key: String) {
        if (status) {
            Messaging.messaging().subscribe(toTopic: topic)
            print("Subscribed to \(topic)")
        } else {
            Messaging.messaging().unsubscribe(fromTopic: topic)
            print("Unsubscribed from \(topic)")
        }
        saveSubscription(key, subscribed: status)
    }
    
    
    func saveSubscription(_ name: String, subscribed: Bool) {
        if boolSwitches.count > 0 {
            boolSwitches[0].setValue(subscribed, forKey: name)
        } else {
            let entity =  NSEntityDescription.entity(forEntityName: "PushNotifications",
                                                            in:managedObjectContext)
            
            let status = NSManagedObject(entity: entity!,
                                         insertInto: managedObjectContext)
            
            //status.setValue(subscribed, forKey: name)
            status.setValue(swLegalServices.isOn, forKey: "subscribedToLegalServices")
            status.setValue(swLayProvider.isOn, forKey: "subscribedToServiceProvider")
            status.setValue(swAttorneys.isOn, forKey: "subscribedToAttorney")
            
            
        }
        
        do {
            try managedObjectContext.save()
        } catch {
            
        }
    }
    

    
    @IBAction func pressSave(_ sender: UIButton) {
        
        if pikaURL.count > 0 {
            
            pikaURL[0].setValue(pikaAddress.text, forKey: "address")
            print("Count > 0 ")
        } else {
            let entity = NSEntityDescription.entity(forEntityName: "PikaURL", in: managedObjectContext)
            let status = NSManagedObject(entity: entity!, insertInto: managedObjectContext)
            status.setValue(pikaAddress.text, forKey: "address")
            print("saved")
        }
        
        
        do {
            try managedObjectContext.save()
        } catch {
            
        }
        
        let message : String = "Address Saved!"
        let alert = UIAlertController(title: "Save", message: message as String, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler:handleCancel))
        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func aboutPressed(_ sender: UIButton) {
    
        let message : String = "This app was developed by Ohio State Legal Services Association with funding from the LSC TIG program. The purpose of the app is to provide useful information for legal services advocates, pro bono attorneys, and service providers for the poor in Ohio.\n\nFeedback is always welcome and encouraged. We would love to hear how you are using the app as well, any errors you find, things you would like to see added, and ways it can be improved. Email us at apps@oslsa.org.\n\nThe source code for this app is freely available on GitHub at www.github.com/oslsa.\n\nDISCLAIMER\n\nThis app is for informational purposes only and is not intended to provide legal advice. Use of this app does not create an attorney-client relationship between you, the user, and Ohio State Legal Services Association, Southeastern Ohio Legal Services, and any of its employees. You should neither take nor refrain from taking any legal action based upon the information in this app, but you should instead talk to a licensed attorney. Lastly, we have taken every effort to ensure the accuracy of the information in this app, but this app is offered as is, and there is no warranty that the information is accurate. Anyone relying on the information is responsible for ensuring the accuracy of it and its applicability to his or her particular situation.\n\nLICENSE\n\nOhio Legal Services Assistant\n\nCopyright (C) 2016  Ohio State Legal Services Association\n\nThis program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.\n\nThis program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.\n\nYou should have received a copy of the GNU General Public License along with this program.  If not, see www.gnu.org/licenses/"
        let alert = UIAlertController(title: "About", message: message as String, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.cancel, handler:handleCancel))
        self.present(alert, animated: true, completion: nil)
    
    }
    
    func handleCancel(_ alertView: UIAlertAction!)
    {
        print("Cancelled !!")
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
