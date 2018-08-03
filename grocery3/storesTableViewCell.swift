//
//  storesTableViewCell.swift
//  grocery3
//
//  Created by mac on 7/27/17.
//  Copyright © 2017 mac. All rights reserved.
//

import UIKit

class storesTableViewCell: UITableViewCell {

    @IBOutlet var storename: UILabel!
    @IBOutlet var photo: UIImageView!
    @IBOutlet var distance: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
