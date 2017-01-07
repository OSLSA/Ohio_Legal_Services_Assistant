//
//  ResourceDetailViewController.swift
//  Ohio Legal Services Assistant
//
//  Created by Joshua Goodwin on 10/2/16.
//  Copyright © 2016 Ohio State Legal Services. All rights reserved.
//

import UIKit

class ResourceDetailViewController: UIViewController {

    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelAddress: UITextField!
    @IBOutlet weak var labelCSZ: UITextField!
    @IBOutlet weak var labelPhone: UITextField!
    @IBOutlet weak var labelWebsite: UITextField!
    @IBOutlet weak var labelNotes: UITextField!
    
 
    var resource : LocalResource = LocalResource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        labelName.text = resource.name
        labelAddress.text = resource.address
        let CSZ : String = "\(resource.city), \(resource.state) \(resource.zip)"
        labelCSZ.text = CSZ
        labelPhone.text = resource.phone
        labelWebsite.text = resource.website
        
        labelNotes.text = "Notes: \(resource.notes)"
        
        // Do any additional setup after loading the view.
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
