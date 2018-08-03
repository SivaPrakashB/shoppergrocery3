//
//  ordersTableViewCell1.swift
//  grocery3
//
//  Created by mac on 10/10/17.
//  Copyright © 2017 mac. All rights reserved.
//

import UIKit

class ordersTableViewCell1: UITableViewCell {
    
    
    @IBOutlet weak var orderno: UILabel!

    @IBOutlet weak var orderDate: UILabel!
    @IBOutlet weak var Address: UILabel!
    @IBOutlet weak var DeliveryDateAndTime: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
