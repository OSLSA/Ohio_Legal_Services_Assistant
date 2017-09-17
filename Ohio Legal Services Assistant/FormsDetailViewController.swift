//
//  FormsDetailViewController.swift
//  Ohio Legal Services Assistant
//
//  Created by Ohio State Legal Services on 4/9/16.
//  Copyright © 2016 Ohio State Legal Services. All rights reserved.
//

import UIKit
import Firebase

class FormsDetailViewController: UIViewController {

    var formName = String()
    var fileName = String()
    
    @IBOutlet var webView: UIWebView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
            AnalyticsParameterContentType: "Form \(formName) Opened" as NSObject
            ])
        if let pdf = Bundle.main.url(forResource: fileName, withExtension: "pdf", subdirectory: nil, localization: nil){
            let req = URLRequest(url: pdf)
        
        webView.loadRequest(req)
        webView.scalesPageToFit = true
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
