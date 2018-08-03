//
//  orderShowTableView.swift
//  grocery3
//
//  Created by mac on 8/26/17.
//  Copyright © 2017 mac. All rights reserved.
//

import UIKit

class orderShowTableView: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    var orderlist1=[NSDictionary]()
  

    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
gettingOrderList()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func gettingOrderList()
    {
        let id1=UserDefaults.standard.object(forKey: "orderid3")
        print("orderid3:\(id1)")
       let url=URL(string:"http://zenith.instest.net/groceryapi/customer/orderview/\(id1!)")
        URLSession.shared.dataTask(with: url!)
        {
            (data,response,error)
            in
            
            if(error != nil)
            {
                print("error")
            }
            else{
                do{let resultJSON=try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions())
                if let dictionary = resultJSON as? [String: Any]
                    {
                        let name = dictionary["details"] as! NSArray
                       
                      
                        
                        for value in name{
                            
                            
                            let dicValue = value as! NSDictionary
                            // print("bvspvalue:  \(dicValue)")
                            
                            
                            self.orderlist1.append(dicValue)
                            
                            print(self.orderlist1)
                            
                        }
                        
                    }
                    }
                    
                catch
                {
                    print("json not performed well")
                }
                DispatchQueue.main.async(execute:
                    {
                    self.tableview!.reloadData()
                })

            }
            
            }.resume()
    }
    

  /*  func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
*/
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
       
        
        return (self.orderlist1.count)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "CELL") as! orderShowTableCell
     let simpleEntry : NSDictionary = self.orderlist1[indexPath.row]
        let id1=UserDefaults.standard.object(forKey: "orderid3")
        cell.orderid.text="\(id1!)"
        cell.productname.text=(simpleEntry["product_name"]! as! String)
        cell.brand.text=(simpleEntry["brand"]! as! String)
        cell.weight.text=(simpleEntry["weight"]! as! String)
        cell.description2.text=(simpleEntry["description"]! as! String)
        cell.quality.text=(simpleEntry["qty"]! as! String)



        
        // Configure the cell...
        
        return cell
    }
        // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
   /* override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    /*func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let simpleEntry : NSDictionary = self.orderlist1[indexPath.row]
        var orderProductId:String=(simpleEntry["id"]! as! String)
        print("orderproductid:\(orderProductId)")
        UserDefaults.standard.set(orderProductId, forKey: "orderid2")
        /*  print(weburl1)
         let settingsUrl = URL(string:"http://\(weburl1)") as! URL
         print(settingsUrl)*/
        
    }*/

}
