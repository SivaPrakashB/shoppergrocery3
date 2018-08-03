//
//  web1ViewController.swift
//  grocery3
//
//  Created by mac on 10/7/17.
//  Copyright © 2017 mac. All rights reserved.
//

import UIKit

class web1ViewController: UIViewController {
    var url4=String()
    
    
    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        url4=UserDefaults.standard.object(forKey: "urlweb") as! String
        print(url4)
        
        let pdf:String="https://\(url4)"
        let url=NSURL(string: pdf)
        let req=NSURLRequest(url: url as! URL)
        
        /*let settingsUrl = URL(string:"http://\(url4)") as! URL
         
         //let url4 = NSURL (string: url3);
         let requestObj = NSURLRequest(URL: settingsUrl)*/
        webView.loadRequest(req as URLRequest);
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func back(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "tapbarviewcontroller") as! UIViewController
        self.present(vc, animated: true, completion: nil)
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
