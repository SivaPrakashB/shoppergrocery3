//
//  CustomerRegistrationViewController.swift
//  FoodDeliveryCustomer
//
//  Created by iqmsoft on 11/9/16.
//  Copyright © 2016 iQmSoft. All rights reserved.
//

import UIKit

struct RequiredURLS {
    let baseUrl = "http://zenith.instest.net/restaurantapi/"
    
    let registrationUrl = "http://zenith.instest.net/restaurantapi/customer/post"
    let loginUrl = "http://zenith.instest.net/restaurantapi/customer/login"
    let customerProfile = "http://zenith.instest.net/restaurantapi/customer/view/"
    let storeItemShow = "http://zenith.instest.net/restaurantapi/item/show/"
    let itemViewUrl = "http://zenith.instest.net/restaurantapi/item/view/"
    let storesUrl = "http://zenith.instest.net/groceryapi/store/get"
    let postOrderUrl = "http://zenith.instest.net/restaurantapi/order/post"
    let ordersList = "http://zenith.instest.net/restaurantapi/order/show/"
    let orderDetailsViewUrl = "http://zenith.instest.net/restaurantapi/order/view/"
    let orderFeedback = "http://zenith.instest.net/restaurantapi/customer/feedback"
    let orderDelete = "http://zeus.instest.net/restaurantapi/order/remove/"
}

class CustomerRegistrationViewController: UIViewController  , UINavigationControllerDelegate {

    
    @IBOutlet weak var fullName: UITextField!
    @IBOutlet weak var emailID: UITextField!
    @IBOutlet weak var contactNum: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var defaults = UserDefaults.standard
    var urls = RequiredURLS()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(CustomerRegistrationViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CustomerRegistrationViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        // Do any additional setup after loading the view.
    }

    func validateEmail(candidate: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: candidate)
    }

    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func navigationControllerSupportedInterfaceOrientations(_ navigationController: UINavigationController) -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        resignFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func registerTapped(_ sender: UIButton) {
        
        //storing textfield input to variables
        let fName : NSString = fullName.text! as NSString
        let email : NSString = emailID.text! as NSString
        let contctNum : NSString = contactNum.text! as NSString
        let passwrd : NSString = password.text! as NSString
        
        let valid = validateEmail(candidate: email as String)
        
        //if condition to throw alert if fields are empty
        if(fName.isEqual(to:""))
        {
            let alert = UIAlertController(title: "Name Required!", message: "Please enter name", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil)
            alert.addAction(okAction)
            self.present(alert ,animated : true , completion : nil)
        }
        else if(email.isEqual(to: "") )
        {
            let alert = UIAlertController(title: "email Required!", message: "Please enter email", preferredStyle:   UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
        else if(valid != true )
        {
            let alert = UIAlertController(title: "Not a valid mail!", message: "Please enter correct email", preferredStyle:   UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }

        else if(contctNum.isEqual(to: ""))
        {
            let alert = UIAlertController(title: "Contact number Required!", message: "Please enter number", preferredStyle:   UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
        else if(passwrd.isEqual(to: ""))
        {
            let alert = UIAlertController(title: "Password Required!", message: "Please enter password", preferredStyle:   UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            
        let post : NSString =  "full_name=\(fName)&email_id=\(email)&phone=\(contctNum)&password=\(passwrd)" as NSString

            NSLog("PostData: %@",post);
            
            let url : NSURL = NSURL(string: urls.registrationUrl)!
            
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
                        let myAlert = UIAlertController(title: msg as String, message: "", preferredStyle: UIAlertControllerStyle.alert)
                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
                        {
                            ACTION in
                           
                            if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone
                            {
                                let storyboard=UIStoryboard(name: "Main", bundle: nil)
                                var viewcontroller = UIViewController()
                                viewcontroller = storyboard.instantiateViewController(withIdentifier: "LoginPage") as! ViewController
                                 self.present(viewcontroller, animated: true, completion: nil)
                            }
                            if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad
                            {
                                let storyboard=UIStoryboard(name: "Second", bundle: nil)
                                var viewcontroller=UIViewController()
                                viewcontroller = storyboard.instantiateViewController(withIdentifier: "IpadLoginPage") as! ViewController
                               self.present(viewcontroller, animated: true, completion: nil)
                            }

                        }
                        myAlert.addAction(okAction)
                        self.present(myAlert, animated: true, completion: nil)
                        
                    }
                    else
                    {
                        let myAlert = UIAlertController(title: msg as String, message: "Try Again", preferredStyle: UIAlertControllerStyle.alert)
                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                        myAlert.addAction(okAction)
                        self.present(myAlert, animated: true, completion: nil)
                        return
                    }
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


