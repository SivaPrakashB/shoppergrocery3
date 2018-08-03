//
//  ViewController.swift
//  grocery3
//
//  Created by mac on 7/21/17.
//  Copyright © 2017 mac. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var signup: UIButton!
    @IBOutlet var login: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    signup.layer.cornerRadius=5

        
        
    signup.layer.borderColor=UIColor.green.cgColor
        
    signup.layer.borderWidth = 3
    login.layer.cornerRadius=5
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        print(getDataForDate(date: "5/3/2017"))
        
    }
    
    
    
    func getSwiftArrayFromPlist(name:String)->(Array<Dictionary<String,String>>)
    {
    
    let path = Bundle.main.path(forResource: name, ofType: "plist")
        
        let arr = NSArray(contentsOfFile: path!)
        return (arr as? Array<Dictionary<String,String>> )!
        
    }
    
    func getDataForDate(date:String)->(Array<[String:String]>)
    {
    let array = getSwiftArrayFromPlist(name: "Data")
    let namePredicate = NSPredicate(format:"OrderDate = %@", date)
        return [array.filter {namePredicate.evaluate(with: $0)}[0]]
        
      // print(getDataForDate(date: "5/3/2017"))
        
    }


}

