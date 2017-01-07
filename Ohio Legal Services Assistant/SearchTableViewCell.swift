//
//  SearchTableViewCell.swift
//  Ohio Legal Services Assistant
//
//  Created by Joshua Goodwin on 5/29/16.
//  Copyright © 2016 Ohio State Legal Services. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var searchCell: UILabel!
    @IBOutlet var searchCellDetail: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
