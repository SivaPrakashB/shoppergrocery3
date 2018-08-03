//
//  StoreItemsViewController.swift
//  FoodDeliveryCustomer
//
//  Created by iqmsoft on 11/8/16.
//  Copyright © 2016 iQmSoft. All rights reserved.
//

import UIKit
//import SwiftyJSON

struct items    {
    let id : String?
    let storeId : String?
    let catId : String?
    let subcatId : String?
    let itemName : String?
    let price : String?
    let deliverCharges : String?
    let packingCost : String?
    let discount : String?
    let image : UIImage?
    let notes : String?
    let dateCreated : String?
    
    init(json: NSDictionary) {
        id = json["id"] as? String
        storeId = json["store_id"] as? String
        catId = json["cat_id"] as? String
        subcatId = json["subcat_id"] as? String
        itemName = json["item_name"] as? String
        price = json["price"] as? String
        deliverCharges = json["delivery_charges"] as? String
        packingCost = json["packing_cost"] as? String
        discount = json["discount"] as? String
        image = json["image"] as? UIImage
        notes = json["notes"] as? String
        dateCreated = json["date_created"] as? String
    }
    
}


class StoreItemsViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource ,UISearchBarDelegate {

    var defaults = UserDefaults.standard
    var itemlist = [NSMutableDictionary]()
    var dataArray = [AnyObject]()
    var selectedItemID = ""
    var stredImages = ""
    var storeID : String = ""
    var dis = ""
    
    @IBOutlet weak var getStoreName: UILabel!
    @IBOutlet weak var storeimage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var milesLabel: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    
    //search fields
    @IBOutlet weak var searchController: UISearchBar!
    var filteredArray = [NSMutableDictionary]()
    var searchActive : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Store ID:\(storeID)")
        getMenuItemListJSON()
       getStoreImageAndName()
         self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.delegate = self
        tableView.dataSource = self
      searchController.delegate = self
        getData()
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
        tableView.reloadData()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !searchActive {
            searchActive = true
            tableView.reloadData()
        }
        
        searchController.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredArray = itemlist.filter({ (text) -> Bool in
            let tmp = text.object(forKey: "item_name") as! NSString
            let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            return range.location != NSNotFound
        })
        
        
        if(filteredArray.count == 0 ){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.tableView.reloadData()
    }

    
    func getStoreImageAndName() {
        let image = defaults.object(forKey: "StoreImage")
        if let img = image {
            print("+++\(img)+++")
            if let data = NSData(contentsOf: NSURL(string:"http://zenith.instest.net/groceryapi/public/img/\(img)" ) as! URL) {
                self.storeimage.image = UIImage(data: data as Data)
            }
        }
        let getName = defaults.object(forKey: "PassingName") as! String
        let getRating = defaults.object(forKey: "StoreRatings") as! Double
        if getRating.isZero == true {
             self.ratingView.isHidden = true
             self.milesLabel.isHidden = false
             self.milesLabel.text = "No ratings yet!"
        } else {
            self.milesLabel.isHidden = true
            self.ratingView.rating = getRating
            self.ratingView.settings.updateOnTouch = false
        }
        self.getStoreName.text = getName
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func getMenuItemListJSON(){
        let ids = defaults.object(forKey: "StoreID")
        let id = ids! as! String
        let mainUrl = RequiredURLS().storeItemShow + id
        let mySession = URLSession.shared
        let url: NSURL = NSURL(string: mainUrl)!
        let networkTask = mySession.dataTask(with: url as URL, completionHandler : {data, response, error -> Void in
            let err: NSError?
            var results : [NSDictionary]!
            do {
                let theJSON = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSMutableDictionary
                if theJSON["items"] != nil {
                    results  = theJSON.object(forKey: "items") as! [NSDictionary]!
                    self.itemlist = results as! [NSMutableDictionary]
                }  else {
                    print("No data")
                }
            }  catch {
                print("error serializing JSON: \(err)")
            }
            DispatchQueue.main.async(execute: {
                self.tableView!.reloadData()
                print("$$$$\(self.itemlist)")
            })
        })
        networkTask.resume()
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        var numOfSections: Int = 0
        if itemlist.count > 0 || filteredArray.count > 0
        {
            tableView.separatorStyle = .singleLine
            numOfSections                = 1
            tableView.backgroundView = nil
        }
        else
        {
            numOfSections                = 1
            let noDataLabel: UILabel     = UILabel(frame: CGRect(x:0, y:0, width:tableView.bounds.size.width, height :tableView.bounds.size.height))
            
//            let icon : UIImage = UIImage(named: "Sad")!
//            let iconView : UIImageView = UIImageView(image: icon)
//            iconView.frame = CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height)
//            tableView.backgroundView?.addSubview(iconView)
            
            noDataLabel.text             = "No menu items available."
            noDataLabel.textColor        = UIColor.lightGray
            noDataLabel.adjustsFontSizeToFitWidth = true
            noDataLabel.font = noDataLabel.font.withSize(36)
            noDataLabel.numberOfLines = 2
            noDataLabel.textAlignment    = .center
            tableView.backgroundView = noDataLabel
            tableView.separatorStyle = .none
//            self.getStoreName.isHidden = true
//            self.storeimage.isHidden = true
        }
        return numOfSections
    }
    

 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive) {
            return filteredArray.count
        }
        return itemlist.count
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(searchActive){
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! StoreItemTableViewCell
            let simpleEntry : NSMutableDictionary = self.filteredArray[indexPath.row]
            cell.itemName.text = simpleEntry["item_name"] as? String
            cell.catName.text = simpleEntry["catName"] as? String
          return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! StoreItemTableViewCell
            let simpleEntry : NSMutableDictionary = self.itemlist[indexPath.row]
            cell.itemName.text = simpleEntry["item_name"] as? String
            cell.catName.text = simpleEntry["catName"] as? String
            return cell
        }
    }
    
  
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(searchActive){
            let simpleEntry : NSMutableDictionary = self.filteredArray[indexPath.row]
            selectedItemID = (simpleEntry["id"] as? String)!
            defaults.set(selectedItemID, forKey: "ItemID")
            print("ItemID :\(selectedItemID)")
        }else {
            let simpleEntry : NSMutableDictionary = self.itemlist[indexPath.row]
            selectedItemID = (simpleEntry["id"] as? String)!
            defaults.set(selectedItemID, forKey: "ItemID")
            print("ItemID :\(selectedItemID)")
        }
    }
    
     func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Menu Items"
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vw = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 10))
        vw.backgroundColor = UIColor.darkGray
        let label = UILabel(frame: CGRect(x: 2, y: 8.5, width: 100, height: 12))
        label.text = "Menu Items"
        label.textColor = UIColor.white
        vw.addSubview(label)
        
        return vw
    }    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension StoreItemsViewController: StoreItemTableViewCellDelegate {
    func stepperButton(sender : StoreItemTableViewCell) {
        guard let index = tableView.indexPath(for: sender)?.row else { return }
        //fetch the dataSource object using index
        
    }
}
