//
//  AddressViewController.swift
//  RestaurantCustomerDelivery
//
//  Created by iqmsoft on 11/12/16.
//  Copyright © 2016 iQmSoft. All rights reserved.
//

import UIKit

class AddressViewController: UIViewController {

    
    @IBOutlet weak var addres1: UITextField!
    @IBOutlet weak var address2: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var zipcode: UITextField!
    @IBOutlet weak var contactName: UITextField!
    @IBOutlet weak var contactNumber: UITextField!
    @IBOutlet weak var deliveryNotes: UITextField!
    var defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
       getData()
        
        // Do any additional setup after loading the view.
    }
    
    func textRound() {
        
        textField(text: addres1)
        textField(text: address2)
        textField(text: city)
        textField(text: zipcode)
        textField(text: contactName)
        textField(text: contactNumber)
        textField(text: deliveryNotes)
    }
    
    func textField(text : UITextField)  {
        text.layer.borderWidth = 0.5
        text.layer.borderColor = UIColor.darkGray.cgColor
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveTapped(_ sender: UIButton) {
         let address1 = addres1.text!
         let addr2 = address2.text!
         let citys = city.text!
         let zip = zipcode.text!
         let conName = contactName.text!
         let conNum = contactNumber.text!
         let delery = deliveryNotes.text!
        
        if address1.isEmpty == true || addr2.isEmpty == true || citys.isEmpty == true || zip.isEmpty == true
         || conNum.isEmpty == true || conName.isEmpty == true || delery.isEmpty == true {
            let alert = UIAlertController(title: "All fields Required", message: "Please check all fields", preferredStyle: UIAlertControllerStyle.alert)
            let ok = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
        else {
            defaults.set(address1, forKey: "Address1")
            defaults.set(addr2, forKey: "Address2")
            defaults.set(citys, forKey: "City")
            defaults.set(zip, forKey: "Zipcode")
            defaults.set(conName, forKey: "ContactName")
            defaults.set(conNum, forKey: "ContactNumber")
            defaults.set(delery, forKey: "deliverynotes")
        
            
            let alert = UIAlertController(title: "Address added", message: "Successfully!", preferredStyle: UIAlertControllerStyle.alert)
            let ok = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default)  {
                ACTION in
                self.navigationController?.popViewController(animated: true)
            }
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
     }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
