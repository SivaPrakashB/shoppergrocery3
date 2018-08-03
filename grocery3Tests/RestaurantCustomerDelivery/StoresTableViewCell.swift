//
//  StoresTableViewCell.swift
//  FoodDeliveryCustomer
//
//  Created by iqmsoft on 11/7/16.
//  Copyright © 2016 iQmSoft. All rights reserved.
//

import UIKit

class StoresTableViewCell: UITableViewCell {

    
    @IBOutlet weak var storeName: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var cosmosRatingView: CosmosView!
    @IBOutlet weak var noRatingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
