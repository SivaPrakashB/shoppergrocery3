//
//  CustomViewController.swift
//  FoodDeliveryCustomer
//
//  Created by iqmsoft on 11/10/16.
//  Copyright © 2016 iQmSoft. All rights reserved.
//

import UIKit

class CustomViewController: UITabBarController , UINavigationControllerDelegate {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().tintColor = UIColor.white
        UITabBar.appearance().barTintColor = UIColor.red
        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let dset = storyboard.instantiateViewController(withIdentifier: "Browse") as! StoresViewController
//        present(dset, animated: true, completion: nil)
        // Do any additional setup after loading the view.
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

}
