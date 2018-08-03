//
//  drivercell.swift
//  grocery3
//
//  Created by mac on 9/7/17.
//  Copyright © 2017 mac. All rights reserved.
//

import UIKit

class drivercell: UITableViewCell {

    @IBOutlet weak var deliverytime: UILabel!
    @IBOutlet weak var deliverydate: UILabel!
    @IBOutlet weak var lname: UILabel!
    @IBOutlet weak var fname: UILabel!
    @IBOutlet weak var id: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
