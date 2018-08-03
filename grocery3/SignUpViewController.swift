//
//  SignUpViewController.swift
//  grocery3
//
//  Created by mac on 7/24/17.
//  Copyright © 2017 mac. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController ,UITextFieldDelegate{

    
    @IBOutlet var Fname: UITextField!
    
    
    @IBOutlet var signup: UIButton!
   
    @IBOutlet var Sname: UITextField!
    
    @IBOutlet var Email: UITextField!
    
    @IBOutlet var Password: UITextField!
    
    @IBOutlet var login: UIButton!
    @IBOutlet var Phnumber: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Fname.delegate=self
        Sname.delegate=self
        Email.delegate=self
        Password.delegate=self
       Phnumber.delegate=self
        
        Fname.layer.borderWidth = 2
        Sname.layer.borderWidth = 2
        
       Fname.layer.borderColor=UIColor.green.cgColor
       Sname.layer.borderColor=UIColor.green.cgColor
        
        Email.layer.borderWidth = 2
       Password.layer.borderWidth = 2
        
        Email.layer.borderColor=UIColor.green.cgColor
        Password.layer.borderColor=UIColor.green.cgColor
        Phnumber.layer.borderWidth = 2

           Phnumber.layer.borderColor=UIColor.green.cgColor
        signup.layer.cornerRadius=5
        login.layer.cornerRadius=5
                // Do any additional setup after loading the view.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
       
    @IBAction func SignUpAction(_ sender: UIButton) {
    
            //reading field values//
            
            let first_name = self.Fname.text! as String
            let last_name = self.Sname.text! as String
            let email_id = self.Email.text! as String
            let password = self.Password.text! as String
            let phone = self.Phnumber.text! as String
         let valid = validateEmail(candidate: email_id as String)
        
       if first_name.isEmpty==true || last_name.isEmpty==true || email_id.isEmpty==true || password.isEmpty==true || phone.isEmpty==true
       {
        alertMessage(titleMessage: "Alert Message", message: "Please check all fields are manditory")
       }
        if valid != true{
            alertMessage(titleMessage: "entered mail is not a valid", message: "Please enter valid email id")
        }
      
       if password.characters.count < 6
            {
                alertMessage(titleMessage: "Password required!", message: "Password must contain atleast 6 charecters")
            }
       if phone.characters.count != 10
        {
            alertMessage(titleMessage: "Phone number required!", message: "Phone number must contain  10 digits")
            }
       
        
        
            let mySession = URLSession.shared
            
            //api url link//
            let url: NSURL! = NSURL(string: "http://zenith.instest.net/groceryapi/shopper/post/")!
            
            //making api request//
            
            let request = NSMutableURLRequest(url: url as URL)
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            
            //api method declation//
            //http://ec2-13-232-142-250.ap-south-1.compute.amazonaws.com:9000/users/access_token=8jSHB0bR9Dtcles0qU5vnJtchziwspeV&email=abc@gmail.com&password=123456&name=rock&picture=&role=user
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.httpMethod = "POST"
            
            
            //api fields//
            
            let data = "first_name=\(first_name)&last_name=\(last_name)&email_id=\(email_id)&password=\(password)&phone=\(phone)"
            request.httpBody = data.data(using: String.Encoding.ascii)
            let task = mySession.dataTask(with: request as URLRequest, completionHandler: {
                (data, response, error) in
                if let error = error {
                    print(error)
                }
                
                if let data = data{
                    
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
                        let alert = UIAlertController(title: "registered successfully", message: "you can login now", preferredStyle: UIAlertControllerStyle.alert)
                        let action = UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel){
                            
                            ACTION in
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
                            self.present(vc, animated: true, completion: nil)
                            
                        }
                        alert.addAction(action)
                        self.present(alert, animated: true, completion: nil)
                    }
                    
                    
                    
                    
                    
                    
                }
            })
            task.resume()
            
        }
    
    
    //Alert message
    func alertMessage(titleMessage : String , message : String) {
        
        let alert = UIAlertController(title: titleMessage, message: message , preferredStyle:   UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    func validateEmail(candidate: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: candidate)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // called when 'return' key pressed. return NO to ignore.
        textField.resignFirstResponder()
        
        return true
        
        
        
    }


}
