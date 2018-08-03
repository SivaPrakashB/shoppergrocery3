//
//  StoresViewController.swift
//  FoodDeliveryCustomer
//
//  Created by iqmsoft on 11/7/16.
//  Copyright © 2016 iQmSoft. All rights reserved.
//

import UIKit
import Foundation
//import SwiftyJSON 
import CoreLocation
import MapKit

class StoresViewController: UIViewController , UITableViewDelegate , UITableViewDataSource,CLLocationManagerDelegate ,UISearchBarDelegate {
   
    @IBOutlet weak var tableView: UITableView!
    let distanceFormatter = MKDistanceFormatter()
    var latitude = [String]()
    var longitude = [String]()
    var storeCellID : String = ""
    var defaults = UserDefaults.standard
    var storedImage : String = ""
    var passingName = ""
    var imageCache = [String:UIImage]()
    
    var storeItemsViewController : StoreItemsViewController? = nil
    
    var filteredStores = [NSDictionary]()
    var selectedCellRating = 0.0
    var selectedCellDistance = [String]()
    var items = [ItemDetails]()
   
    //search stores
    @IBOutlet weak var searchController: UISearchBar!
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
        searchController.delegate = self
         self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        getData()
        if locationManager == nil {
            locationManager = CLLocationManager()
            locationManager!.delegate = self
            locationManager!.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager!.requestAlwaysAuthorization()
            locationManager!.distanceFilter = 50
            locationManager!.startUpdatingLocation()
        }
        
        DispatchQueue.main.async(execute: {
            self.tableView.reloadData()
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
             self.tableView.reloadData()
        } else {
            searchActive = true;
        }
        self.tableView.reloadData()
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
    func gettingStoreList() {
        
        //let urlString = RequiredURLS().storesUrl
       // print("urlString : \(urlString)")
        let url = URL(string:"http://zenith.instest.net/groceryapi/store/get")
        URLSession.shared.dataTask(with:url!) { (data, response, error) in
            if error != nil {
                print(error)
            } else {
                do{
                    let resultJSON = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions())
                    let arrayJSON = resultJSON as! NSArray
                    for value in arrayJSON{
                        let dicValue = value as! NSDictionary
                        self.storesList.append(dicValue)
                      //  self.latitude.append(dicValue.object(forKey: "lat") as! String)
                       // self.longitude.append(dicValue.object(forKey: "long") as! String)
                        print(self.storesList)
                    }
                    
                }catch _{
                    print("Received not-well-formatted JSON")
                }
                DispatchQueue.main.async(execute: {
                    self.tableView!.reloadData()
                })
                
            }
            
            }.resume()
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int
    {  var numOfSections : Int = 0
        if storesList.count > 0
        {
            tableView.separatorStyle = .singleLine
            numOfSections                = 1
            tableView.backgroundView = nil
        }
        else
        {
            numOfSections                = 1
            let noDataLabel: UILabel     = UILabel(frame: CGRect(x:0, y:0, width:tableView.bounds.size.width, height :tableView.bounds.size.height))
            noDataLabel.text             = "Sorry!       No Restaurants available at your location"
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
            self.tableView.reloadData()
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive) {
            return filteredStores.count
        }
        return storesList.count
    }
        
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! StoresTableViewCell
        
       if (searchActive) {
            let simpleEntry : NSDictionary = self.filteredStores[indexPath.row]
            
            cell.storeName.text = simpleEntry["store_name"] as? String
            cell.location.text = simpleEntry["location"] as? String
            let img = simpleEntry.object(forKey: "image") as! String
        OperationQueue.main.addOperation{
            print("image name:\(img)")
            cell.photo.sd_setImage(with: NSURL(string:"http://zenith.instest.net/groceryapi/public/img/\(img)") as URL? , placeholderImage: UIImage(named: "Placeholder"))
            
            let firstLoc = CLLocation(latitude:Double(self.latitude[indexPath.row])!  , longitude:Double(self.longitude[indexPath.row])! )
            let secondLoc = CLLocation(latitude: self.userLatitude, longitude: self.userLongitude)
            let dist = firstLoc.distance(from: secondLoc) / 1000
            let distFor = self.distanceFormatter.string(fromDistance: dist)
            print("distance is:\(distFor)")
            cell.distance.text = distFor
            
            let rating = simpleEntry["rating"] as? Double
            if rating?.isZero == true {
                cell.cosmosRatingView.isHidden = true
                cell.noRatingLabel.isHidden = false
                cell.noRatingLabel.text = "No ratings yet!"
            } else {
                cell.cosmosRatingView.rating = rating!
                cell.cosmosRatingView.settings.updateOnTouch = false
                cell.cosmosRatingView.settings.fillMode = .precise
            }
        }

        }
        else {
            let simpleEntry : NSDictionary = self.storesList[indexPath.row]
            
            cell.storeName.text = simpleEntry["store_name"] as? String
            cell.location.text = simpleEntry["location"] as? String
            let img = simpleEntry.object(forKey: "photo") as! String
        OperationQueue.main.addOperation{
            print("image name:\(img)")
            cell.photo.sd_setImage(with: NSURL(string:"http://zenith.instest.net/groceryapi/public/img/\(img)") as URL? , placeholderImage: UIImage(named: "Placeholder"))
            
            /*let firstLoc = CLLocation(latitude:Double(self.latitude[indexPath.row])!  , longitude:Double(self.longitude[indexPath.row])! )
            let secondLoc = CLLocation(latitude: self.userLatitude, longitude: self.userLongitude)
            let dist = firstLoc.distance(from: secondLoc) / 1000
            let distFor = self.distanceFormatter.string(fromDistance: dist)
            print("distance is:\(distFor)")
            cell.distance.text = distFor
            
            let rating = simpleEntry["rating"] as? Double
            if rating?.isZero == true {
                cell.cosmosRatingView.isHidden = true
                cell.noRatingLabel.isHidden = false
                cell.noRatingLabel.text = "No ratings yet!"
            } else {
                cell.cosmosRatingView.rating = rating!
                cell.cosmosRatingView.settings.updateOnTouch = false
                cell.cosmosRatingView.settings.fillMode = .precise
            }*/
          }
        }
        
        return cell
    }

