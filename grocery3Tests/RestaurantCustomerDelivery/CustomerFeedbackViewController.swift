
//
//  CustomerFeedbackViewController.swift
//  RestaurantCustomerDelivery
//
//  Created by iqmsoft on 11/24/16.
//  Copyright © 2016 iQmSoft. All rights reserved.
//

import UIKit

class CustomerFeedbackViewController: UIViewController {

    @IBOutlet weak var comments: UITextView!
    @IBOutlet weak var customerRating: CosmosView!
    var defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
      customerRating.rating = 0
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func SubmitTapped(_ sender: Any) {
        
        let ids = defaults.object(forKey: "OrderId")
        let orderid = ids! as! String
        
        let ids1 = defaults.object(forKey: "CustomerId")
        let custmid = ids1! as! String
        
        let ids2 = defaults.object(forKey: "PassStrD")
        let strid = ids2! as! String
        
        let comments = self.comments.text!
        let userRating = customerRating.rating
        
        if comments.isEmpty == true && userRating.isZero == true {
            
            let myAlert = UIAlertController(title: "Sorry!", message: "Fields look empty please give your rating to serve best food", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
            {
                ACTION in
            }
            myAlert.addAction(okAction)
            self.present(myAlert, animated: true, completion: nil)

        } else {
            
        let post : NSString =  "customer_id=\(custmid)&store_id=\(strid)&order_id=\(orderid)&rating=\(userRating)&comments=\(comments)" as NSString
        
        NSLog("PostData: %@",post);
        
        let url : NSURL = NSURL(string: RequiredURLS().orderFeedback)!
        
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
                let jsonData:NSDictionary = (try! JSONSerialization.jsonObject(with: urlData! as Data, options:JSONSerialization.ReadingOptions.allowFragments )) as! NSDictionary
                let status : NSInteger = jsonData.value(forKey: "status") as! NSInteger
                let msg : NSString = jsonData.value(forKey: "message") as! NSString
                NSLog("Status: %ld", status);
                if status == 1
                {

                  let myAlert = UIAlertController(title: msg as String, message: "Thankyou!", preferredStyle: UIAlertControllerStyle.alert)
                  let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
                    {
                       ACTION in
                         self.dismiss(animated: true, completion: nil)
                     }
                  myAlert.addAction(okAction)
                  self.present(myAlert, animated: true, completion: nil)
                }else {
                    let myAlert = UIAlertController(title: msg as String, message: "Try Again", preferredStyle: UIAlertControllerStyle.alert)
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                    myAlert.addAction(okAction)
                    self.present(myAlert, animated: true, completion: nil)
                    return
                }
            }
            else {
                let alertView:UIAlertView = UIAlertView()
                alertView.title           = "Failed!"
                alertView.message         = "Connection Failed"
                alertView.delegate        = self
                alertView.addButton(withTitle: "OK")
                alertView.show()
            }
        }
        else
        {
            let alertView:UIAlertView = UIAlertView()
            alertView.title = "Failed!"
            alertView.message = "Connection Failure"
            if let error = responseError
            {
                alertView.message = (error.localizedDescription)
            }
            alertView.delegate = self
            alertView.addButton(withTitle: "OK")
            alertView.show()
        }
        
        
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
