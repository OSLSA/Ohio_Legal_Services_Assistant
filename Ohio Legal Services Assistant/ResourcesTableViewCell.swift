//
//  ResourcesTableViewCell.swift
//  Ohio Legal Services Assistant
//
//  Created by Joshua Goodwin on 9/29/16.
//  Copyright © 2016 Ohio State Legal Services. All rights reserved.
//

import UIKit

class ResourcesTableViewCell: UITableViewCell {

    @IBOutlet weak var detailTitle: UILabel!
    @IBOutlet weak var cellTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
