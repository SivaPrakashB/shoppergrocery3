//
//  profileUpdate.swift
//  grocery3
//
//  Created by mac on 8/31/17.
//  Copyright © 2017 mac. All rights reserved.
//

import UIKit
import MobileCoreServices
class profileUpdate: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    var picker1:UIImagePickerController? = UIImagePickerController()
    var popover1: UIPopoverController? = nil
    let id=UserDefaults.standard.object(forKey: "id")
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var fname: UITextField!
    @IBOutlet weak var lname: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var state: UITextField!
    @IBOutlet weak var zipcode: UITextField!
    @IBOutlet weak var country: UITextField!
    @IBOutlet weak var choosepic: UIButton!
    @IBOutlet weak var update: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        choosepic.layer.borderWidth=2
        choosepic.layer.cornerRadius=10
        update.layer.borderWidth=2
        update.layer.cornerRadius=10
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(profileUpdate.dismissKeyboard))
        view.addGestureRecognizer(tapGestureRecognizer)

gettingProfileDetails()
        // Do any additional setup after loading the view.
    }
    func dismissKeyboard() {
        if fname != nil || lname != nil || email != nil || password != nil || phone != nil || city != nil || state != nil || zipcode != nil  {
            fname.resignFirstResponder()
            lname.resignFirstResponder()
            email.resignFirstResponder()
            password.resignFirstResponder()
            phone.resignFirstResponder()
            city.resignFirstResponder()
            state.resignFirstResponder()
            zipcode.resignFirstResponder()
            address.resignFirstResponder()
        }
    }
    @IBOutlet weak var address: UITextField!

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func choosepicbutton(_ sender: UIButton) {
        
        
        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
            self.openCamera()
            
        }
        let gallaryAction = UIAlertAction(title: "Gallary", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
            self.openGallary()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel)
        {
            UIAlertAction in
            
        }
        
        // Add the actions
        picker1?.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        // Present the controller
        picker1?.modalPresentationStyle = .popover
        //picker1?.popoverPresentationController?.butt=sender
        if UIDevice.current.userInterfaceIdiom == .phone
        {
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            popover1 = UIPopoverController(contentViewController: alert)
           popover1?.present(from: image.frame, in: self.view, permittedArrowDirections: UIPopoverArrowDirection.any, animated: true)
        }
        
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        print(info)
        image.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        self.dismiss(animated: true, completion: nil)
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    
    
    @IBOutlet weak var updatebutton: UIButton!
    func gettingProfileDetails()
    {
        let id=UserDefaults.standard.object(forKey: "id")
        print("******bvsp\(id!)")
       let url=URL(string:"http://zenith.instest.net/groceryapi/shopper/get/\(id!)")
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
                                        if let dictionary = resultJSON as? [String:Any]
                    {
                        let name = dictionary["shopper"] as! NSDictionary
                        print("bvsp:\(name)")
                        
                        
                        
                        for (key,value) in name {
                            
                            if ("\(key)".isEqual("state"))
                            {
                                var value1:String="\(value)"
                                if value1 == "<null>"
                                {
                                    self.state.text=""
                                }
                                else
                                {
                                    self.state.text="\(value)"
                                }
                            }
                            else  if ("\(key)".isEqual("email_id"))
                            {
                                let value1:String="\(value)"
                                if value1 == "<null>"
                                {
                                    self.email.text=""
                                }
                                else
                                {
                                    self.email.text="\(value)"
                                }
                                
                            }
                            else if ("\(key)".isEqual("phone"))
                            {
                                let value1:String="\(value)"
                                if value1 == "<null>"
                                {
                                    self.phone.text=""
                                }
                                else
                                {
                                    self.phone.text="\(value)"
                                }
                                
                                
                            }
                            else  if ("\(key)".isEqual("zipcode"))
                            {let value1:String="\(value)"
                                if value1 == "<null>"
                                {
                                    self.zipcode.text=""
                                }
                                else
                                {
                                    self.zipcode.text="\(value)"
                                }
                                
                            }
                            else  if ("\(key)".isEqual("address"))
                            {let value1:String="\(value)"
                                if value1 == "<null>"
                                {
                                    self.address.text=""
                                }
                                else
                                {
                                    self.address.text="\(value)"
                                }
                                
                                
                            }
                            else  if ("\(key)".isEqual("first_name"))
                            {
                                let value1:String="\(value)"
                                if value1 == "<null>"
                                {
                                    self.fname.text=""
                                }
                                else
                                {
                                    self.fname.text="\(value)"
                                }
                                
                                
                            }
                            else if ("\(key)".isEqual("password"))
                            {let value1:String="\(value)"
                                if value1 == "<null>"
                                {
                                    self.password.text=""
                                }
                                else
                                {
                                    self.password.text="\(value)"
                                }
                                
                                
                            }
                            else if ("\(key)".isEqual("last_name"))
                            {let value1:String="\(value)"
                                if value1 == "<null>"
                                {
                                    self.lname.text=""
                                }
                                else
                                {
                                    self.lname.text="\(value)"
                                }
                                
                            }
                            else if ("\(key)".isEqual("city"))
                            {let value1:String="\(value)"
                                if value1 == "<null>"
                                {
                                    self.city.text=""
                                }
                                else
                                {
                                    self.city.text="\(value)"
                                }
                            }
                            else if ("\(key)".isEqual("country"))
                            {let value1:String="\(value)"
                                if value1 == "<null>"
                                {
                                    self.country.text=""
                                }
                                else
                                {
                                    self.country.text="\(value)"
                                }
                            }
                                
                            else if ("\(key)".isEqual("photo"))
                            {
                                
                                
                                
                                
                                
                                DispatchQueue.global().async {
                                    let url = URL(string: "http://zenith.instest.net/groceryapi/public/img/"+"\(value)")
                                    if url != nil{
                                        let imageData = try? Data(contentsOf: url!)
                                        
                                        DispatchQueue.main.async {
                                            
                                            self.image.image = UIImage(data: imageData!)
                                        }
                                        
                                    }
                                }
                            }
                            
                        }
                    }
                }
                    
                catch
                {
                    print("json not performed well")
                }
               
                
            }
            
            }.resume()
    }
    


    @IBAction func updatebutton(_ sender: UIButton) {
        //reading field values//
        
        
        let first_name = self.fname.text! as String
        let last_name = self.lname.text! as String
        let email_id = self.email.text! as String
        let password = self.password.text! as String
        let phone = self.phone.text! as String
        let address = self.address.text! as String
        let city = self.city.text! as String
        let state = self.state.text! as String
        let zipcode = self.zipcode.text! as String
        let country = self.country.text! as String
        
        var img : Data!
        if let image2 =  UIImageJPEGRepresentation(self.image.image!, 0.1)
        {
            img = image2
            print(img)
        }
        let bound = generateBoundaryString()
        
        
        let mySession = URLSession.shared
        
        //api url link//
        let url: NSURL! = NSURL(string: "http://zenith.instest.net/groceryapi/shopper/put1/\(id!)")!
        
        //making api request//
        
        let request = NSMutableURLRequest(url: url as URL)
        
        request.setValue("multipart/form-data; boundary=\(bound)", forHTTPHeaderField: "Content-Type")
        //api method declation// */
        
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        let param = [
            "first_name"    : "\(first_name)",
            "last_name"    : "\(last_name)",
            "email_id"  : "\(email_id)",
            "password"  :  "\(password)",
            "phone" : "\(phone)",
            "address"  : "\(address)" ,
            "city"  : "\(city)",
            "state" : "\(state)",
            "zipcode"  : "\(zipcode)" ,
            "photo"  : "\(img)",
            "country" : "\(country)"
            
        ]
        print(param)
        //api fields//
        request.httpBody = createBodyWithParameters(parameters: param, filePathKey: "image/jpeg", imageDataKey: img as NSData , boundary: bound) as Data
        //let data = "first_name=\(first_name)&last_name=\(last_name)&email_id=\(email_id)&password=\(password)&phone=\(phone)&address=\(address)&city=\(city)&state=\(state)&zipcode=\(zipcode)"
        //request.httpBody = data.data(using: String.Encoding.ascii)
        let task = mySession.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) in
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
                    let alert = UIAlertController(title: "updated successfully", message: "", preferredStyle: UIAlertControllerStyle.alert)
                    let action = UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel){
                        
                        ACTION in
                    }
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                }
                
                
                
                
                
                
            }
        })
        task.resume()
        
    }

    func mimeTypeForPath(path: String) -> String {  // import MobileCoreServices
        let pathUrl = NSURL(string: path)
        let pathExtension = pathUrl!.pathExtension
        var stringMimeType = "application/octet-stream"
        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension as! CFString, nil)?.takeRetainedValue() {
            if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
                stringMimeType = mimetype as NSString as String
            }
        }
        return stringMimeType;
    }
    
    
    
    
    
    func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageDataKey: NSData, boundary: String) -> NSData {
        let body = NSMutableData();
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString(string: "--\(boundary)\r\n")
                body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString(string: "\(value)\r\n")
            }
        }
        
        
        let pciName = "\(id!)"
        let picNameExtent = pciName + ".jpeg"
        print("picname is : \(picNameExtent)")
        let trimmedString = picNameExtent.trimmingCharacters(in: .whitespaces)
        
        print("-*-*\(picNameExtent)-*-*")
        
        //        let filename = "http://zenith.instest.net/sproviderv1/serviceproviderapi/public/img/\(trimmedString)"
        let mimetype = "image/jpeg"
        
        body.appendString(string: "--\(boundary)\r\n")
        body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(trimmedString)\"\r\n")
        body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
        body.append(imageDataKey as Data)
        body.appendString(string: "\r\n")
        
        body.appendString(string: "--\(boundary)--\r\n")
        
        return body
    }
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
        
}
    
    
    
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
        {
            picker1!.sourceType = UIImagePickerControllerSourceType.camera
            self .present(picker1!, animated: true, completion: nil)
        }
        else
        {
            openGallary()
        }
    }
    func openGallary()
    {
        picker1!.sourceType = UIImagePickerControllerSourceType.photoLibrary
        if UIDevice.current.userInterfaceIdiom == .phone
        {
            self.present(picker1!, animated: true, completion: nil)
        }
        else
        {
            popover1 = UIPopoverController(contentViewController: picker1!)
           popover1?.present(from: image.frame, in: self.view, permittedArrowDirections: UIPopoverArrowDirection.any, animated: true)
        }
    }
    
    


}


