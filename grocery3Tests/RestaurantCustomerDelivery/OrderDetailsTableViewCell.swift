//
//  OrderDetailsTableViewCell.swift
//  RestaurantCustomerDelivery
//
//  Created by iqmsoft on 11/15/16.
//  Copyright © 2016 iQmSoft. All rights reserved.
//

import UIKit

class OrderDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var qunatity: UILabel!
    @IBOutlet weak var descriptions: UILabel!
    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var deliveryCharges: UILabel!
    
    @IBOutlet weak var packingCost: UILabel!
    @IBOutlet weak var discount: UILabel!
    @IBOutlet weak var totalPrice: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
