//
//  ViewController.swift
//  FoodDeliveryCustomer
//
//  Created by iqmsoft on 11/7/16.
//  Copyright © 2016 iQmSoft. All rights reserved.
//

import UIKit

class ViewController: UIViewController , UITextFieldDelegate{
    
    //outlets
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    //user defaults
    var defaults = UserDefaults.standard
    var urls = RequiredURLS()
    
    let MyKeychainWrapper = KeychainWrapper()
    let createLoginButtonTag = 0
    let loginButtonTag = 1
    
    @IBOutlet weak var loginButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.userNameField.text = "kiran@gmail.com"
//        self.passwordField.text = "kiran123"
       
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        resignFirstResponder()
    }
    
    func mailIdValidation() {
        
        if userNameField.text! != defaults.object(forKey: "EmailID") as! String {
            defaults.removeObject(forKey: "Address1")
            defaults.removeObject(forKey: "Address2")
            defaults.removeObject(forKey: "City")
            defaults.removeObject(forKey: "Zipcode")
            defaults.removeObject(forKey: "ContactNumber")
            defaults.removeObject(forKey: "ContactName")
            defaults.removeObject(forKey: "deliverynotes")
        }
    }

   
    @IBAction func cancelTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //login action
    @IBAction func loginTapped(_ sender: UIButton) {
        
        //storing textfield input to variables
        let username : NSString = userNameField.text! as NSString
        defaults.setValue(username, forKey: "UserName")
        
        let password : NSString = passwordField.text! as NSString
        defaults.setValue(password, forKey: "Password")
        
        userNameField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
        //if condition to throw alert if fields are empty
        if(username.isEqual(to:""))
        {
            let alert = UIAlertController(title: "Username Required!", message: "Please enter Username", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil)
            alert.addAction(okAction)
            self.present(alert ,animated : true , completion : nil)
        }
        else if(password.isEqual(to: ""))
        {
            let alert = UIAlertController(title: "Password Required!", message: "Please enter password", preferredStyle:   UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            
            let post : NSString =  "email=\(username)&password=\(password)" as NSString
            
            NSLog("PostData: %@",post);
            
            let url : NSURL = NSURL(string: urls.loginUrl)!
            
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
                        let id : NSString = jsonData.value(forKey: "id") as! NSString
                        print("userId", id)
                        self.defaults.set(id, forKey: "CustomerId")
                        let email : NSString = jsonData.value(forKey: "email") as! NSString
                        defaults.set(email, forKey: "EmailID")
                        
                        print("email",email)
                        let myAlert = UIAlertController(title: msg as String, message: "", preferredStyle: UIAlertControllerStyle.alert)
                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
                        {
                            
                            ACTION in
                             self.mailIdValidation()
                            self.dismiss(animated: true, completion: nil)
//                            if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone
//                            {
//                              self.performSegue(withIdentifier: "Login", sender: sender)
//                            }
//                            if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad
//                            {
//                                let storyboard=UIStoryboard(name: "Main", bundle: nil)
//                                var viewcontroller = UITabBarController()
//                                viewcontroller = storyboard.instantiateViewController(withIdentifier: "tabBarController") as! CustomViewController
//                                self.present(viewcontroller, animated: true, completion: nil)
//                            }

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
    
    
}

