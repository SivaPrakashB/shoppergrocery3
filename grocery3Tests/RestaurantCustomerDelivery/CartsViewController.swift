//
//  CartsViewController.swift
//  RestaurantCustomerDelivery
//
//  Created by iqmsoft on 12/1/16.
//  Copyright © 2016 iQmSoft. All rights reserved.
//

import UIKit

class CartsViewController: UIViewController , UITableViewDataSource , UITableViewDelegate {
    
   //outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var placeOrderOutlet: UIButton!
    
    //login and address
    @IBOutlet weak var plsLoginLabel: UILabel!
    @IBOutlet weak var loginOutlet: UIButton!
    @IBOutlet weak var addressSelectionSegment: UISegmentedControl!
    
    //address variables
    var addressLine1 = ""
    var addressLine2 = ""
    var addCity = ""
    var addZip = ""
    var addContactName = ""
    var addContactNum = ""
    var addDelvrynotes = ""
    
    //user defaults variable
    var defaults = UserDefaults.standard
    
    //variables
    var item : [ItemDetails] = []
    var totalQuantity : Int32 = 0
    var totalPrice = 0.0
    var strID = 0
    
    // array variables to store values
    var price : [Double] = []
    var itemID : [Int] = []
    var quant = [Int]()
    var storeName = [String]()
    var items = [String]()
    var storeID = [Int]()
    var notes = [String]()
    var itemName = [String]()
    
    //storing array to string converted valuws
    var itemArrayToString : String = ""
    var quantityArrayToString : String = ""
    var notesArrayToString : String = ""
    
    //managed object context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //getting data from coredata
        getData()
        //clearing line if tableview has no data
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        //to refresh the list after adding to cart
        NotificationCenter.default.addObserver(self, selector: #selector(CartsViewController.cartsList(notification:)),name:NSNotification.Name(rawValue: "CartsList"), object: nil)
        hidingLoginMethod()
        // Do any additional setup after loading the view.
    }

    
    func cartsList(notification: NSNotification){
        do {
          item = try context.fetch(ItemDetails.fetchRequest()) as [ItemDetails]
            totalClaculation()
          self.tableView!.reloadData()
        } catch {
          print("error in Refreshing the table view.")
        }
    }
    
    func hidingLoginMethod() {
        if item.count != 0 {
           if defaults.object(forKey: "CustomerId") != nil {
            self.loginOutlet.isHidden = true
            self.plsLoginLabel.isHidden = true
            self.placeOrderOutlet.isEnabled = true
            } else {
            self.loginOutlet.isHidden = false
            self.plsLoginLabel.isHidden = false
            self.placeOrderOutlet.isEnabled = false
          }
        } else{
            self.loginOutlet.isHidden = true
            self.plsLoginLabel.isHidden = true
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        totalClaculation()
        hidingLoginMethod()
    }
    
    
    @IBAction func addressAction(_ sender: UISegmentedControl) {
        
    }
    
    @IBAction func loginAction(_ sender: UIButton) {
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone
        {
            let storyboard=UIStoryboard(name: "Main", bundle: nil)
            var viewcontroller = UIViewController()
            viewcontroller = storyboard.instantiateViewController(withIdentifier: "LoginPage") as! ViewController
            present(viewcontroller, animated: true, completion: nil)
        }
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad
        {
            let storyboard=UIStoryboard(name: "Second", bundle: nil)
            var viewcontroller=UIViewController()
            viewcontroller = storyboard.instantiateViewController(withIdentifier: "IpadLoginPage") as! ViewController
            present(viewcontroller, animated: true, completion: nil)
        }
    }
    
    @IBAction func clearAllTapped(_ sender: UIBarButtonItem) {
       //alert message
        let myAlert = UIAlertController(title: "Are you sure" as String, message: "Cart will be cleared!", preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "Delete", style: UIAlertActionStyle.destructive)
        {
            ACTION in
             self.deleteAll()
            self.totalClaculation()
            self.tabBarItemBadge()
            self.loginOutlet.isHidden = true
            self.plsLoginLabel.isHidden = true
        }
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default)
        myAlert.addAction(okAction)
        myAlert.addAction(cancel)
        self.present(myAlert, animated: true, completion: nil)
    }
    
