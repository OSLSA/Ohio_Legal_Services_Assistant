//
//  FormsTableViewCell.swift
//  Ohio Legal Services Assistant
//
//  Created by Joshua Goodwin on 3/26/16.
//  Copyright © 2016 Ohio State Legal Services. All rights reserved.
//

import UIKit

class FormsTableViewCell: UITableViewCell {

    @IBOutlet weak var formsCell: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
