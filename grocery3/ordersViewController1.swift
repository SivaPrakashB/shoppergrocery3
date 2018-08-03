//
//  ordersViewController1.swift
//  grocery3
//
//  Created by mac on 10/10/17.
//  Copyright © 2017 mac. All rights reserved.
//

import UIKit

class ordersViewController1: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    let id=UserDefaults.standard.object(forKey: "id")

    @IBOutlet weak var Tableview: UITableView!
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    var searchActive:Bool=false
    var filteredOrders = [NSDictionary]()
    var ordersList = [NSDictionary]()
    var order1no:String=""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        gettingOrdersList()
        // Do any additional setup after loading the view.
    }
    
       func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //self.searchbar.endEditing(true)
        searchActive = false;
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredOrders = ordersList.filter({ (text) -> Bool in
            let tmp = text.object(forKey: "store_name") as! NSString
            let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            return range.location != NSNotFound
        })
        
        
        if(filteredOrders.count == 0 ){
            searchActive = false;
            self.Tableview.reloadData()
        } else {
            searchActive = true;
        }
        self.Tableview.reloadData()
    }
    
    func gettingOrdersList() {
        //       let urlString = RequiredURLS().storesUrl
        //   print("urlString : \(urlString)")
        let id=UserDefaults.standard.object(forKey: "id")
        let url = URL(string: "http://zenith.instest.net/groceryapi/customer/ordershow/144")
        URLSession.shared.dataTask(with:url!) { (data, response, error) in
            if error != nil {
                print(error)
            } else {
                do{
                    let resultJSON = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions())
                    let arrayJSON = resultJSON as! NSArray
                    print("bvsp Array: \(arrayJSON)")
                    
                    for value in arrayJSON{
                        
                        
                        let dicValue = value as! NSDictionary
                        // print("bvspvalue:  \(dicValue)")
                        print("bvsp---------\(dicValue)")
                        
                        self.ordersList.append(dicValue)
                        
                        //print(self.ordersList)
                    }
                    
                }
                catch {
                    print("Received not-well-formatted JSON")
                }
                DispatchQueue.main.async(execute: {
                    self.Tableview!.reloadData()
                })
                
            }
            
            }.resume()
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ordersList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CELL") as! ordersTableViewCell1
        let simpleEntry : NSDictionary = self.ordersList[indexPath.row]
        order1no="\(simpleEntry["orderno"]!)"
        let ordersettonil="<null>"
        if order1no.isEqual(ordersettonil)
        {
            order1no=""
        }
        
        cell.orderno.text=order1no
        
        cell.DeliveryDateAndTime.text="\(simpleEntry["delivery_date"]!) \(simpleEntry["delivery_time"]!)"
        var deliverydate1="\(simpleEntry["delivery_date"]!)"
        UserDefaults.standard.set(deliverydate1, forKey: "deliverydate1")
        var deliverytime1="\(simpleEntry["delivery_time"]!)"
        UserDefaults.standard.set(deliverytime1, forKey: "deliverytime1")
        cell.orderDate.text="\(simpleEntry["orderdate"]!)"
        cell.Address.text="\(simpleEntry["apt_name"]!),\(simpleEntry["street"]!), \n\(simpleEntry["city"]!),\(simpleEntry["state"]!), \n\(simpleEntry["country"]!),\n\(simpleEntry["zipcode"]!)"
        var address1="\(simpleEntry["apt_name"]!),\(simpleEntry["street"]!), \n\(simpleEntry["city"]!),\(simpleEntry["state"]!), \n\(simpleEntry["country"]!),\n\(simpleEntry["zipcode"]!)"
        UserDefaults.standard.set(address1, forKey: "address1")
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let simpleEntry : NSDictionary = self.ordersList[indexPath.row]
        var ordertmp:String=(simpleEntry["id"]! as! String)
        print("ordertmp:\(ordertmp)")
        UserDefaults.standard.set(ordertmp, forKey: "orderid3")
        /*  print(weburl1)
         let settingsUrl = URL(string:"http://\(weburl1)") as! URL
         print(settingsUrl)*/
        
    }
    
    
   }
