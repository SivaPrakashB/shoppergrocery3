//
//  loginsucces.swift
//  grocery3
//
//  Created by mac on 7/25/17.
//  Copyright © 2017 mac. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation
import MapKit

class loginsucces: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,CLLocationManagerDelegate {

    
    
    @IBOutlet var tableview: UITableView!
    let distanceFormatter = MKDistanceFormatter()
    var latitude = [String]()
    var longitude = [String]()
    var storeCellID : String = ""
    var defaults = UserDefaults.standard
    var storedImage : String = ""
    var passingName = ""
    var imageCache = [String:UIImage]()
    var websiteurl=[String]()
    var imageslinks=["http://zenith.instest.net/groceryapi/public/img/store10.jpg","http://zenith.instest.net/groceryapi/public/img/store9.jpg","http://zenith.instest.net/groceryapi/public/img/store5.jpg","http://zenith.instest.net/groceryapi/public/img/store3.jpg","http://zenith.instest.net/groceryapi/public/img/store1.jpg","http://zenith.instest.net/groceryapi/public/img/store7.jpg"]
    var storeItemsViewController : StoreItemsViewController? = nil
    
    var filteredStores = [NSDictionary]()
    var selectedCellRating = 0.0
    var selectedCellDistance = [String]()
    var items = [String]()
    

    
    @IBOutlet var searchbar: UISearchBar!
    var searchActive : Bool = false
    
    
    //location access
    var locationManager : CLLocationManager?
    var userLongitude : Double = 0
    var userLatitude : Double = 0
    var calculatedDistance = [String]()
    var locationDet = [CLLocation]()
    var storesList = [NSDictionary]()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gettingStoreList()
        searchbar.delegate = self
        
        self.tableview.tableFooterView = UIView(frame: CGRect.zero)
     // getData()
        if locationManager == nil {
            locationManager = CLLocationManager()
            locationManager!.delegate = self
            locationManager!.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager!.requestAlwaysAuthorization()
            locationManager!.distanceFilter = 50
            locationManager!.startUpdatingLocation()
           

        }
        
