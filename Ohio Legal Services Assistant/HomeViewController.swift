//
//  HomeViewController.swift
//  Ohio Legal Services Assistant
//
//  Created by Joshua Goodwin on 6/18/16.
//  Copyright © 2016 Ohio State Legal Services. All rights reserved.
//

import UIKit
import CoreData

class HomeViewController: UIViewController {

    @IBOutlet weak var lscLogo: UIImageView!
    @IBOutlet weak var oslsaLogo: UIImageView!
    @IBOutlet weak var pikaButton: UIButton!
    
    var pikaAddress: String = ""
    var managedObjectContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var tap = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.lscLogoTapped))
        lscLogo.addGestureRecognizer(tap)
        lscLogo.isUserInteractionEnabled = true
        
        tap = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.oslsaLogoTapped))
        oslsaLogo.addGestureRecognizer(tap)
        oslsaLogo.isUserInteractionEnabled = true

        // Do any additional setup after loading the view.
        
        let appDel:AppDelegate = (UIApplication.shared.delegate as! AppDelegate)
        managedObjectContext = appDel.managedObjectContext
        let urlFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PikaURL")
        urlFetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try managedObjectContext.fetch(urlFetchRequest)
            let pikaURL = results as! [NSManagedObject]
            if pikaURL.count > 0 {
                let pika = pikaURL[0]
                pikaAddress = ((pika.value(forKey: "address")) as? String)!
                pikaButton.isHidden = false
            } else {
                pikaButton.isHidden = true
            }
        } catch {
            
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("vieAppear")
        let appDel:AppDelegate = (UIApplication.shared.delegate as! AppDelegate)
        managedObjectContext = appDel.managedObjectContext
        let urlFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PikaURL")
        urlFetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try managedObjectContext.fetch(urlFetchRequest)
            let pikaURL = results as! [NSManagedObject]
            if pikaURL.count > 0 {
                let pika = pikaURL[0]
                pikaAddress = ((pika.value(forKey: "address")) as? String)!
                pikaButton.isHidden = false
            } else {
                pikaButton.isHidden = true
            }
        } catch {
            
        }
    }

    func lscLogoTapped() {
        let url = URL(string: "http://www.lsc.gov/grants-grantee-resources/our-grant-programs/tig")!
        UIApplication.shared.openURL(url)
    }
    
    func oslsaLogoTapped() {
        let url = URL(string: "https://www.seols.org")!
        UIApplication.shared.openURL(url)
    }
    
    @IBAction func pikaPresses(_ sender: UIButton) {
        print("pika pressed")
        let url = URL(string: pikaAddress)!
        UIApplication.shared.openURL(url)
        print(pikaAddress)
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