    //total calculation 
    func totalClaculation() {
        do{
            item = try context.fetch(ItemDetails.fetchRequest()) as [ItemDetails]
            //to add total quantity
            var totalQua = 0
            totalPrice = 0.0
            if item.count == 0 {
                self.loginOutlet.isHidden = true
                self.plsLoginLabel.isHidden = true
                self.totalLabel.isHidden = true
                self.placeOrderOutlet.isHidden = true
                totalPrice = 0.0
                print("No data in itemdetails to calculate total")
            } else {
                for items in item {
                    let quantity = items.value(forKey: "quantity") as! Int
                    let total = items.value(forKey: "price") as! Double
                    totalPrice += total
                    self.totalLabel.text = "Total : $\(String(totalPrice))"
                    totalQua += quantity
                    totalQuantity = Int32(totalQua)
                    self.totalLabel.isHidden = false
                    self.placeOrderOutlet.isHidden = false
                }

            }
        } catch {
            print("Data couldn't stored to arrays")
        }
    }
    
    //Storing itemdetails to arrays calculation
    func allDetails() {
        do{
            item = try context.fetch(ItemDetails.fetchRequest()) as [ItemDetails]
            if item.count == 0 {
                print("No data in itemdetails to store in arrays")
            } else {
                print("item count: \(item.count)")
                //for loop to store values in arrays
                for items in item {
                    itemID.append(Int(items.itemid))
                    print("Array ItemIDs///:\(itemID)")
                    quant.append(Int(items.quantity))
                    notes.append(items.notes!)
                    strID = items.value(forKey: "storeid") as! Int
                }
                let itemIdArray = itemID.flatMap { String($0) }
                itemArrayToString = itemIdArray.joined(separator: ",")
                print("Item array to string:\(itemArrayToString)")
                
                let quantArray = quant.flatMap { String($0) }
                quantityArrayToString = quantArray.joined(separator: ",")
                print("quant array to string:\(quantityArrayToString)")
                
                let notesArray = notes.flatMap { String($0) }
                notesArrayToString = notesArray.joined(separator: ",")
                print("notes array to string:\(notesArrayToString)")
            }
        } catch {
            print("Data couldn't stored to arrays")
        }
    }
    
    //getting data from coredata
    override func getData() {
        do{
            item = try context.fetch(ItemDetails.fetchRequest()) as [ItemDetails]
            //checking if data is nil
            if item.count == 0 {
                self.totalLabel.isHidden = true
                self.placeOrderOutlet.isHidden = true
                totalPrice = 0.0
                print("No data in itemdetails")
            } else {
                print("item count: \(item.count)")
               //for loop to store values in arrays
                for items in item {
                    let total = items.value(forKey: "price") as! Double
                    totalPrice += total
                    self.totalLabel.text = "Total : $\(String(totalPrice))"
                }

            }
        } catch {
            print("Data couldn't fetched")
        }
    }
    
    //total label
    func getTotalChange() {
        do{
            item = try context.fetch(ItemDetails.fetchRequest()) as [ItemDetails]
            if item.count == 0 {
                self.totalLabel.isHidden = true
                self.placeOrderOutlet.isHidden = true
                totalPrice = 0.0
                print("No data in itemdetails to change total")
            } else {
                for items in item {
                    let total = items.value(forKey: "price") as! Double
                    totalPrice += total
                    self.totalLabel.text = "Total : $\(String(totalPrice))"
                }
            }
        } catch {
            print("total couldn't fetched")
        }
    }
    
