//
//  AddressCellViewController.swift
//  RestaurantCustomerDelivery
//
//  Created by iqmsoft on 11/14/16.
//  Copyright © 2016 iQmSoft. All rights reserved.
//

import UIKit

class AddressCellViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {

    @IBOutlet var mainView: UIView!
    
    @IBOutlet weak var addressLine1: UILabel!
    @IBOutlet weak var addressLine2: UILabel!
    @IBOutlet weak var contctName: UILabel!
    @IBOutlet weak var contactNum: UILabel!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var zipcode: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var deliveryTextView: UITextView!
    
    var defaults = UserDefaults.standard
    
    var addDetails : [Address] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      showingDetails()
        getData()
       
         self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        showingDetails()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
     func getAddressData() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            addDetails = try context.fetch(Address.fetchRequest())
        } catch {
            print("Data couldn't fetched")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = ""
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let viewController = storyboard.instantiateViewController(withIdentifier: "Address")
//       let popUp : BIZPopupViewController = BIZPopupViewController.init(contentViewController: viewController, contentSize: CGSize(width: 350, height: 260))
//        self.present(popUp, animated: true, completion: nil)

    }
    
    func showingDetails() {
        
        if defaults.value(forKey: "Address1") != nil || defaults.value(forKey: "Address2") != nil
        ||  defaults.value(forKey: "City") != nil {
            self.tableView.isHidden = true
             var address1 = defaults.value(forKey: "Address1")
             var address2 = defaults.value(forKey: "Address2")
             var city = defaults.value(forKey: "City")
             var zip = defaults.value(forKey: "Zipcode")
             var conNum = defaults.value(forKey: "ContactNumber")
             var conName = defaults.value(forKey: "ContactName")
             var del = defaults.value(forKey: "deliverynotes")
            
            self.addressLine1.text = address1 as? String
            self.addressLine2.text = address2 as? String
            self.city.text = city as? String
            self.contactNum.text = conNum as? String
            self.contctName.text = conName as? String
            self.zipcode.text = zip as? String
            self.deliveryTextView.text = del as? String
            
        } else {
            self.tableView.isHidden = false
        }
       
    }
    
    @IBAction func update(_ sender: UIButton) {
        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let viewController = storyboard.instantiateViewController(withIdentifier: "EditAddress")
//        let popUp : BIZPopupViewController = BIZPopupViewController.init(contentViewController: viewController, contentSize: CGSize(width: 350, height: 260))
//        self.present(popUp, animated: true, completion: nil)
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
