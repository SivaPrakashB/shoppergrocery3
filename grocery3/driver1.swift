//
//  driver1.swift
//  grocery3
//
//  Created by mac on 9/7/17.
//  Copyright © 2017 mac. All rights reserved.
//

import UIKit

class driver1: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var tableview: UITableView!
    
    @IBOutlet weak var driver: UIButton!
    
    @IBOutlet weak var address: UILabel!
    
    @IBOutlet weak var deliverydate: UILabel!
    
    @IBOutlet weak var deliverytime: UILabel!
   
     var driverids = [NSDictionary]()
   
     var cell : UITableViewCell?
    
     var  simpleEntry = [NSDictionary]()
    
    
     override func viewDidLoad()
     {
        
        super.viewDidLoad()
        
        getDriverNames()
        // Do any additional setup after loading the view.
        
        self.tableview.isHidden = true

        
        var deliverydate11=UserDefaults.standard.object(forKey: "deliverydate1")
        
        self.deliverydate.text=deliverydate11 as! String
        
        var  deliverytime11=UserDefaults.standard.object(forKey: "deliverytime1")
        
        self.deliverytime.text=deliverytime11 as! String
        
        self.tableview.delegate=self
        
        self.tableview.dataSource=self
    }

    override func didReceiveMemoryWarning()
    {
    
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func DriverButton(_ sender: UIButton)
    {
        
        if self.tableview.isHidden == false
        {
        
            self.tableview.isHidden = true
        }
        else
        {
            self.tableview.isHidden = false
        }

    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return driverids.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let simpleEntry : NSDictionary = self.driverids[indexPath.row]
    
        let cellIdentifier : String = "Cell"
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        
        if cell == nil
        {
        
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: cellIdentifier)
          
            cell!.textLabel?.text = "\(simpleEntry["name"]!)"
        }
        // Configure the cell...
        cell!.textLabel?.text = "\(simpleEntry["name"]!)"
       
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell : UITableViewCell = self.tableview.cellForRow(at: indexPath as IndexPath)!
        
        self.driver.setTitle(cell.textLabel?.text, for: UIControlState.normal)
        
        let simpleEntry : NSDictionary = self.driverids[indexPath.row]
        
        var driver_id1:String=(simpleEntry["id"]! as! String)
        
        print("ordertmp:\(driver_id1)")
        
        UserDefaults.standard.set(driver_id1, forKey: "driver_id1")

        self.tableview.isHidden = true
        
        tableview.reloadData()
    }
    func getDriverNames()
    {
        
        let url = URL(string: "http://zenith.instest.net/groceryapi/shopper/getdriver/")
        
        URLSession.shared.dataTask(with:url!)
        { (data, response, error) in
        
            if error != nil
            {
            
                print(error)
            }
            else
            {
            
                do
                {
                    let resultJSON = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions())
                
                    let arrayJSON = resultJSON as! NSArray
                    print("bvsp Array: \(arrayJSON)")
                    
                    for value in arrayJSON{
                        
                        let dicValue = value as! NSDictionary
                        
                        for (key,value) in dicValue{
                        
                            print(key)
                            
                            if "first_name"=="\(key)"
                            
                            {var value1="\(value)"
                            
                                if value1 != "<null>"
                                
                                {
                                    UserDefaults.standard.set(value, forKey:"firstname1")
                                }
                            }
                            if "last_name"=="\(key)"
                            {
                                var value1="\(value)"
                                
                                if value1 != "<null>"
                                
                                {
                                
                                    UserDefaults.standard.set(value, forKey:"lastname1")
                                }
                            }
                            
                            if "id"=="\(key)"
                            {
                                var value1="\(value)"
                                
                                if value1 != "<null>"
                                {
                                    UserDefaults.standard.set(value, forKey:"driverId")
                                }
                            }                                                   }
                        
                        
                        var fname=UserDefaults.standard.object(forKey: "firstname1")
                        
                        var lname=UserDefaults.standard.object(forKey: "lastname1")
                        
                        var Did=UserDefaults.standard.object(forKey: "driverId")
                        
                        var name12="\(fname!)"+"\(lname!)"
                        
                        print("name:\(name12)")
                        
                        var dict1=["name":"\(name12)","id":"\(Did!)" ]
                        
                        self.driverids.append(dict1 as NSDictionary)
                        

                    }
                    

                  
                }
                catch
                {
                    print("Received not-well-formatted JSON")
                }
                DispatchQueue.main.async(execute:
                    {
                    self.tableview!.reloadData()
                })
                
            }
            
            }.resume()
        
        var  address11=UserDefaults.standard.object(forKey: "address1")
        
        self.address.text=address11 as! String

         }

    @IBAction func submitDetails(_ sender: UIButton) {
        

        let driver_id=UserDefaults.standard.object(forKey: "driver_id1")
        
        
        let order_id=UserDefaults.standard.object(forKey: "orderid3")
        print("orderd_id:\(order_id)")

        let mySession = URLSession.shared
        
        //api url link//
        let url: NSURL! = NSURL(string: "http://zenith.instest.net/groceryapi/customer/work_order")!
        
        //making api request//
        
        let request = NSMutableURLRequest(url: url as URL)
 
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        //api method declation//
        
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        request.httpMethod = "POST"
        
        
        //api fields//
        
        let data = "driver_id=\(driver_id!)&order_id=\(order_id!)"
        
        request.httpBody = data.data(using: String.Encoding.ascii)
        
        let task = mySession.dataTask(with: request as URLRequest, completionHandler: {
        
            (data, response, error) in
            
            if let error = error
            {
                print(error)
            }
            
            if let data = data
            {
                
                print("data =\(data)")
            }
            
            //reading return responsive//
            
            if let response = response {
            
                print("url = \(response.url!)")
                
                print("response = \(response)")
                
                let httpResponse = response as! HTTPURLResponse
                
                print("response code = \(httpResponse.statusCode)")
                
                
                // Print out reponse body
                
                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                
                print("****** response data = \(responseString!)")
                
                //*********only successfully message coming and response data ******//
                
                OperationQueue.main.addOperation{
                    
                    //if you response is json do the following
                    let alert = UIAlertController(title: "", message: "Order Assigned Successfully!", preferredStyle: UIAlertControllerStyle.alert)
                
                    let action = UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel)
                    {
                        
                        ACTION in
                        
                    }
                    
                    alert.addAction(action)
                    
                    self.present(alert, animated: true, completion: nil)
                }
                
            }
        })
        task.resume()
    
    }
}