    func distanceInMetersFrom(destinationLatitude:Double ,destinationlongitude : Double ) -> CLLocationDistance {
        let firstLoc = CLLocation(latitude:destinationLatitude  , longitude:destinationlongitude )
        let secondLoc = CLLocation(latitude: userLatitude, longitude: userLongitude)
        let dist = firstLoc.distance(from: secondLoc) / 1000
        let distFor = distanceFormatter.string(fromDistance: dist)
        print("distance is:\(distFor)")
        return dist
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if(searchActive) {
            let simpleEntry : NSDictionary = self.filteredStores[indexPath.row]
            storedImage = (simpleEntry["image"] as? String)!
            print("--\(storedImage)--")
            passingName = (simpleEntry["store_name"] as? String)!
            defaults.set(passingName, forKey: "PassingName")
            defaults.set(storedImage, forKey: "StoreImage")
            print("Row **\(indexPath.row)selected")
            storeCellID = (simpleEntry["id"] as? String)!
            selectedCellRating = (simpleEntry["rating"] as? Double)!
            defaults.set(selectedCellRating, forKey: "StoreRatings")
            defaults.set(storeCellID, forKey: "StoreID")
            print("--\(storeCellID)--")
        }
        else {
            let simpleEntry : NSDictionary = self.storesList[indexPath.row]
           // storedImage = (simpleEntry["image"] as? String)!
            // print("--\(storedImage)--")
            passingName = (simpleEntry["store_name"] as? String)!
            defaults.set(passingName, forKey: "PassingName")
            defaults.set(storedImage, forKey: "StoreImage")
            print("Row **\(indexPath.row)selected")
            storeCellID = (simpleEntry["id"] as? String)!
            //selectedCellRating = (simpleEntry["rating"] as? Double)!
            defaults.set(selectedCellRating, forKey: "StoreRatings")
            defaults.set(storeCellID, forKey: "StoreID")
            print("--\(storeCellID)--")
        }
        
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "StoreItems" {
            let destination = segue.destination as! StoreItemsViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                let simpleEntry : NSDictionary = self.storesList[indexPath.row]
                let selectedRepo = (simpleEntry["id"] as? String)!
                destination.storeID = selectedRepo
            }
           destination.stredImages = passingName
        }
        
    }


}




extension UIImageView {
    func downloadImageFrom(link:String, contentMode: UIViewContentMode) {
        URLSession.shared.dataTask( with: NSURL(string:link)! as URL, completionHandler: {
            (data, response, error) -> Void in
           DispatchQueue.main.async(execute: {
                self.contentMode =  contentMode
                if let data = data { self.image = UIImage(data: data) }
            })
      })
    }
}

