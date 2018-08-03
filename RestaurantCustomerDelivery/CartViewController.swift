//
//  CartViewController.swift
//  RestaurantCustomerDelivery
//
//  Created by iqmsoft on 11/12/16.
//  Copyright © 2016 iQmSoft. All rights reserved.
//

import UIKit


class CartViewController: UIViewController , UITableViewDataSource , UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var placeOrderOutlet: UIButton!
    
    var price : [Double] = []
    var itemID : [Int] = []
    var quant = [Int]()
    var storeName = [String]()
    var items = [String]()
    var storeID = [Int]()
    var notes = [String]()
    var itemName = [String]()
    
    var itemArrayToString : String = ""
    var quantityArrayToString : String = ""
    var notesArrayToString : String = ""
    
    var defaults = UserDefaults.standard
    
    var item : [ItemDetails] = []
    var totalQuantity : Int32 = 0
    var totalPrice = 0.0
    var strID = 0
   
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
         getData()
       hidingOutlets()
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
    NotificationCenter.default.addObserver(self, selector: #selector(CartViewController.cartList(notification:)),name:NSNotification.Name(rawValue: "CartList"), object: nil)
              // Do any additional setup after loading the view.
    }

    func cartList(notification: NSNotification){
        getData()
        self.tableView!.reloadData()
    }
   
    func hidingOutlets() {
        if item.isEmpty == true {
            self.placeOrderOutlet.isHidden = true
            self.totalLabel.isHidden = true
            let tabArray = self.tabBarController?.tabBar.items as NSArray!
            let tabItem = tabArray?.object(at: 3) as! UITabBarItem
            tabItem.badgeValue = nil
        } else {
            self.placeOrderOutlet.isHidden = false
            self.totalLabel.isHidden = false
            getData()
            print(item)
            tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
         hidingOutlets()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        getData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if item.isEmpty == false {
            self.placeOrderOutlet.isHidden = false
             self.totalLabel.isHidden = false
            self.totalLabel.text = "Total : \(String(totalPrice))"
        }
        else {
            self.placeOrderOutlet.isHidden = true
             self.totalLabel.isHidden = true
            let tabArray = self.tabBarController?.tabBar.items as NSArray!
            let tabItem = tabArray?.object(at: 3) as! UITabBarItem
            tabItem.badgeValue = nil
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clearAllTapped(_ sender: UIBarButtonItem) {
        deleteItems()
        totalPrice = 0.0
        let tabArray = self.tabBarController?.tabBar.items as NSArray!
        let tabItem = tabArray?.object(at: 3) as! UITabBarItem
        tabItem.badgeValue = nil
        self.placeOrderOutlet.isHidden = true
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
            
//            let icon : UIImage = UIImage(named: "Sad")!
//            let iconView : UIImageView = UIImageView(image: icon)
//            iconView.frame = CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height)
//            tableView.backgroundView?.addSubview(iconView)
            
            noDataLabel.text             = "Place an order,cart looks empty."
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
    
    override func getData() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
        item = try context.fetch(ItemDetails.fetchRequest()) as [ItemDetails]
            if item.isEmpty != true {
                var totalQua = 0
                var totalPr = 0
            for items in item {
                itemID.append(Int(items.itemid))
                print("Array ItemIDs///:\(itemID)")
                quant.append(Int(items.quantity))
                notes.append(items.notes!)
                strID = items.value(forKey: "storeid") as! Int
                let quantity = items.value(forKey: "quantity") as! Int
                let total = items.value(forKey: "price") as! Double
               if item.isEmpty == true {
                  totalPrice = 0.0
               } else {
                totalPrice += total
                self.totalLabel.text = "Total : \(String(totalPrice))"
                }
                totalQua += quantity
                totalQuantity = Int32(totalQua)
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
//            for order in item {
//                let quantity = order.value(forKey: "quantity") as! Int
//                let total = order.value(forKey: "price") as! Int
//                strID = order.value(forKey: "storeid") as! Int
//                totalQua += quantity
//                totalPrice += total
//                self.totalLabel.text = String(totalPrice)
//                totalQuantity = Int32(totalQua)
//                
//              }
            print("total quantity = \(totalQua)")
            } else {
                print("it's empty here")
                self.placeOrderOutlet.isHidden = true
                self.totalLabel.isHidden = true
            }
        } catch {
            print("Data couldn't fetched")
        }
    }
    
    func deleteItems() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        
        do
        {
            self.item = try managedContext.fetch(ItemDetails.fetchRequest())
            for managedObject in self.item
            {
                managedContext.delete(managedObject)
            }
            try managedContext.save()
        } catch let error as NSError {
            print("Detele all data in \(ItemDetails.self) error : \(error) \(error.userInfo)")
        }
        self.totalPrice = 0.0
        self.item.removeAll()
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        if editingStyle == .delete {
            let items = item[indexPath.row]
            context.delete(items)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            do {
                item = try context.fetch(ItemDetails.fetchRequest())
                getData()
                
            } catch {
                print("Data couldn't fetched")
            }
        }
        tableView.reloadData()
    }
    
    @IBAction func placeOrderTapped(_ sender: UIButton) {
     
     if ((defaults.value(forKey: "Address1") != nil) || (defaults.value(forKey: "Zipcode") != nil)  || (defaults.value(forKey: "City") != nil)  || (defaults.value(forKey: "ContactNumber") != nil)) {
                if item.isEmpty != true {
                    let address1 = defaults.value(forKey: "Address1") as! String
                    let address2 = defaults.value(forKey: "Address2") as! String
                    let city = defaults.value(forKey: "City") as! String
                    if let zip = defaults.value(forKey: "Zipcode") as? String {
                    print(zip)
                    }
                let conNum = defaults.value(forKey: "ContactNumber") as! String
                let conName = defaults.value(forKey: "ContactName") as! String
                let del = defaults.value(forKey: "deliverynotes") as! String
                
                let cusID = defaults.object(forKey: "CustomerId")
                let cusID1 = cusID!
                
                let post : NSString =  "customer_id=\(cusID1)&store_id=\(strID)&total_quantity=\(totalQuantity)&price=\(totalPrice)&item_id=\(itemArrayToString)&quantity=\(quantityArrayToString)&notes=\(notesArrayToString)&address_line1=\(address1)&address_line2=\(address2)&city=\(city)&contact_name=\(conName)&contact_number=\(conNum)&delivery_notes=\(del)" as NSString
                
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
                            self.deleteItems()
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
