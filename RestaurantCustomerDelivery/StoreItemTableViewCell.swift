//
//  StoreItemTableViewCell.swift
//  FoodDeliveryCustomer
//
//  Created by iqmsoft on 11/8/16.
//  Copyright © 2016 iQmSoft. All rights reserved.
//

import UIKit

protocol StoreItemTableViewCellDelegate {
    func stepperButton(sender: StoreItemTableViewCell)
}

class StoreItemTableViewCell: UITableViewCell {

    var delegate : StoreItemTableViewCellDelegate?
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var catName: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var stepperTaped: UIStepper!
    @IBOutlet weak var quantityLabel: UILabel!
    

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func stepperProcess(_ sender: UIStepper) {
        if delegate != nil {
            delegate?.stepperButton(sender: self)
            quantityLabel.text = "x \(Int(stepperTaped.value))"
            
        }
    }
  
 
}
