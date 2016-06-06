//
//  DirectionTableViewCell.swift
//  RPI Tours
//
//  Created by John Behnke on 6/5/16.
//  Copyright © 2016 RPI Web Tech. All rights reserved.
//

import UIKit

class DirectionTableViewCell: UITableViewCell {

    @IBOutlet var directionLabel: UILabel!
    @IBOutlet var distanceLabel: UILabel!
    @IBOutlet var directionImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
