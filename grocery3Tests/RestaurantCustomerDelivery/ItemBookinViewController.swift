//
//  ItemBookinViewController.swift
//  FoodDeliveryCustomer
//
//  Created by iqmsoft on 11/10/16.
//  Copyright © 2016 iQmSoft. All rights reserved.
//

import UIKit



class ItemBookinViewController: UIViewController {

    var defaults = UserDefaults.standard
    
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemCategory: UILabel!
    @IBOutlet weak var itemSubCategory: UILabel!
    @IBOutlet weak var itemPrice: UILabel!
    
    @IBOutlet weak var quantityStepper: UIStepper!
    @IBOutlet weak var quantityLabel: UILabel!
    
    @IBOutlet weak var totalItemAmount: UILabel!
    @IBOutlet weak var deliveryCharges: UILabel!
    @IBOutlet weak var packingCost: UILabel!
    @IBOutlet weak var discount: UILabel!
    @IBOutlet weak var grandTotal: UILabel!
    @IBOutlet weak var instructions: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var cart: UIButton!
    
    var pricing : Double = 0
    var delCharges : Double = 0
    var packCost : Double = 0
    var disc : Int = 0
    //passingvalues
    var addedAmount : Double = 0
    var storeIDs = ""
    var itemIDs = ""
    var quantity : Int  = 0
    var notes = ""
    var passingItemName = ""
    var passingStoreName = ""
    var previousStoreID = ""
    var defaultPrice = ""
    var defaultDelivery = ""
    var defaultPacking = ""
    var defaultDiscount = ""
    
    var item : [ItemDetails] = []
    var itemCount = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        notes = self.instructions.text!
        getItemDetails()
         getData()
        let ids = defaults.object(forKey: "StoreID")
        storeIDs = ids! as! String
        
        let ids1 = defaults.object(forKey: "PassingName")
        passingStoreName = ids1! as! String
        
