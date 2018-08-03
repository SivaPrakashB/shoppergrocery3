//
//  OrderDetailsViewController.swift
//  RestaurantCustomerDelivery
//
//  Created by iqmsoft on 11/15/16.
//  Copyright © 2016 iQmSoft. All rights reserved.
//

import UIKit

class OrderDetailsViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {
  //basic details
    @IBOutlet weak var orderID: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var storeName: UILabel!
    @IBOutlet weak var totalQuantity: UILabel!
    @IBOutlet weak var totalPrice: UILabel!
    //address details
    @IBOutlet weak var contactName: UILabel!
    @IBOutlet weak var conPhone: UILabel!
    @IBOutlet weak var address1: UILabel!
    @IBOutlet weak var address2: UILabel!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var zipNum: UILabel!
    //items tableview
    @IBOutlet weak var tableView: UITableView!
    var defaults = UserDefaults.standard
    
    var itemsName = [String]()
    var itemQuantity = [Int]()
    var itemPrices = [Double]()
    var itemDeliveryCharges = [Double]()
    var itemPackingCost = [Double]()
    var itemDiscount = [Double]()
    var itemTotal = [Double]()
    var itemNotes = [String]()
    var itemDiscription = [String]()
    var passingstoreID  = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getBasicDetailsJSON()
        getItemsDetailsJSON()
        tableView.delegate = self
        tableView.dataSource = self
        getData()
        //clearing line if tableview has no data
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        // Do any additional setup after loading the view.
    }
    
    
    
    func getBasicDetailsJSON(){
        
        let ids = defaults.object(forKey: "OrderId")
        let orderid = ids! as! String
        print("ItemID to pass : \(orderid)")
        let urlString =   RequiredURLS().orderDetailsViewUrl + "\(orderid)"
        let url = NSURL(string: urlString)
        if let JSONData = NSData(contentsOf: url as! URL) {
            print(JSONData)
            if let json = (try? JSONSerialization.jsonObject(with: JSONData as Data, options: [])) as? NSDictionary {
                if let reposArray = json["basic"] as? [String: AnyObject] {
                    print("reposarray\(reposArray)")
                    if let order = reposArray["id"] as? String {
                              self.orderID.text = order
                        if let prce = reposArray["price"] as? String {
                             self.totalPrice.text = "$\(prce)"
                            print("orders id:\(order)   price : \(prce)")
                            if let quant = reposArray["quantity"] as? String {
                                self.totalQuantity.text = quant
                                if let dates = reposArray["date_created"] as? String {
                                    self.date.text = dates
                                    if let store = reposArray["storeName"] as? String {
                                        self.storeName.text = store
                                        if let storeid = reposArray["store_id"] as? String {
                                            passingstoreID = storeid
                                            defaults.set(passingstoreID, forKey: "PassStrD")
                                            print("StoreID to Pass : \(passingstoreID)")
                                            self.storeName.text = store
                                            print("date:\(dates)   quantity : \(quant) store : \(store)")
                                            
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                if let reposArray1 = json["address"] as? [String: AnyObject]  {
                    print("reposarray1\(reposArray1)")
                    let add1 = reposArray1["address_line1"]
                    self.address1.text = add1! as! String
                    let add2 = reposArray1["address_line2"] as! String
                    self.address2.text = add2
                    let cty = reposArray1["city"] as! String
                    self.cityName.text = cty
                    let cName = reposArray1["contact_name"] as! String
                    self.contactName.text = cName
                    //                    let cPhone = reposArray1["contact_number"] as! String
                    //                    self.conPhone.text = cPhone
                    let dsc = reposArray1["notes"] as! String
                    var descrip = dsc
                    print("add1:\(add1)   add2 : \(add2) city : \(cty) coName : \(cName) cNum : (cPhone) descrip : \(dsc)")
                    let zp = reposArray1["zipcode"] as? String
                    if let zps = zp {
                        self.zipNum.text = "Zip: \(zps)"
                    }
                    if let cPhone = reposArray1["contact_number"] as? String {
                        self.conPhone.text = "Phone: \(cPhone)"
                    }
                    
                    
                }

            }
        }
    }
    
    func getItemsDetailsJSON(){
        let ids = defaults.object(forKey: "OrderId")
        let orderid = ids! as! String
        let urlString =   RequiredURLS().orderDetailsViewUrl + "\(orderid)"
        let urlEncodedString = urlString.addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed)
        
        let url = NSURL( string: urlEncodedString!)
        let data = NSData(contentsOf: url as! URL)
//        let jsonData = JSON(data: data as! Data, options: JSONSerialization.ReadingOptions.allowFragments, error: nil)
//        var itemName =  jsonData["details"]
        
        let task = URLSession.shared.dataTask(with: url! as URL) {(data, response, innerError) in
            let json = JSON(data: data!)
            let reports = json["details"].arrayValue
            for report in reports
            {
                let id = report["itemName"].stringValue
                let itmqua = report["quantity"].intValue
                let itmprce = report["item_price"].doubleValue
                let itmdelv = report["delivery_charges"].doubleValue
                 let pck = report["packing_cost"].doubleValue
                 let discou = report["discount"].doubleValue
                 let total = report["line_total"].doubleValue
                let descr = report["notes"].stringValue
                
                print( "id: \(id) storename: \(itmqua) price: \(itmprce) Quantity :\(itmdelv)")
                self.itemsName.append(id)
                self.itemQuantity.append(itmqua)
                self.itemPrices.append(itmprce)
                self.itemDeliveryCharges.append(itmdelv)
                self.itemPackingCost.append(pck)
                self.itemDiscount.append(discou)
                self.itemTotal.append(total)
                self.itemDiscription.append(descr)
            }
            DispatchQueue.main.async(execute: {
                self.tableView!.reloadData()
            })
            
        }
        task.resume()

    }

    func addresss() {
        
        var address1 = defaults.value(forKey: "Address1")
        var address2 = defaults.value(forKey: "Address2")
        var city = defaults.value(forKey: "City")
        var zip = defaults.value(forKey: "Zipcode")
        var conNum = defaults.value(forKey: "ContactNumber")
        var conName = defaults.value(forKey: "ContactName")
        var del = defaults.value(forKey: "deliverynotes")
        
        self.address1.text = address1 as? String
        self.address2.text = address2 as? String
        self.cityName.text = city as? String
        self.conPhone.text = conNum as? String
        self.contactName.text = conName as? String
        self.zipNum.text = zip as? String
        
//        let ids = defaults.object(forKey: "OrderId")
//        var orderid = ids! as! String
//        print("ItemID to pass : \(orderid)")
//        let urlString =   RequiredURLS().orderDetailsViewUrl + "\(orderid)"
//        let url = NSURL(string: urlString)
//        if let JSONData = NSData(contentsOf: url as! URL) {
//            print(JSONData)
//            if let json = (try? JSONSerialization.jsonObject(with: JSONData as Data, options: [])) as? NSDictionary {
//                if let reposArray = json["address"] as? [String: AnyObject] {
//                    print("Address\(reposArray)")
//                    if let add1 = reposArray["address_line1"] as? String {
//                        self.address1.text = add1
//                        if let add2 = reposArray["address_line2"] as? String {
//                            self.address2.text = add2
//                            print("add1:\(add1)  add2 : \(add2)")
//                            if let city = reposArray["city"] as? String {
//                                self.cityName.text = city
//                                if let zip = reposArray["zipcode"] as? String {
//                                    self.zipNum.text = zip
//                                    if let name = reposArray["contact_name"] as? String {
//                                        self.contactName.text = name
//                                        print("city:\(city)   quantity : \(zip) store : \(name)")
//                                        if let phne = reposArray["contact_number"] as? String {
//                                            self.conPhone.text = phne
//                                            if let not = reposArray["notes"] as? String {
////                                                self..text = not
//                                            }
//                                        }
//                                    }
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//        }

    }

    @IBAction func giveFeedbackTapped(_ sender: UIBarButtonItem) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "Feedback")
        let popUp : BIZPopupViewController = BIZPopupViewController.init(contentViewController: viewController, contentSize: CGSize(width: 320, height: 330))
        self.present(popUp, animated: true, completion: nil)
        
    }

    func address() {
        let ids = defaults.object(forKey: "OrderId")
        var orderid = ids! as! String
        let urlString =   RequiredURLS().orderDetailsViewUrl + "\(orderid)"
        let url = NSURL(string: urlString)
        if let JSONData = NSData(contentsOf: url as! URL) {
            print(JSONData)
            if let json = (try? JSONSerialization.jsonObject(with: JSONData as Data, options: [])) as? NSDictionary {
                if let reposArray = json["address"] as? [String: AnyObject] {
                    print("reposarray\(reposArray)")
                    if let zip = reposArray["zipcode"] as? String {
                            self.zipNum.text = zip
                        if let add1 = reposArray["address_line1"] as? String {
                              self.address1.text = add1
                            if let city = reposArray["city"] as? String {
                                  self.cityName.text = city
                                if let connme = reposArray["contact_name"] as? String {
                                      self.contactName.text = connme
                                    if let add2 = reposArray["address_line2"] as? String {
                                        self.address2.text = add2
                                        if let phne = reposArray["contact_number"] as? String {
                                             self.conPhone.text = phne
                                            if let dates = reposArray["notes"] as? String {
                                                self.date.text = dates
                                                 print("zip:\(zip)   add1 : \(add1)  city :  \(city) contactnme : \(connme) add2 :\(add2) pone :\(phne) date:\(dates) ")
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! OrderDetailsTableViewCell
        cell.itemNameLabel.text = itemsName[indexPath.row]
        cell.deliveryCharges.text = "$\(String(itemDeliveryCharges[indexPath.row]))"
        cell.discount.text = "\(String(itemDiscount[indexPath.row]))%"
        cell.itemPrice.text = "$\(String(itemPrices[indexPath.row]))"
        cell.descriptions.text = itemDiscription[indexPath.row]
        cell.qunatity.text = "X\(String(itemQuantity[indexPath.row]))"
        cell.packingCost.text = "$\(String(itemPackingCost[indexPath.row]))"
        cell.totalPrice.text = "$\(String(itemTotal[indexPath.row]))"

        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
