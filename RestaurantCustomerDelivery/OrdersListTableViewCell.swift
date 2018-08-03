//
//  OrdersListTableViewCell.swift
//  RestaurantCustomerDelivery
//
//  Created by iqmsoft on 11/14/16.
//  Copyright © 2016 iQmSoft. All rights reserved.
//

import UIKit

class OrdersListTableViewCell: UITableViewCell {

    @IBOutlet weak var price: UILabel!
    
    @IBOutlet weak var storeName: UILabel!
    
    @IBOutlet weak var orderID: UILabel!
    
    @IBOutlet weak var quantitys: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
