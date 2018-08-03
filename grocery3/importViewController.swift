//
//  importViewController.swift
//  grocery3
//
//  Created by iqmsoft on 9/2/17.
//  Copyright © 2017 mac. All rights reserved.
//

import UIKit
import MobileCoreServices

class importViewController: UIViewController ,UIDocumentMenuDelegate,UIDocumentPickerDelegate{
let users=UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func `import`(_ sender: UIButton) {let importMenu = UIDocumentMenuViewController(documentTypes: ["com.microsoft.excel.xls","public.data","public.text","com.adobe.pdf","public.composite-content"], in: .import)
        importMenu.delegate = self
        importMenu.addOption(withTitle: "Create New Document", image: nil, order: .first, handler: { print("New Doc Requested") })
        present(importMenu, animated: true, completion: nil)
        
        
        
        
        
        
        
        
        
        
    }
    func documentMenu(_ documentMenu: UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt path: URL) {
        // Do something
        print(path)
        let pathaddress="\(path)"
        users.set(path, forKey: "path1")
      /*  var documentsPath = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.path)! as String
        
        print(documentsPath)
        let pathToRead = "\(documentsPath)/newexcel.xlsx"
        print(pathToRead)*/
        
       let url : NSURL = NSURL(string: "http://zenith.instest.net/groceryapi/customer/import/54")!
        let request    : NSMutableURLRequest = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        let param = [
            "importxls"    : "sampleorderbv.xlsx"
        ]
        let bound = generateBoundaryString()
        request.setValue("multipart/form-data; boundary=\(bound)", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        //let pdfPathWithFileName:String=pathaddress
        //let fileData  = NSData(contentsOfFile: pathaddress)!
        var fileDta1=NSData(contentsOf:path)!
        //        if (checkValidation.fileExistsAtPath(fileData as! String)) {
        
        //          return
        //        }
        print(fileDta1)
        request.httpBody = (createBodyWithParameters(parameters: param, filePathKey: "importxls", fileDataKey: fileDta1, boundary: bound) as NSData) as Data
        
        
        
        let task = URLSession.shared.dataTask(with: request as URLRequest)
        {
            data,response,error in
            if error != nil {
                print("error =\(error)")
                return
            }
            // You can print out response object
            print("******* response = \(response)")
            // Print out reponse body
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("****** response data = \(responseString!)")
            
            var err: NSError?
            
            do {
                if let  json = try? JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! NSDictionary {
                    print(json)
                }
                
            }
            catch let error as NSError

            {                print(error.localizedDescription)
            }
            DispatchQueue.main.async(execute:
                {
                    //                    self.myActivityIndicator.stopAnimating()
                    //                    self.myImageView.image = nil;
            })
        }
        task.resume()
        
        
        
        
        let alertController = UIAlertController(title: " uploaded!", message: "Successfully", preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { ACTION in
            // self.performSegue(withIdentifier: "pdf", sender: self)
        
        }
        alertController.addAction(OKAction)
        
        
        self.present(alertController, animated: true, completion:nil)
        
        

        
    }
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    
    func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, fileDataKey: NSData, boundary: String) -> NSData {
        let body = NSMutableData()
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString(string: "--\(boundary)\r\n")
                body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString(string: "\(value)\r\n")
            }
        }
/*let filePdf = "newexcel.xlsx"
        let path:NSArray = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        let localDocumentsURL = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: .userDomainMask).last! as NSURL
        let myLocalFile = localDocumentsURL.appendingPathComponent(filePdf as String)
        
        let NSHomeDirectory = path.object(at: 0)  as! NSString
        //let pdfPathWithFileName = NSHomeDirectory.appendingPathComponent("filePdf")! as NSURL
        let pdfPathWithFileName=NSHomeDirectory.appendingPathComponent("newexcel.xlsx")
        */
        
        let pathaddress1=users.object(forKey: "path1")
        let mimetype = mimeTypeForPath(path: "importxls")
        
        body.appendString(string: "--\(boundary)\r\n")
        body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(pathaddress1!)\"\r\n")
        body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
        body.append(fileDataKey as Data)
        body.appendString(string: "\r\n")
        
        
        body.appendString(string: "--\(boundary)--\r\n")
        
        return body
    }
    func mimeTypeForPath(path: String) -> String {
        let url = NSURL(fileURLWithPath: path)
        let pathExtension = url.pathExtension
        
        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension! as NSString, nil)?.takeRetainedValue() {
            if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
                return mimetype as String
            }
        }
        return "application/octet-stream";
    }
    
}
extension NSMutableData {
    
    /// Append string to NSMutableData
    ///
    /// Rather than littering my code with calls to `dataUsingEncoding` to convert strings to NSData, and then add that data to the NSMutableData, this wraps it in a nice convenient little extension to NSMutableData. This converts using UTF-8.
    ///
    /// - parameter string:       The string to be added to the `NSMutableData`.
    
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}

