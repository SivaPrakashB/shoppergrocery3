//
//  OrdersListViewController.swift
//  RestaurantCustomerDelivery
//
//  Created by iqmsoft on 11/14/16.
//  Copyright © 2016 iQmSoft. All rights reserved.
//

import UIKit

class OrdersListViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loginOutlet: UIButton!
    @IBOutlet weak var backImageView: UIImageView!

    var oderID = [String]()
    var storeNames = [String]()
    var quantitys = [String]()
    var prices = [String]()
    var selectedOrderId = ""
    var defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getOrdersListJSON()
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        getData()
        NotificationCenter.default.addObserver(self, selector: #selector(OrdersListViewController.orderList(notification:)),name:NSNotification.Name(rawValue: "OrderList"), object: nil)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
         getOrdersListJSON()
    }
    
    func orderList(notification: NSNotification){
        //load data here
        
        self.oderID.removeAll()
        self.storeNames.removeAll()
        self.quantitys.removeAll()
        self.prices.removeAll()
        
        getOrdersListJSON()
        self.tableView!.reloadData()
        
        
    }
    
    func getOrdersListJSON(){
    
        if defaults.object(forKey: "CustomerId") != nil {
             self.tableView.isHidden = false
           let ids = defaults.object(forKey: "CustomerId")
           let cusID = ids!
        
           let exten = "\(cusID)/customer"
           let urlString =   RequiredURLS().ordersList + exten
           let urlEncodedString = urlString.addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed)
        
           let url = NSURL( string: urlEncodedString!)
           let task = URLSession.shared.dataTask(with: url! as URL) {(data, response, innerError) in
            let json = JSON(data: data!)
            let reports = json.arrayValue
            for report in reports
            {
                let id = report["id"].stringValue
                let sName = report["store"].stringValue
                let quant = report["quantity"].stringValue
                let prce = report["price"].stringValue
                print( "id: \(id) storename: \(sName) price: \(prce) Quantity :\(quant)")
                self.storeNames.append(sName)
                self.oderID.append(id)
                self.quantitys.append(quant)
                self.prices.append(prce)
            }
            DispatchQueue.main.async(execute: {
                self.tableView!.reloadData()
            })
            
        }
        task.resume()
        } else {
            self.tableView.isHidden = true
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        var numOfSections: Int = 0
        if oderID.count > 0
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
            
            noDataLabel.text             = "You haven't placed any orders yet."
            noDataLabel.textColor        = UIColor.lightGray
            noDataLabel.adjustsFontSizeToFitWidth = true
            noDataLabel.font = noDataLabel.font.withSize(32)
            noDataLabel.numberOfLines = 2
            noDataLabel.textAlignment    = .center
            tableView.backgroundView = noDataLabel
            tableView.separatorStyle = .none
        }
        return numOfSections
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storeNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Orders", for: indexPath) as! OrdersListTableViewCell
        cell.storeName.text = storeNames[indexPath.row]
        cell.price.text = "$\(prices[indexPath.row])"
        cell.quantitys.text = quantitys[indexPath.row]
        cell.orderID.text = oderID[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedOrderId = oderID[indexPath.row]
        defaults.setValue(selectedOrderId, forKey: "OrderId")
        print("order id : \(selectedOrderId)")
        let alertController = UIAlertController(title: "Select", message: "", preferredStyle: .alert)
        
        let viewDetails = UIAlertAction(title: "Veiw Order", style: .default) { (action:UIAlertAction) in
            print("You've pressed View button")
            self.performSegue(withIdentifier: "OrderDetails", sender: self)
        }
        
        let deleteAciton = UIAlertAction(title: "Delete", style: .default) { (action:UIAlertAction) in
            print("You've pressed update button");
            
          let alertController = UIAlertController(title: "Are you sure!", message: "category will be deleted", preferredStyle: .alert)
            
            let delete = UIAlertAction(title: "Delete", style: .default) { (action:UIAlertAction) in
                print("You've pressed delete button");
                
                let mySession = URLSession.shared
                let url: NSURL = NSURL(string:  RequiredURLS().orderDelete + "\(self.selectedOrderId)")!
                let request = NSMutableURLRequest(url: url as URL)
                request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                request.httpMethod = "POST"
                let task = mySession.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) in
                    if let error = error {
                        print(error)
                    }
                    if let response = response {
                        print("url = \(response.url!)")
                        print("response = \(response)")
                        let httpResponse = response as! HTTPURLResponse
                        print("response code = \(httpResponse.statusCode)")
                        
                        self.storeNames.remove(at: indexPath.row)
                        self.oderID.remove(at: indexPath.row)
                        self.quantitys.remove(at: indexPath.row)
                        self.prices.remove(at: indexPath.row)
                        self.tableView.deleteRows(at: [indexPath], with: .fade)
                        self.tableView.reloadData()
                        
                        let myAlert = UIAlertController(title: "Successfully Deleted", message: "", preferredStyle: UIAlertControllerStyle.alert)
                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
                        {
                            ACTION in
                        }
                        myAlert.addAction(okAction)
                        self.present(myAlert, animated: true, completion: nil)
                        
                        //if you response is json do the following
                    }
                })
                task.resume()
            }
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction) in
                print("You've pressed cancel button");
            }
            alertController.addAction(delete)
            alertController.addAction(cancel)
            self.present(alertController, animated: true, completion:nil)
            self.tableView.reloadData()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction) in
            print("You've pressed cancel button");
            
        }
        
        alertController.addAction(viewDetails)
        alertController.addAction(deleteAciton)
        alertController.addAction(cancel)
        self.present(alertController, animated: true, completion:nil)

    }
  
    func presentingViews() {
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
    @IBAction func loginTapped(_ sender: UIButton) {
        presentingViews()
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