        DispatchQueue.main.async(execute:
            {
                self.tableview.reloadData()
        })
        
        
        // Do any additional setup after loading the view.
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
       
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchbar.endEditing(true)
        searchActive = false;
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredStores = storesList.filter({ (text) -> Bool in
            let tmp = text.object(forKey: "store_name") as! NSString
            let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            return range.location != NSNotFound
        })
        
        
        if(filteredStores.count == 0 ){
            searchActive = false;
            self.tableview.reloadData()
        } else {
            searchActive = true;
        }
        self.tableview.reloadData()
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        CLGeocoder().reverseGeocodeLocation(manager.location! ,completionHandler:  { (placemarks, error) -> Void in
            if error != nil {
                print("Error :" + (error?.localizedDescription)!)
                return
            }
            let locValue : CLLocationCoordinate2D = manager.location!.coordinate
            self.userLatitude = locValue.latitude
            self.userLongitude = locValue.longitude
            
            if (placemarks?.count)! > 0 {
                let pm = placemarks![0]
                self.displayLocationInfo(placemarks: pm)
            } else {
                print("Problem with the data received from geocoder")
            }
        })
        
    }
    
    func displayLocationInfo(placemarks : CLPlacemark) {
        self.locationManager?.stopUpdatingLocation()
        print(placemarks.locality!)
        print(placemarks.postalCode!)
        print(placemarks.administrativeArea!)
        print(placemarks.country!)
        
    }
    
    
    func calculation() {
        for (lat, long) in zip(latitude, longitude) {
            let det = CLLocation(latitude:Double(lat)!  , longitude: Double(long)! )
            locationDet.append(det)
        }
        calculatingDistance(userLatitude : userLatitude , userLongitude : userLongitude)
    }
    
    func calculatingDistance(userLatitude : Double , userLongitude : Double) {
        for dis in locationDet {
            let secondLoc = CLLocation(latitude: userLatitude, longitude: userLongitude)
            let dist = dis.distance(from: secondLoc) / 1000
            let distFor = self.distanceFormatter.string(fromDistance: dist)
            print("distance :\(dist)")
            self.calculatedDistance.append(String(distFor))
            print("Calculated Distance\(calculatedDistance)")
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while updating location " + error.localizedDescription)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //getting Stores list
    func gettingStoreList()
    {
        
 //       let urlString = RequiredURLS().storesUrl
     //   print("urlString : \(urlString)")
        let url = URL(string: "http://zenith.instest.net/groceryapi/store/get")
        URLSession.shared.dataTask(with:url!)
        { (data, response, error) in
            if error != nil {
                print(error)
            }
            else {
                do{
                    let resultJSON = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions())
                    let arrayJSON = resultJSON as! NSArray
                    for value in arrayJSON{
                        let dicValue = value as! NSDictionary
                        self.storesList.append(dicValue)
                        self.latitude.append(dicValue.object(forKey: "lattitude") as! String)
                        self.longitude.append(dicValue.object(forKey: "longitude") as! String)
                        print(self.storesList)
                    }
                    
                }
                catch {
                    print("Received not-well-formatted JSON")
                }
                DispatchQueue.main.async(execute: {
                    self.tableview!.reloadData()
                })
                
            }
            
            }.resume()
    }
    
    
    
   func numberOfSections(in tableView: UITableView) -> Int
    {  var numOfSections : Int = 0
        if storesList.count > 0
        {
            tableView.separatorStyle = .singleLine
            numOfSections=1
            tableView.backgroundView = nil
        }
        else
        {
            numOfSections                = 1
            let noDataLabel: UILabel     = UILabel(frame: CGRect(x:0, y:0, width:tableView.bounds.size.width, height :tableView.bounds.size.height))
            noDataLabel.text             = "Sorry!No Stores available at your location"
            noDataLabel.textColor        = UIColor.lightGray
            noDataLabel.adjustsFontSizeToFitWidth = true
            noDataLabel.font = noDataLabel.font.withSize(28)
            noDataLabel.numberOfLines = 2
            noDataLabel.textAlignment    = .center
            tableView.backgroundView = noDataLabel
            tableView.separatorStyle = .none
        }
        return numOfSections
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async(execute: {
            self.tableview.reloadData()
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive)
        {
            return filteredStores.count
        }
        return storesList.count
                            }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
         let cell = tableView.dequeueReusableCell(withIdentifier: "sivacell") as! storesTableViewCell
        
        
        
        
        
        if (searchActive) {
            let simpleEntry : NSDictionary = self.filteredStores[indexPath.row]
            
            cell.storename.text = simpleEntry["store_name"] as? String
            let weburl=simpleEntry["website"] as? String
            
           /* websiteurl=simpleEntry["websitenae"] as String
            print(websiteurl)
            let url1=NSURL(string: websiteurl) as! URL
    
            UIApplication.shared.open(url1, options: [:], completionHandler: nil)*/
            
            //cell.location.text = simpleEntry["location"] as? String
            //let img = simpleEntry.object(forKey: "image") as! String
           // OperationQueue.main.addOperation{
               // print("image name:\(img)")
           
               //cell.photo.downloadImageFrom(link: "http://zenith.instest.net/groceryapi/public/img/", contentMode:.scaleToFill)
                
                
            var photoname=simpleEntry["photo"]
            
            DispatchQueue.global().async {
                let url = URL(string: "http://zenith.instest.net/groceryapi/public/img/"+"\(photoname!)")
                
                let imageData = try? Data(contentsOf: url!)
                
                DispatchQueue.main.async {
                    
                    cell.photo.image = UIImage(data: imageData!)
                    
                    
                }
            }                
                let firstLoc = CLLocation(latitude:Double(self.latitude[indexPath.row])!  , longitude:Double(self.longitude[indexPath.row])! )
                let secondLoc = CLLocation(latitude: self.userLatitude, longitude: self.userLongitude)
                let dist = firstLoc.distance(from: secondLoc) / 1000
                let distFor = self.distanceFormatter.string(fromDistance: dist)
                print("distance is:\(distFor)")
                cell.distance.text = distFor
            
              /*  let rating = simpleEntry["rating"] as? Double
                if rating?.isZero == true {
                    cell.cosmosRatingView.isHidden = true
                    cell.noRatingLabel.isHidden = false
                    cell.noRatingLabel.text = "No ratings yet!"
                } else {
                    cell.cosmosRatingView.rating = rating!
                    cell.cosmosRatingView.settings.updateOnTouch = false
                    cell.cosmosRatingView.settings.fillMode = .precise
                }*/
            
            DispatchQueue.main.async(execute: {
                self.tableview.reloadData()
            })
        }
        else
    {
        let simpleEntry : NSDictionary = self.storesList[indexPath.row]
        
        cell.storename.text = simpleEntry["store_name"] as? String
        let weburl=simpleEntry["website"] as? String
        print(weburl!)
        
        //cell.location.text = simpleEntry["location"] as? String
        //let img = simpleEntry.object(forKey: "photo") as! String
        //OperationQueue.main.addOperation{
        //  print("image name:\(img)")
        //cell.photo.sd_setImage(with: NSURL(string:"http://zenith.instest.net/groceryapi/public/img/\(img)") as URL? , placeholderImage: UIImage(named: "Placeholder"))
        /*let url = URL(string: imageslinks[indexPath.row])
         let data = try? Data(contentsOf: url!)
         cell.photo.image = UIImage(data: data!)*/
        var photoname=simpleEntry["photo"]
        
        DispatchQueue.global().async {
            let url = URL(string: "http://zenith.instest.net/groceryapi/public/img/"+"\(photoname!)")
            
            let imageData = try? Data(contentsOf: url!)
            
            DispatchQueue.main.async {
                
                cell.photo.image = UIImage(data: imageData!)
                
                           

            }
        }
        
        let firstLoc = CLLocation(latitude:Double(self.latitude[indexPath.row])!  , longitude:Double(self.longitude[indexPath.row])! )
        let secondLoc = CLLocation(latitude: self.userLatitude, longitude: self.userLongitude)
        let dist = firstLoc.distance(from: secondLoc) / 1000
        let distFor = self.distanceFormatter.string(fromDistance: dist)
        print("distance is:\(distFor)")
        cell.distance.text = distFor
        //}
        
        
        
        }
        
      
    return cell
}
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let simpleEntry : NSDictionary = self.storesList[indexPath.row]
        let weburl=simpleEntry["website"] as? String
      let  weburl1:String=(weburl!)
        var ordertmp:String=(simpleEntry["id"]! as! String)
        print("ordertmp:\(ordertmp)")
        UserDefaults.standard.set(ordertmp, forKey: "orderid2")
      /*  print(weburl1)
        let settingsUrl = URL(string:"http://\(weburl1)") as! URL
            print(settingsUrl)*/
        UserDefaults.standard.set(weburl1,forKey: "urlweb")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "web1ViewController") as! UIViewController
        self.present(vc, animated: true, completion: nil)
        
        /*  websiteurl=(simpleEntry["wesite"] as? String)!
        print(websiteurl)
        let url1=NSURL(string: websiteurl) as! URL
        
        UIApplication.shared.open(url1, options: [:], completionHandler: nil)*/
    
    
}

    @IBAction func logout(_ sender: UIBarButtonItem) {
        let alert=UIAlertController(title: "Logout", message: "Do you want to layout", preferredStyle:UIAlertControllerStyle.actionSheet)
        let actioncancel=UIAlertAction(title: "cancel", style: .default,handler: {
            (alert: UIAlertAction!) -> Void in
            print("File Deleted")
        })
        let action = UIAlertAction(title: "Ok", style:.default)
        {
            
            ACTION in
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! UIViewController
            self.present(vc, animated: true, completion: nil)
            
        }
        
        
        alert.addAction(action)
        alert.addAction(actioncancel)
        self.present(alert, animated: true, completion:nil)
    }
    

    


}