        NotificationCenter.default.addObserver(self, selector: #selector(ItemBookinViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ItemBookinViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.black]
        // Do any additional setup after loading the view.
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.scrollView.frame.origin.y == 0{
                self.scrollView.frame.origin.y -= keyboardSize.height
            }
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.scrollView.frame.origin.y != 0{
                self.scrollView.frame.origin.y += keyboardSize.height
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

    
    func getItemDetails() {
        
        let ids = defaults.object(forKey: "ItemID")
        itemIDs = ids! as! String
        
        print("ItemID to pass : \(itemIDs)")
        let urlString =   RequiredURLS().itemViewUrl + "\(itemIDs)"
        let url = NSURL(string: urlString)
        if let JSONData = NSData(contentsOf: url as! URL) {
            print(JSONData)
            if let json = (try? JSONSerialization.jsonObject(with: JSONData as Data, options: [])) as? NSDictionary {
                if let reposArray = json as? [String: AnyObject] {
                    print("reposarray\(reposArray)")
                    if let itemname = reposArray["item_name"] as? String {
                        self.itemName.text = itemname
                        self.headingLabel.text = itemname
                         passingItemName = itemname
                        print("itemname :\(itemname)")
                        
                        if let cat = reposArray["catName"] as? String {
                            self.itemCategory.text = cat
                              print("category :\(cat)")
                            
                            if let subcat = reposArray["subcatName"] as? String {
                                self.itemSubCategory.text = subcat
                                 print("subcat :\(subcat)")
                                
                                if let prce = reposArray["price"] as? String {
                                         self.itemPrice.text = "$\(prce)"
                                        defaultPrice = prce
                                     print("price :\(prce)")
                                    
                                    if let prce = reposArray["price"]?.doubleValue {
                                        pricing = Double(prce)
                                        print("pricing :\(pricing)")
                                    
                                    if let dlvry = reposArray["delivery_charges"]?.doubleValue {
                                        self.deliveryCharges.text = "$\(dlvry)"
                                        delCharges = Double(dlvry)
                                        print("delivery :\(dlvry)")
                                        
                                        if let pckngcst = reposArray["packing_cost"]?.doubleValue {
                                            self.packingCost.text = "$\(pckngcst)"
                                            packCost = Double(pckngcst)
                                             print("packing :\(pckngcst)")
                                            
                                            if let discount = reposArray["discount"]?.integerValue {
                                                self.discount.text = "\(discount)%"
                                                disc = discount
                                                 print("discount :\(discount)")
                                                
                                                if let image = reposArray["image"] as? String {
                                                    if let data = NSData(contentsOf: NSURL(string:"http://zeus.instest.net/restaurantapi/public/img/\(image)" ) as! URL) {
                                                        self.itemImage.image = UIImage(data: data as Data)
                                                    }
                                                }
                                            }
                                         }
                                     }
                                  }
                               }
                            }
                        }
                    }
                }
            }
        }

        
    }
    
    
    func multiplication() {
        
        print("**TOTAL\(quantity)\(pricing)")
        let total : Double = Double(quantity) * Double(pricing)
        self.totalItemAmount.text =  "$\(String(total))"
        
        let delCh = delCharges * Double(quantity)
        self.deliveryCharges.text = "$\(String(delCh))"
        
        let quaPackng = packCost * Double(quantity)
        self.packingCost.text = "$\(String(quaPackng))"
        
        let subtotal : Double = total + Double(delCh) + Double(quaPackng)
        let discounts = (Double(disc) / Double(100)) * Double(subtotal)
        let discountSub = subtotal - discounts
        print("GrandTotal\(discountSub)")
        self.grandTotal.text = "$\(String(discountSub))"
        addedAmount = Double(discountSub)
        cart.setTitle("Add to cart $ \(String(discountSub))", for: UIControlState.normal)
    }
    
    @IBAction func quantityTapped(_ sender: UIStepper) {
        
        quantityLabel.text = "\(Int(quantityStepper.value)) X"
        quantity = Int(quantityStepper.value)
        if quantity == 0 {
             self.totalItemAmount.text =  "$0"
             self.deliveryCharges.text = "$\(String(delCharges))"
            self.packingCost.text = "$\(String(packCost))"
            self.grandTotal.text = "$0"
            cart.setTitle("Select Quantity", for: UIControlState.normal)
            
        } else {
            multiplication()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getDatas() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            item = try context.fetch(ItemDetails.fetchRequest())
            itemCount = item.count
            for items in item {
                previousStoreID = String(items.storeid)
                print("Previous id : \(previousStoreID)")
            }
            print("ItemCount = \(itemCount)")
            let tabArray = self.tabBarController?.tabBar.items as NSArray!
            let tabItem = tabArray?.object(at: 3) as! UITabBarItem
            tabItem.badgeValue = "\(itemCount)"
        } catch {
            print("Data couldn't fetched")
        }
    }
    
    
    func deleteItems() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        
        do
        {
            self.item = try managedContext.fetch(ItemDetails.fetchRequest())
            for managedObject in self.item
            {
                managedContext.delete(managedObject)
            }
            try managedContext.save()
        } catch let error as NSError {
            print("Detele all data in \(ItemDetails.self) error : \(error) \(error.userInfo)")
        }
        getData()
        self.item.removeAll()
      
    }

    
    
    @IBAction func addToCartTapped(_ sender: UIButton) {
       
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let item = ItemDetails(context: context)
        if (defaults.object(forKey: "StoreID") as! String) == previousStoreID || itemCount == 0{
          if quantity == 0 {
              let alert = UIAlertController(title: "Please select quantity", message: "", preferredStyle: UIAlertControllerStyle.alert)
              let ok = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default)  { ACTION in
               }
               alert.addAction(ok)
               self.present(alert, animated: true, completion: nil)
           }
        else {
           
           item.itemid = Int32(itemIDs)!
           item.storeid = Int32(storeIDs)!
           item.quantity = Int32(quantity)
           item.price = Double(addedAmount)
           item.notes = instructions.text
           item.itemname = passingItemName
           item.storename = passingStoreName
        
          (UIApplication.shared.delegate as! AppDelegate).saveContext()
         let alert = UIAlertController(title: "Item Added", message: "Successfully!", preferredStyle: UIAlertControllerStyle.alert)
         let ok = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default)  { ACTION in
            self.getDatas()
             NotificationCenter.default.post(name:NSNotification.Name(rawValue: "CartsList"), object: nil)
             self.navigationController?.popViewController(animated: true)
         }
         alert.addAction(ok)
         self.present(alert, animated: true, completion: nil)
//        tabBarController?.selectedIndex = 3
         }
        } else {
            let alert = UIAlertController(title: "", message: "It seems that your cart has items from another restaurant. Do you want to clear it and start afresh?", preferredStyle: UIAlertControllerStyle.alert)
            let ok = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default)  { ACTION in
                self.deleteItems()
            }
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
       
    }
    
    
    
    
  
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//        let orderDetails = segue.destination as! CartViewController
//        orderDetails.delegate =  self
//        orderDetails.itemID.append(Int(itemIDs)!)
//        orderDetails.price.append(addedAmount)
//        orderDetails.storeID.append(Int(storeIDs)!)
//        orderDetails.quantity.append(quantity)
//        orderDetails.notes.append(notes)
//        orderDetails.itemName.append(passingItemName)
//        orderDetails.storeName.append(passingStoreName)
//    }
    

}


