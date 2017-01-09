//
//  ResourceDetailViewController.swift
//  Ohio Legal Services Assistant
//
//  Created by Joshua Goodwin on 10/2/16.
//  Copyright © 2016 Ohio State Legal Services. All rights reserved.
//

import UIKit
import CoreLocation

class ResourceDetailViewController: UIViewController {

    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var labelCSZ: UILabel!
    @IBOutlet weak var labelPhone: UILabel!
    @IBOutlet weak var labelWebsite: UILabel!
    @IBOutlet weak var labelNotes: UILabel!

    
 
    var resource : LocalResource = LocalResource()
    var CSZ : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        labelName.text = resource.name
        labelAddress.text = resource.address
        CSZ = "\(resource.city), \(resource.state) \(resource.zip)"
        labelCSZ.text = CSZ
        labelPhone.text = resource.phone
        labelWebsite.text = resource.website
        labelNotes.text = "Notes: \(resource.notes)"
        
        labelAddress.isUserInteractionEnabled = true
        let addressTap = UITapGestureRecognizer(target: self, action: #selector(ResourceDetailViewController.addressTap))
        
        labelCSZ.isUserInteractionEnabled = true
        let cszTap = UITapGestureRecognizer(target: self, action: #selector(ResourceDetailViewController.addressTap))
        labelCSZ.addGestureRecognizer(cszTap)
        labelAddress.addGestureRecognizer(addressTap)
        
        labelPhone.isUserInteractionEnabled = true
        let phoneTap = UITapGestureRecognizer(target: self, action: #selector(ResourceDetailViewController.phoneTap))
        labelPhone.addGestureRecognizer(phoneTap)
        
        labelWebsite.isUserInteractionEnabled = true
        let webTap = UITapGestureRecognizer(target: self, action: #selector(ResourceDetailViewController.websiteTap))
        labelWebsite.addGestureRecognizer(webTap)
        
        
        // Do any additional setup after loading the view.
    }
    
    func phoneTap(sender: UITapGestureRecognizer) {
        let url = NSURL(string: "tel://\(resource.phone)")!
        print(url)
        UIApplication.shared.openURL(url as URL)
    }
    
    func websiteTap(sender: UITapGestureRecognizer) {
        let url = URL(string: resource.website)!
        UIApplication.shared.openURL(url)
    }
    
    func addressTap(sender: UITapGestureRecognizer) {
        let fullAddress = "\(resource.address), \(resource.zip)"
        var geocoder = CLGeocoder()
        geocoder.geocodeAddressString(fullAddress) { (placemarksOptional, error) -> Void in
            if let placemarks = placemarksOptional {
                print("placemark| \(placemarks.first)")
                if let location = placemarks.first?.location {
                    let query = "?ll=\(location.coordinate.latitude),\(location.coordinate.longitude)"
                    let path = "http://maps.apple.com/" + query
                    if let url = NSURL(string: path) {
                        UIApplication.shared.openURL(url as URL)
                    } else {
                        // Could not construct url. Handle error.
                    }
                } else {
                    // Could not get a location from the geocode request. Handle error.
                }
            } else {
                // Didn't get any placemarks. Handle error.
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
