//
//  EditAddressViewController.swift
//  RestaurantCustomerDelivery
//
//  Created by iqmsoft on 11/16/16.
//  Copyright © 2016 iQmSoft. All rights reserved.
//

import UIKit

class EditAddressViewController: UIViewController {

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
       showingDetails()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showingDetails() {
        
        if defaults.value(forKey: "Address1") != nil || defaults.value(forKey: "Address2") != nil
            ||  defaults.value(forKey: "City") != nil {
            
            var address1 = defaults.value(forKey: "Address1")
            var address2 = defaults.value(forKey: "Address2")
            var city = defaults.value(forKey: "City")
            var zip = defaults.value(forKey: "Zipcode")
            var conNum = defaults.value(forKey: "ContactNumber")
            var conName = defaults.value(forKey: "ContactName")
            var del = defaults.value(forKey: "deliverynotes")
            
            self.addres1.text = address1 as? String
            self.address2.text = address2 as? String
            self.city.text = city as? String
            self.contactNumber.text = conNum as? String
            self.contactName.text = conName as? String
            self.zipcode.text = zip as? String
            self.deliveryNotes.text = del as? String
            
        }
    }


    @IBAction func updateTapped(_ sender: UIButton) {
        
        let address1 = addres1.text!
        let addr2 = address2.text!
        let citys = city.text!
        let zip = zipcode.text!
        let conName = contactName.text!
        let conNum = contactNumber.text!
        let delery = deliveryNotes.text!
        
            defaults.set(address1, forKey: "Address1")
            defaults.set(addr2, forKey: "Address2")
            defaults.set(citys, forKey: "City")
            defaults.set(zip, forKey: "Zipcode")
            defaults.set(conName, forKey: "ContactName")
            defaults.set(conNum, forKey: "ContactNumber")
            defaults.set(delery, forKey: "deliverynotes")
            
            
            let alert = UIAlertController(title: "Address Updated", message: "Successfully!", preferredStyle: UIAlertControllerStyle.alert)
            let ok = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default)  {
                ACTION in
               self.navigationController?.popViewController(animated: true)
            }
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        

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