    //tab bat item badge changing
    func tabBarItemBadge() {
        if item.count == 0 {
            let tabArray = self.tabBarController?.tabBar.items as NSArray!
            let tabItem = tabArray?.object(at: 3) as! UITabBarItem
            tabItem.badgeValue = nil
        } else {
            let count = item.count
            let tabArray = self.tabBarController?.tabBar.items as NSArray!
            let tabItem = tabArray?.object(at: 3) as! UITabBarItem
            tabItem.badgeValue = String(count)
        }
    }
    
    //Deleting data from coredata
    func deleteAll() {
         getData()
        if let tv = tableView {
            
            for bas in item
            {
                context.delete(bas)
            }
            item.removeAll(keepingCapacity: false)
            tv.reloadData()
            do{
            try context.save()
            } catch let error as NSError {
                print("Detele all data in \(ItemDetails.self) error : \(error) \(error.userInfo)")
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        var numOfSections: Int = 0
        if item.count > 0
        {
            tableView.separatorStyle = .singleLine
            numOfSections                = 1
            tableView.backgroundView = nil
        }
        else
        {
            numOfSections                = 1
            let noDataLabel: UILabel     = UILabel(frame: CGRect(x:0, y:0, width:tableView.bounds.size.width, height :tableView.bounds.size.height))
            noDataLabel.text             = "Place an order cart looks empty."
            noDataLabel.textColor        = UIColor.lightGray
            noDataLabel.adjustsFontSizeToFitWidth = true
            noDataLabel.font = noDataLabel.font.withSize(36)
            noDataLabel.numberOfLines = 2
            noDataLabel.textAlignment    = .center
            tableView.backgroundView = noDataLabel
            tableView.separatorStyle = .none
        }
        return numOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return item.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CartTableViewCell
        let items = item[indexPath.row]
        cell.itemName.text = items.itemname
        cell.price.text = "$\(String(items.price))"
        cell.storeName.text = items.storename
        cell.quantity.text = "\(items.quantity) x \(items.itemname!)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let items = item[indexPath.row]
            do{
                context.delete(items)
                item.remove(at: indexPath.row)
                try context.save()
                self.tableView.deleteRows(at: [indexPath], with: .fade)
                
            } catch {
                print("Data couldn't fetched")
            }
            totalClaculation()
            tabBarItemBadge()
        }
        
    }
    

    @IBAction func placeOrderTapped(_ sender: UIButton) {
        
        if ((defaults.value(forKey: "Address1") != nil) || (defaults.value(forKey: "Zipcode") != nil)  || (defaults.value(forKey: "City") != nil)  || (defaults.value(forKey: "ContactNumber") != nil)) {
            if item.isEmpty != true {
                
             //calling method
                allDetails()
                
                addressLine1 = defaults.value(forKey: "Address1") as! String
                addressLine2 = defaults.value(forKey: "Address2") as! String
                addCity = defaults.value(forKey: "City") as! String
                if let zip = defaults.value(forKey: "Zipcode") as? String {
                    print(zip)
                    addZip = zip
                }
                addContactNum = defaults.value(forKey: "ContactNumber") as! String
                addContactName = defaults.value(forKey: "ContactName") as! String
                addDelvrynotes = defaults.value(forKey: "deliverynotes") as! String
                
                let cusID = defaults.object(forKey: "CustomerId")
                let cusID1 = cusID!
                
                 let post : NSString =  "customer_id=\(cusID1)&store_id=\(strID)&total_quantity=\(totalQuantity)&price=\(totalPrice)&item_id=\(itemArrayToString)&quantity=\(quantityArrayToString)&notes=\(notesArrayToString)&address_line1=\(addressLine1)&address_line2=\(addressLine2)&city=\(addCity)&contact_name=\(addContactName)&contact_number=\(addContactNum)&delivery_notes=\(addDelvrynotes)&zipcode=\(addZip)" as NSString
                NSLog("PostData: %@",post);
                
                let url : NSURL = NSURL(string: RequiredURLS().postOrderUrl)!
                
                let postData   : NSData   =  post.data(using: String.Encoding.ascii.rawValue)! as NSData
                let postLength : NSString =  String( postData.length ) as NSString
                let request    : NSMutableURLRequest = NSMutableURLRequest(url: url as URL)
                request.httpMethod = "POST"
                request.httpBody = postData as Data
                request.setValue(postLength as String, forHTTPHeaderField: "Content-Length")
                request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                request.setValue("application/json", forHTTPHeaderField: "Accept")
                
                var responseError : NSError?
                var response : URLResponse?
                var urlData : NSData?
                
                do
                {
                    urlData = try NSURLConnection.sendSynchronousRequest(request as URLRequest, returning: &response) as NSData?
                } catch let error as NSError
                {
                    responseError = error
                    urlData = nil
                }
                if urlData != nil
                {
                    let res = response as! HTTPURLResponse
                    NSLog("Response code: %ld", res.statusCode)
                    if res.statusCode >= 200 && res.statusCode <= 300
                    {
                        var responseData:NSString = NSString(data:urlData! as Data, encoding:String.Encoding.utf8.rawValue)!
                        NSLog("Response ==> %@", responseData);
                        var error: NSError?
                        
                        let myAlert = UIAlertController(title: "Order Placed Successfully" as String, message: "Thankyou!", preferredStyle: UIAlertControllerStyle.alert)
                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
                        {
                            ACTION in
                            self.deleteAll()
                            self.tabBarItemBadge()
                            self.totalLabel.isHidden = true
                            self.placeOrderOutlet.isHidden = true
                            NotificationCenter.default.post(name:NSNotification.Name(rawValue: "OrderList"), object: nil)
                        }
                        myAlert.addAction(okAction)
                        self.present(myAlert, animated: true, completion: nil)
                    }
                    else {
                        let alertView:UIAlertView = UIAlertView()
                        alertView.title           = "Sign in Failed!"
                        alertView.message         = "Connection Failed"
                        alertView.delegate        = self
                        alertView.addButton(withTitle: "OK")
                        alertView.show()
                    }
                }
                else
                {
                    let alertView:UIAlertView = UIAlertView()
                    alertView.title = "Sign in Failed!"
                    alertView.message = "Connection Failure"
                    if let error = responseError
                    {
                        alertView.message = (error.localizedDescription)
                    }
                    alertView.delegate = self
                    alertView.addButton(withTitle: "OK")
                    alertView.show()
                }
 
            } else {
                
                let myAlert = UIAlertController(title: "Cart looks empty!" as String, message: "place an order", preferredStyle: UIAlertControllerStyle.alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
                {
                    ACTION in
                }
                myAlert.addAction(okAction)
                self.present(myAlert, animated: true, completion: nil)
    
            }
            
        } else {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "Address")
            let popUp : BIZPopupViewController = BIZPopupViewController.init(contentViewController: viewController, contentSize: CGSize(width: 350, height: 260))
            self.present(popUp, animated: true, completion: nil)
            
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

extension UIViewController {

    func getData() {
        do{
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
           let item = try context.fetch(ItemDetails.fetchRequest()) as [ItemDetails]
            //checking if data is nil
            if item.count == 0 {
                let tabArray = self.tabBarController?.tabBar.items as NSArray!
                let tabItem = tabArray?.object(at: 3) as! UITabBarItem
                tabItem.badgeValue = nil
                print("No data in itemdetails in extension")
            } else {
                let count = item.count
                let tabArray = self.tabBarController?.tabBar.items as NSArray!
                let tabItem = tabArray?.object(at: 3) as! UITabBarItem
                tabItem.badgeValue = String(count)
                print("item count: \(item.count)")
                //for loop to store values in arrays
            }
        } catch {
            print("Data couldn't fetched")
        }
    }

}
