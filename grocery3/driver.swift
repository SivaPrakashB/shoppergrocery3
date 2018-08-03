//
//  driver.swift
//  grocery3
//
//  Created by mac on 9/7/17.
//  Copyright © 2017 mac. All rights reserved.
//

import UIKit

class driver: UIViewController,UITableViewDelegate,UITableViewDataSource {

   
    @IBOutlet weak var tableview: UITableView!
    var ordersList = [NSDictionary]()
    override func viewDidLoad() {
        super.viewDidLoad()
gettingOrdersList()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ordersList.count
    }
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
   {
    let cell=tableView.dequeueReusableCell(withIdentifier: "CELL") as! drivercell
    let simpleEntry : NSDictionary = self.ordersList[indexPath.row]
    cell.id.text="\(simpleEntry["id"]!)"
    cell.fname.text="\(simpleEntry["first_name"]!)"
    cell.lname.text="\(simpleEntry["last_name"]!)"
    return cell }
    func gettingOrdersList() {
        let id=UserDefaults.standard.object(forKey: "id")
        //       let urlString = RequiredURLS().storesUrl
        //   print("urlString : \(urlString)")
       let url = URL(string: "http://192.168.1.3/groceryapi/shopper/getdriver/")
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
                        for (key,value) in dicValue{
                            if "first_name"=="\(key)"
                            {
                                UserDefaults.standard.set(value, forKey:"firstname1")
                                
                            }
                            if "last_name"=="\(key)"
                            {
                                UserDefaults.standard.set(value, forKey:"lastname1")
                                
                            }
                            
                            // print("bvspvalue:  \(dicValue)")
                            
                            //self.driverNames.append(dicValue)
                            
                            //print(self.ordersList)
                        }
                                                //self.driverNames.append(name)

                    }
                    var fname=UserDefaults.standard.object(forKey: "firstname1")
                    var lname=UserDefaults.standard.object(forKey: "lastname1")
                    var name="\(fname!)"+"\(lname!)"
                    print("name:\(name)")
                    
                }
                catch {
                    print("Received not-well-formatted JSON")
                }
                DispatchQueue.main.async(execute: {
                    self.tableview!.reloadData()
                })
                
            }
            
            }.resume()
    }
    
    


}
