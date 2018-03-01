//
//  DataDetailLookupViewController.swift
//  3M L&M
//
//  Created by IndianRenters on 21/09/17.
//  Copyright © 2017 3M L&M. All rights reserved.
//

import Foundation
import UIKit


class DataDetailLookupViewController: UIViewController, CLLocationManagerDelegate,GMSMapViewDelegate,UITableViewDelegate, UITableViewDataSource,UIScrollViewDelegate
{
    @IBOutlet weak var scroll:UIScrollView!
    @IBOutlet var fullScreenImageView: UIImageView!
    
    var datalookupMapView = GMSMapView()
    var locationManager = CLLocationManager()
    let lookupMarker = GMSMarker()
    
    
    var logDataArray: NSDictionary = [:]
    var logDataDetailsArray: NSArray = []
    
    var section0LeftArray: NSArray = []
    var section0RightArray: NSArray = []
    var latitude:String = "0.000000"
    var longtitude:String = "0.000000"
    
    var section2LeftArray: NSMutableArray = []
    var section2RightArray: NSMutableArray = []
    
    
    var section3LeftArray: NSMutableArray = []
    var section3RightArray: NSMutableArray = []
    var dataTypeArray: NSMutableArray = []
    
    @IBOutlet var detailsView:UIView!
    var storage:String = ""
    
    
    override func viewWillAppear(_ animated: Bool) {
        //TODO: Reload the tableview to get lang updated.
        
    }
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return fullScreenImageView
    }
    override func viewDidLoad() {
        print(logDataDetailsArray)
        print(logDataArray)
        self.title = NSLocalizedString("Data Lookup Details", comment: " ")
        scroll.delegate = self

        var recordTypeId:String = "-"
        var projectName:String = "-"
        var upcCode:String = "-"
        var rfidSerialNumber:String = "-"
        var updatedBy:String = "-"
        var updatedDate:String = "-"
        
        
        
        if let value =   logDataArray.value(forKey: "recordTypeId") as? Int{
            if value == 1 {
                recordTypeId = "RFID Program"
            }
            else if value == 2{
                recordTypeId = "EMS Passive"
            }
            else if value == 3{
                recordTypeId = "Cable Accessories"
            }
        }
        if let value =   logDataArray.value(forKey: "projectName") as? String{
            projectName = value
        }
        if let value =   logDataArray.value(forKey: "upcCode") as? String{
            upcCode = value
        }
        if let value =   logDataArray.value(forKey: "rfidSerialNumber") as? String{
            rfidSerialNumber = value
        }
        if let value =   logDataArray.value(forKey: "latitude") as? String{
            latitude = value
        }
        if let value =   logDataArray.value(forKey: "longtitude") as? String{
            longtitude = value
        }
        if let value =   logDataArray.value(forKey: "updatedBy") as? String{
            updatedBy = value
        }
        if let value =   logDataArray.value(forKey: "updatedDate") as? Int{
            updatedDate = String(String(value).characters.dropLast(3))
            
            let date = NSDate(timeIntervalSince1970: Double(updatedDate)!)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yy HH:mm"
            updatedDate = dateFormatter.string(from: date as Date)
            
        }
        
        
        
        
        
        
        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        
        section0LeftArray = [NSLocalizedString("Record Type", comment: "Record Type"),NSLocalizedString("Project Name", comment: "Project Name"),NSLocalizedString("UPC Code", comment: "UPC Code"),NSLocalizedString("RFID Serial No", comment: "RFID Serial No"),NSLocalizedString("latitude", comment: "latitude"),NSLocalizedString("longtitude", comment: "longtitude"),NSLocalizedString("updatedBy", comment: "updatedBy"),NSLocalizedString("updatedDate", comment: "updatedDate") ]
        section0RightArray = [recordTypeId,projectName,upcCode,rfidSerialNumber,latitude,longtitude,updatedBy,updatedDate]
        
        for i in 0 ..< logDataDetailsArray.count {
            
            let templateTypeId:Int = (logDataDetailsArray.value(forKey: "templateTypeId") as AnyObject).object(at: i) as! Int
            
            var label:String = ""
            var descrption:String = ""
            
            
            if let value = (logDataDetailsArray.value(forKey: "label") as AnyObject).object(at: i) as? String{
                label = value
            }
            
            
            
            
            if templateTypeId == 1 {
                
                if let value = (logDataDetailsArray.value(forKey: "description") as AnyObject).object(at: i) as? String{
                    descrption = value
                }
                
                
                section2LeftArray.add(label)
                section2RightArray.add(descrption)
            }
            else {
                
                
                var dataTypeId:Int = 0
                if let value = (logDataDetailsArray.value(forKey: "dataTypeId") as AnyObject).object(at: i) as? Int{
                    dataTypeId = value
                }
                

                
                if self.storage == "Cloud Storage" || dataTypeId != 6{
                    if let value = (logDataDetailsArray.value(forKey: "description") as AnyObject).object(at: i) as? String{
                        descrption = value
                    }
                }
                else
                {
                    let imagePath = (logDataDetailsArray.value(forKey: "imagePath") as AnyObject).object(at: i) as! String
                    
                    if imagePath == "" {
                        descrption = ""
                    }
                    else{
                        descrption =  String(format:"%@/%@",documentsDirectory,imagePath)
                    }
                }
                
                
                
                section3LeftArray.add(label)
                section3RightArray.add(descrption)
                dataTypeArray.add(dataTypeId)
                
                
            }
            
            
        }
        
        
        print(section2RightArray)
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
         //TealiumHelper.trackView(NSStringFromClass(self.classForCoder), dataSources: [:])
        
    }
    
    
    // MARK:  UITableView Data Source Methods
    internal func numberOfSections(in tableView: UITableView) -> Int {
        return 4
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat    {
        
        if indexPath.section == 1 {
            return 200
        }
        
        return 44
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return section0LeftArray.count
        }
        else if section == 1 {
            return 1
        }
        else if section == 2 {
            return section2LeftArray.count
        }
        else if section == 3 {
            return section3LeftArray.count
        }
        
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section == 0) {
            return NSLocalizedString("Marker Data", comment: "Marker Data")
        }
        else if(section == 1) {
            return  NSLocalizedString("Map", comment: "Map")
        }
        else if(section == 2 && section2LeftArray.count != 0){
            return NSLocalizedString("RFID Template Details", comment: "RFID Template Details")
        }
        else if(section == 3 && section3LeftArray.count != 0) {
            return  NSLocalizedString("Data Collection Template Details", comment: "Data Collection Template Details")
        }
        else {
            return ""
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 2 &&  section2LeftArray.count == 0{
            return 0.1
        }
        else  if section == 3 &&  section3LeftArray.count == 0{
            return 0.1
        }
        return 44
    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 3{
            return 20
        }
        return 0.1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell : CustomTableViewCell = (tableView.dequeueReusableCell(withIdentifier: "Section0Cell") as! CustomTableViewCell!)
        
        if indexPath.section == 0 {
            cell = (tableView.dequeueReusableCell(withIdentifier: "Section0Cell") as! CustomTableViewCell!)
            cell.titleLabel.text = section0LeftArray.object(at: indexPath.row) as? String
            cell.subLabel.text = section0RightArray.object(at: indexPath.row) as? String
        }
        else  if indexPath.section == 1 {
            cell = (tableView.dequeueReusableCell(withIdentifier: "Section1Cell") as! CustomTableViewCell!)
            
            let camera: GMSCameraPosition = GMSCameraPosition.camera(withLatitude: Double(latitude)!, longitude: Double(longtitude)!, zoom: 15.0)
            
            datalookupMapView = GMSMapView.map(withFrame:  CGRect(x: 0, y: 0, width: cell.mapView.frame.width, height: cell.mapView.frame.height), camera: camera)
            
            datalookupMapView.camera = camera
            datalookupMapView.mapType = kGMSTypeHybrid
            
            
            // Add GMSMapView to current view
            cell.mapView .addSubview(datalookupMapView)
            
            
            
            let lookupMarker = GMSMarker()
            
            lookupMarker.position = CLLocationCoordinate2D(latitude: Double(latitude)!, longitude: Double(longtitude)!)
            lookupMarker.title = ""
            lookupMarker.opacity = 1.0
            lookupMarker.icon = GMSMarker.markerImage(with: UIColor(red: 133/255.0, green:185.0/255.0, blue: 51.0/255.0, alpha: 1.0))
            lookupMarker.map = datalookupMapView
        }
            
        else if indexPath.section == 2 {
            cell = (tableView.dequeueReusableCell(withIdentifier: "Section0Cell") as! CustomTableViewCell!)
            cell.titleLabel.text = section2LeftArray.object(at: indexPath.row) as? String
            cell.subLabel.text = section2RightArray.object(at: indexPath.row) as? String
        }
            
        else if indexPath.section == 3 {
            cell = (tableView.dequeueReusableCell(withIdentifier: "Section2Cell") as! CustomTableViewCell!)
            cell.titleLabel.text = section3LeftArray.object(at: indexPath.row) as? String
            
            let dataTypeId = dataTypeArray .object(at: indexPath.row) as! Int
            let  descriptionId:String = section3RightArray.object(at: indexPath.row) as! String
            
            
            if dataTypeId == 6 && descriptionId != "" && descriptionId != "-"{
                
                
                if(self.storage == "Cloud Storage") {
                    
                    let utilityCompanyId:String = UserDefaults.standard.value(forKey: "utilityCompanyId") as! String
                    let urlString = String(format:"%@%@/file/%@",kUrlBase,utilityCompanyId,descriptionId)
                    
                    
                    
                    if URL(string: urlString) != nil {
                        cell.subLabel.text = NSLocalizedString("Image is loading...", comment: "Image is loading...")

                            ImageLoader.sharedLoader.imageForUrl(urlString: urlString, completionHandler:{(image: UIImage?, url: String) in
                                
                                if(image == nil){
                                    cell.subLabel.text = NSLocalizedString("No image available", comment: "No image available")
                                }
                                else{
                                    cell.iconImageView.image = image
                                    cell.subLabel.text = NSLocalizedString("Tap to view image", comment: "Tap to view image")
                                }
                            })
                    }
                    else{
                         cell.subLabel.text = NSLocalizedString("No image available", comment: "No image available")
                    }
                    
                    
                   
                }
                else
                {
                    if let image = UIImage(contentsOfFile: descriptionId){
                        let data = UIImageJPEGRepresentation(image, 0.5)
                        cell.iconImageView.image = UIImage(data: data!)
                        cell.subLabel.text = NSLocalizedString("Tap to view image", comment: "Tap to view image")
                    }
                    
                }
            }
            else{
                
                let rightString:String = section3RightArray.object(at: indexPath.row) as! String
                
                if rightString == ""  {
                    cell.subLabel.text = "-"
                }
                else{
                    cell.subLabel.text = rightString
                }
            }
            
            
        }
        
        
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        
        
        
        if (indexPath.section == 3){
            
            
            
            let cell = tableView.cellForRow(at: indexPath) as! CustomTableViewCell
            let dataTypeId = dataTypeArray .object(at: indexPath.row) as! Int
            
            if (dataTypeId == 6 && cell.subLabel.text == NSLocalizedString("Tap to view image", comment: "Tap to view image")){
                if let  descriptionId:String = section3RightArray.object(at: indexPath.row) as? String{
                    
                    detailsView.alpha = 1.0
                    detailsView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
                    detailsView.frame = UIScreen.main.bounds
                    self.view.addSubview(detailsView)
                    
                    
                    let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(gestureRecognizer:)))
                    gestureRecognizer.delegate = self as? UIGestureRecognizerDelegate
                    detailsView.addGestureRecognizer(gestureRecognizer)
                    
                    
                    if(self.storage == "Cloud Storage"){
                        let utilityCompanyId:String = UserDefaults.standard.value(forKey: "utilityCompanyId") as! String
                        let urlString = String(format:"%@%@/file/%@",kUrlBase,utilityCompanyId,descriptionId)
                        ImageLoader.sharedLoader.imageForUrl(urlString: urlString, completionHandler:{(image: UIImage?, url: String) in
                            self.fullScreenImageView.image = image
                            
                        })}
                        
                    else{
                        let image = UIImage(contentsOfFile: descriptionId)
                        let data = UIImageJPEGRepresentation(image!, 0.5)
                        self.fullScreenImageView.image = UIImage(data: data!)
                    }
                    
                    
                    
                }
                
                
                
                
                
                self.fullScreenImageView.transform = CGAffineTransform.identity.scaledBy(x: 0.001, y: 0.001)
                UIView.animate(withDuration: 0.3 / 1.5, animations: {    self.fullScreenImageView.transform = CGAffineTransform.identity.scaledBy(x: 1.1, y: 1.1)
                    
                }, completion: {(finished: Bool) in    UIView.animate(withDuration: 0.3 / 2, animations: {   self.fullScreenImageView.transform = CGAffineTransform.identity.scaledBy(x: 0.9, y: 0.9)
                    
                }, completion: {(finished: Bool) in  UIView.animate(withDuration: 0.3 / 2, animations: {            self.fullScreenImageView.transform = CGAffineTransform.identity
                    
                })
                    
                })
                    
                })
                
                
            }
            
        }
        
        
    }
    
    
    
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool
    {
        
        if (touch.view!.isDescendant(of: self.view)){
            return false
        }
        return true
    }
    
    func handleTap(gestureRecognizer: UIGestureRecognizer) {
        
        UIView.animate(withDuration: 0.5, delay: 0.2, options: .curveEaseOut,
                       animations: {self.detailsView.alpha = 0},
                       completion: { _ in   self.detailsView.removeFromSuperview()
        })
        
    }
    
    
    
    
    
    
}

