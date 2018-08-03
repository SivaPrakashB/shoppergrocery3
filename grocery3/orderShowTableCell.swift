//
//  orderShowTableCell.swift
//  grocery3
//
//  Created by mac on 8/26/17.
//  Copyright © 2017 mac. All rights reserved.
//

import UIKit

class orderShowTableCell: UITableViewCell {

    
    @IBOutlet weak var quality: UILabel!
    @IBOutlet weak var weight: UILabel!
    @IBOutlet weak var brand: UILabel!
    
    @IBOutlet weak var description2: UILabel!
   
    
    @IBOutlet weak var orderid: UILabel!
    
    @IBOutlet weak var productname: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
