//
//  MyTabBarViewController.swift
//  Ohio Legal Services Assistant
//
//  Created by Ohio State Legal Services on 10/18/16.
//  Copyright © 2016 Ohio State Legal Services. All rights reserved.
//

import UIKit

class MyTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.tintColor = Colors.primaryText
        self.moreNavigationController.navigationBar.tintColor = Colors.accentColor
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        let moreNavController = self.moreNavigationController
        if let moreTableView = moreNavController.topViewController?.view as? UITableView {
            for cell in moreTableView.visibleCells {
                cell.textLabel?.textColor = Colors.primaryText
            }
        }
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
