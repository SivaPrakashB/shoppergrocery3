//
//  ProfileViewController.swift
//  FoodDeliveryCustomer
//
//  Created by iqmsoft on 11/10/16.
//  Copyright © 2016 iQmSoft. All rights reserved.
//

import UIKit
//import SwiftyJSON

class ProfileViewController: UIViewController ,UITableViewDataSource , UITableViewDelegate {
//UITableview->name:allen,age:18 that design coming//
//
    
    @IBOutlet weak var placeHolderImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var logOutlet: UIButton!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var emailId: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var defaults = UserDefaults.standard
    var cusName: String = ""
    var emailID : String = ""
    var phone : String = ""
    var custId : String = ""
    
    var profileOptions = ["Address", "Payments" , "Offers" , "Refer and Earn", "Help"]
    var optionsIcon = [UIImage(named: "Homes")!,UIImage(named: "Card")!,UIImage(named: "PriceTag")!,UIImage(named: "Share")!,UIImage(named: "Help")!]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        getCustomerProfile()
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.black]
    }

    override func viewWillAppear(_ animated: Bool) {
        getData()
        getCustomerProfile()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func getCustomerProfile() {
        
    if defaults.object(forKey: "CustomerId") != nil {
        tableView.isHidden = false
        profileView.isHidden = false
        self.placeHolderImage.isHidden = true
        self.logOutlet.setTitle("Logout", for: UIControlState.normal)
        let ids = defaults.object(forKey: "CustomerId")
        let id = ids!
        let api = RequiredURLS().customerProfile + "\(id)"
        let urlString =  NSURL(string: api)
        let request:NSMutableURLRequest = NSMutableURLRequest(url: urlString as! URL)
        request.httpMethod = "GET"

        var reponseError: NSError?
        var response: URLResponse?
        
        var urlData: NSData?
        do {
            urlData = try NSURLConnection.sendSynchronousRequest(request as URLRequest, returning:&response) as NSData?
        } catch let error as NSError {
            reponseError = error
            urlData = nil
        }
        
        if ( urlData != nil ) {
            let res = response as! HTTPURLResponse!;
            
            print("Response code: %ld", res?.statusCode);
            
            if ((res?.statusCode)! >= 200 && (res?.statusCode)! < 300)
            {
                let responseData:NSString  = NSString(data:urlData! as Data, encoding:String.Encoding.utf8.rawValue)!
                
                NSLog("Response ==> %@", responseData);
                var error: NSError?
                
                let jsonData:NSDictionary = (try! JSONSerialization.jsonObject(with: urlData! as Data, options:JSONSerialization.ReadingOptions.mutableContainers )) as! NSDictionary
                
                let fullname:NSString = jsonData.value(forKey: "full_name") as! NSString
                let email:NSString = jsonData.value(forKey: "email_id") as! NSString
                let phone : NSString = jsonData.value(forKey: "phone") as! NSString
                 let password : NSString = jsonData.value(forKey: "password") as! NSString
                let date:NSString = jsonData.value(forKey: "date_created") as! NSString
                 let id : NSString = jsonData.value(forKey: "id") as! NSString
                print(responseData)
                
                self.nameLabel.text = fullname as String
                self.emailId.text = email as String
                self.phoneNumber.text = phone as String
                self.custId = id as String
         
            }
            
          }
    } else {
            print("Customer have not logged in")
            self.placeHolderImage.isHidden = false
            tableView.isHidden = true
            profileView.isHidden = true
            self.logOutlet.setTitle("Login", for: UIControlState.normal)
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return profileOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ProfileTableViewCell
        cell.options.text = profileOptions[indexPath.row]
        cell.icons.image = optionsIcon[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.performSegue(withIdentifier: "Address", sender: self)
        }
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
    
    @IBAction func logoutTapped(_ sender: UIButton) {
        
        if logOutlet.currentTitle == "Login" {
             presentingViews()
        }
        else if logOutlet.currentTitle == "Logout" {
            print("Customer have not logged in")
            self.placeHolderImage.isHidden = false
            tableView.isHidden = true
            profileView.isHidden = true
            self.logOutlet.setTitle("Login", for: UIControlState.normal)
            defaults.removeObject(forKey: "EmailID")
            defaults.removeObject(forKey: "CustomerId")
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
