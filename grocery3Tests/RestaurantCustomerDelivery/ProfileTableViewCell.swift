//
//  ProfileTableViewCell.swift
//  FoodDeliveryCustomer
//
//  Created by iqmsoft on 11/10/16.
//  Copyright © 2016 iQmSoft. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var options: UILabel!
    @IBOutlet weak var icons: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
