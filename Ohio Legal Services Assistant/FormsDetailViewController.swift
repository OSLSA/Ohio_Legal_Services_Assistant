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
        
        let fm = FileManager.default
        let docsurl = try! fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let fileURL = docsurl.appendingPathComponent(self.fileName + ".pdf")
        
        isConnected { (connected) in
            if(connected){
                let storage = Storage.storage()
                let storageRef = storage.reference()
                let formRef = storageRef.child(self.fileName + ".pdf")
                print(formRef)
                
                
                
                //let localURL = URL(string: localURL)!
                
                let downloadTask = formRef.write(toFile: fileURL) { url, error in
                    if let error = error {
                        
                    } else {
                        
                    }
                }
                downloadTask.observe(.success) { snapshot in
//                    let pdf = fileURL
//                    //if let pdf = Bundle.main.url(forResource: self.fileName, withExtension: "pdf", subdirectory: nil, localization: nil){
//                    let req = URLRequest(url: fileURL)
//
//                    self.webView.loadRequest(req)
//                    self.webView.scalesPageToFit = true
                    
                    self.showForm(url: fileURL)
                    
                }
                
            } else {
                print("return 1")
                guard let result = NSData(contentsOf: fileURL) else {
                    // No data in your fileURL. So no data is received. Do your task if you got no data
                    // Keep in mind that you don't have access to your result here.
                    // You can return from here.
                    print("return 2")
                    func showAlert(alert: String) {
                        let alertController = UIAlertController(title: "Connection Required", message: "In order to access this form, you need an internet connection. Once accessed, it will then be available offline", preferredStyle: .alert)
                        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alertController.addAction(defaultAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                    showAlert(alert: "ALERT")
                    return
                }
                // You got your data successfully that was in your fileURL location. Do your task with your result.
                // You can have access to your result variable here. You can do further with result constant.
                print("return 3")
                self.showForm(url: fileURL)
                
            }
        }
        
        
        
        // Do any additional setup after loading the view.
    }
    
    private func showForm(url: URL) {
        //let pdf = url
        //if let pdf = Bundle.main.url(forResource: self.fileName, withExtension: "pdf", subdirectory: nil, localization: nil){
        let req = URLRequest(url: url)
        
        self.webView.loadRequest(req)
        self.webView.scalesPageToFit = true
    }
    
    private func isConnected(completionHandler : @escaping (Bool) -> ()) {
        let connectedRef = Database.database().reference(withPath: ".info/connected")
        connectedRef.observe(.value, with: { snapshot in
            completionHandler((snapshot.value as? Bool)!)
        })
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
