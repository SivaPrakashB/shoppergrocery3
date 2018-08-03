//
//  LoginViewController.swift
//  grocery3
//
//  Created by mac on 7/24/17.
//  Copyright © 2017 mac. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController ,UITextFieldDelegate{
let defaults=UserDefaults.standard
    @IBOutlet var email: UITextField!
  
    @IBOutlet var password: UITextField!
    
    
    @IBOutlet var login: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        email.delegate=self
        password.delegate=self
        email.layer.borderWidth = 3
        password.layer.borderWidth = 3
        
        email.layer.borderColor=UIColor.green.cgColor
        password.layer.borderColor=UIColor.green.cgColor
        login.layer.cornerRadius=5
        login.layer.borderColor=UIColor.green.cgColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // called when 'return' key pressed. return NO to ignore.
        textField.resignFirstResponder()
        
        return true
        
        
        
    }
    

    @IBAction func loginbuttontapped(_ sender: UIButton) {
        
        
        
        
        
        
        
        
        let userName = self.email.text! as String
        let pass = self.password.text! as String
        if userName.isEmpty == true {
            
            let alert = UIAlertController(title: "Username required!", message: "please enter username", preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            
        }
        if pass.isEmpty == true {
            let alert = UIAlertController(title: "Password required!", message: "please enter password", preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
        
            
            let mySession = URLSession.shared
            let url: NSURL = NSURL(string: "http://zenith.instest.net/groceryapi/shopper/login")!
            let request = NSMutableURLRequest(url: url as URL)
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.httpMethod = "POST"
            let data = "email_id=\(userName)&password=\(pass)"
            request.httpBody = data.data(using: String.Encoding.ascii)
            let task = mySession.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) in
                if let error = error {
                    print(error)
                }
                if let data = data{
                    print("data =\(data)")
                }
                if let response = response {
                    print("url = \(response.url!)")
                    print("response = \(response)")
                    let httpResponse = response as! HTTPURLResponse
                    print("response code = \(httpResponse.statusCode)")
                    
                    //if you response is json do the following
                    do{
                        let resultJSON = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                        print("json response : \(resultJSON)")
                        let status = resultJSON.object(forKey: "status") as! Int
                        let message = resultJSON.object(forKey: "message") as! String
                        let id=resultJSON.object(forKey: "id")
                        self.defaults.set(id, forKey: "id")
                        OperationQueue.main.addOperation{
                            if status == 1 {
                                let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.alert)
                                let action = UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel) {
                                    ACTION in
                                   
                                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                    let vc = storyboard.instantiateViewController(withIdentifier: "tapbarviewcontroller") as! UIViewController
                                    self.present(vc, animated: true, completion: nil)
                                    
                                }
                                alert.addAction(action)
                                self.present(alert, animated: true, completion: nil)
                            }
                            else{
                                let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.alert)
                                let action = UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil)
                                alert.addAction(action)
                                self.present(alert, animated: true, completion: nil)
                            }
                        }
                    }
                    catch _{
                        print("Received not-well-formatted JSON")
                    }
                }
            })
            task.resume()
        

    }

}
