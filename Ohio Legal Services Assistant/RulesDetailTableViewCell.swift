//
//  RulesDetailTableViewCell.swift
//  Ohio Legal Services Assistant
//
//  Created by Joshua Goodwin on 12/24/15.
//  Copyright © 2015 Ohio State Legal Services. All rights reserved.
//

import UIKit

class RulesDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var ruleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setLabelColor(_ number: Int) {
        
    }
    

}
