//
//  OrderDetailsTableViewController.swift
//  RestaurantCustomerDelivery
//
//  Created by iqmsoft on 11/15/16.
//  Copyright © 2016 iQmSoft. All rights reserved.
//

import UIKit

class OrTableViewController: UITableViewController {

    
    //orderDetails
    @IBOutlet weak var storeName: UILabel!
    @IBOutlet weak var quantity: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var orderId: UILabel!
    @IBOutlet weak var date: UILabel!
    var defaults = UserDefaults.standard
    
    @IBOutlet weak var customeTableView: UITableView!
    
    var ordersIDs = ""
    var prics = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
       getOrdersListJSON()
      self.orderId.text = ordersIDs
        self.price.text = prics
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func getOrdersListJSON(){
        
        let ids = defaults.object(forKey: "OrderId")
        var orderid = ids! as! String
        print("ItemID to pass : \(orderid)")
        let urlString =   RequiredURLS().orderDetailsViewUrl + "\(orderid)"
        let url = NSURL(string: urlString)
        if let JSONData = NSData(contentsOf: url as! URL) {
            print(JSONData)
            if let json = (try? JSONSerialization.jsonObject(with: JSONData as Data, options: [])) as? NSDictionary {
                if let reposArray = json["basic"] as? [String: AnyObject] {
                    print("reposarray\(reposArray)")
                    if let order = reposArray["id"] as? String {
                       ordersIDs = order
                        if let prce = reposArray["price"] as? String {
                            prics = prce
                            print("orders id:\(order)   price : \(prce)")
                        }
                    }
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }


//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
////        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as?
//        if(cell == nil)
//        {
//            cell = OrderDetailsTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
//        }
////        cell?.dataArr = ["subMenu->1","subMenu->2","subMenu->3","subMenu->4","subMenu->5"]
//        return cell!
//    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
