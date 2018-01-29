//
//  DataLookupViewController.swift
//  3M L&M
//
//  Created by IndianRenters on 14/09/17.
//  Copyright © 2017 3M L&M. All rights reserved.
//

import Foundation
import UIKit


class DataLookupViewController: UIViewController, CLLocationManagerDelegate,GMSMapViewDelegate,UISearchBarDelegate,UIPickerViewDelegate,UIPickerViewDataSource
{
    
    var transView:UIView!
    var actionView:UIView!
    var selectedRow = 0;
    var picker = UIPickerView()
    var typeArray:NSArray = []
    @IBOutlet var typeTextField: UITextField!
    @IBOutlet weak var exportBtn: UIButton!
    var datalookupMapView = GMSMapView()
    @IBOutlet weak var mapView: UIView!
    var userProfileId:String = ""
    var logDataId:Int = 0
    @IBOutlet weak var searchbar: UISearchBar!
    var logDataArray: NSDictionary = [:]
    var allLogDataArray: NSMutableArray = []
    var storage:String = ""
    let database = DatabaseHandler()
    var logDataforApiFormat: [[String : Any]] = []
    var latitude:Double = 0.0
    var longitude:Double = 0.0
    var parameters = [String:Any]()
    var locationManager = CLLocationManager()

    
    override func viewDidAppear(_ animated: Bool) {
        //TealiumHelper.trackView(NSStringFromClass(self.classForCoder), dataSources: [:])
        
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
     self.changeLanguage()
     storage = database.getSettings(columnName: "Storage")

        
        
        if let typeDropDown:String = UserDefaults.standard.value(forKey: "typeDropDown") as? String{
            let searchBarText:String = UserDefaults.standard.value(forKey: "searchBarText") as! String
            typeTextField.text = typeDropDown
            searchbar.text = searchBarText
        }
        
        
        
    }
    func changeLanguage(){
        self.title = NSLocalizedString("Data Lookup", comment: "Data Lookup")
        typeArray = [NSLocalizedString("Project Name", comment: "Project Name"),NSLocalizedString("UPC Code", comment: "UPC Code"),NSLocalizedString("Product Description", comment: "Product Description"),NSLocalizedString("Record Type", comment: "Record Type"),NSLocalizedString("Address", comment: "Address") ]
        exportBtn.setTitle(NSLocalizedString("EXPORT DATA", comment: "EXPORT DATA"), for: UIControlState.normal)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        UserDefaults.standard.set(searchbar.text, forKey:"searchBarText")
        UserDefaults.standard.set(typeTextField.text, forKey:"typeDropDown")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.changeLanguage()

        
        
        //        searchbar.text = "Image Test"
        
        typeArray = [NSLocalizedString("Project Name", comment: "Project Name"),NSLocalizedString("UPC Code", comment: "UPC Code"),NSLocalizedString("Product Description", comment: "Product Description"),NSLocalizedString("Record Type", comment: "Record Type"),NSLocalizedString("Address", comment: "Address") ]
        typeTextField.text = typeArray[0] as? String
        userProfileId = UserDefaults.standard.value(forKey: "userProfileId") as! String
        
        
        
        let camera = GMSCameraPosition.camera(withLatitude: 0, longitude: 0, zoom: 10)
        
        datalookupMapView = GMSMapView.map(withFrame:  CGRect(x: 0, y: 0, width: self.view.frame.size.width - 20, height: self.view.frame.size.height - 230), camera: camera)
        datalookupMapView.camera = camera
        datalookupMapView.mapType = kGMSTypeHybrid
        datalookupMapView.delegate = self
        self.mapView .addSubview(datalookupMapView)
        
        self.determineMyCurrentLocation()
        
        
    }
    
    
    
    
    
    
    
    
    @IBAction func typeButtonClicked() {
        
        searchbar.resignFirstResponder()
        
        
        actionSheet()
        
        picker = UIPickerView(frame: CGRect(x: 0, y: 44, width: self.view.frame.size.width, height: 216))
        picker.showsSelectionIndicator = true
        picker.delegate = self
        picker.reloadAllComponents()
        
        
        
        let isTheObjectThere: Bool = self.typeArray.contains(self.typeTextField.text!)
        if isTheObjectThere == true {
            let indexValue: Int = self.typeArray.index(of: self.typeTextField.text!)
            picker.selectRow(indexValue, inComponent: 0, animated: true)
            selectedRow = indexValue
        }
        else {
            picker.selectRow(0, inComponent: 0, animated: true)
            self.typeTextField.text = self.typeArray[0] as? String
            selectedRow = 0
        }
        self.actionView.addSubview(picker)
    }
    
    
    
    func actionSheet() {
        
        let pickerToolbar = UIToolbar()
        pickerToolbar.tintColor = UIColor.white
        pickerToolbar.isTranslucent = false
        pickerToolbar.barTintColor=UIColor(red: 133/255.0, green:185.0/255.0, blue: 51.0/255.0, alpha: 1.0)
        pickerToolbar.sizeToFit()
        
        
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.donePicker))
        pickerToolbar.setItems([flexSpace, doneButton], animated: true)
        
        
        
        
        transView = UIView(frame: UIScreen.main.bounds)
        transView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.view.addSubview(transView)
        
        
        
        //        let height: CGFloat = self.view.bounds.height
        
        actionView = UIView(frame: CGRect(x: 0, y: -256, width: self.view.frame.size.width, height: 256))
        actionView.backgroundColor=(UIColor .white)
        actionView.addSubview(pickerToolbar)
        
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options:  UIViewAnimationOptions.curveEaseInOut, animations:
            {
                self.actionView.frame = CGRect(x: 0, y: 55, width: self.view.frame.size.width, height: 256)
                
        }, completion: {(finished: Bool) in
        })
        
        
        self.view.addSubview(actionView)
        
        
    }
    
    
    
    
    
    
    func donePicker() {
        
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseInOut
            , animations:
            {
                self.actionView.frame = CGRect(x: 0, y: -256, width: self.view.frame.size.width, height: 256)
                
        }, completion: {(finished: Bool) in    if finished {
            self.actionView.removeFromSuperview()
            }
            self.transView.removeFromSuperview()
            
        })
        
    }
    
    
    
    
    
    
    
    
    public func numberOfComponents(in pickerView:  UIPickerView) -> Int  {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return typeArray.count
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let pickerLabel = UILabel(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 30))
        pickerLabel.textAlignment = .center
        pickerLabel.backgroundColor = UIColor.clear
        pickerLabel.font = UIFont(name: "3MCircularTT-Book", size: 14)
        pickerLabel.text =  typeArray.object(at: row) as? String
        
        
        return pickerLabel
        
    }
    
    
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedRow = row;
        typeTextField.text = typeArray .object(at: row) as? String
    }
    
    
    
    
    
    func convertAddressToLatLong(){
        showActivityIndicator(false)
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(searchbar.text!) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
                else {
                    // handle no location found
                    hideActivityIndicator()
                    showAlert("", message: NSLocalizedString("No location found", comment: "No location found"))
                    
                    return
            }
            self.latitude = location.coordinate.latitude
            self.longitude = location.coordinate.longitude
            
            hideActivityIndicator()
            print(location.coordinate.latitude)
            print(location.coordinate.longitude)
            
            if(self.storage == "Cloud Storage"){
             self.searchAPICall()
            }
            else{
                (self.allLogDataArray, self.logDataforApiFormat) = self.database.getTblLogData(searchText: "", searchType: NSLocalizedString("Address", comment: "Address"), latitude: self.latitude, longitude: self.longitude)
                if self.allLogDataArray.count == 0 {
                    self.datalookupMapView.clear()
                    showAlert("", message: NSLocalizedString("No results found", comment: "No results found"))
                }
                else{
                    self.loadMapView()
                }
                
            }
            
            
            
        }
    }
    
    //Searchbar delegates
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        
        searchBar.resignFirstResponder()
        print(storage)
        
        
        if(self.storage == "Cloud Storage"){
            if(typeTextField.text! == NSLocalizedString("Address", comment: "Address")){
                self.convertAddressToLatLong()
            }
            else{
                self.searchAPICall()
            }
        }
        else{
            
            
            
            if(typeTextField.text! == NSLocalizedString("Address", comment: "Address")){
                self.convertAddressToLatLong()
            }
            else{
                (allLogDataArray, logDataforApiFormat) = database.getTblLogData(searchText: searchBar.text!, searchType: typeTextField.text!, latitude: 0, longitude: 0)
                
                if allLogDataArray.count == 0 {
                    datalookupMapView.clear()
                    showAlert("", message: NSLocalizedString("No results found", comment: "No results found"))
                }
                else{
                    self.loadMapView()
                }
                
            }
        }
        
    }
    
    
    
    
    //SearchAPI call
    func searchAPICall()
    {
        
        
        showActivityIndicator(false)
        
        let session = URLSession.shared
 
        
        let url = String(format:"%@data-look-up",kUrlBase)
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        request.httpMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        
        var searchType:String = ""
        if(typeTextField.text! == NSLocalizedString("Project Name", comment: "Project Name")){
            searchType = "projectName"
        }
        else if(typeTextField.text! == NSLocalizedString("UPC Code", comment: "UPC Code")){
            searchType = "UPCCode"
        }
        else if(typeTextField.text! == NSLocalizedString("Product Description", comment: "Product Description")){
            searchType = "productDesc"
        }
        else if(typeTextField.text! == NSLocalizedString("Record Type", comment: "Record Type")){
            searchType = "recordTypeDesc"
        }
        
        
        
        parameters = ["userProfileId": userProfileId,
                      "searchKey": searchbar.text!,
                      "searchType":searchType] as [String : Any]
        
        
        if(typeTextField.text! == NSLocalizedString("Address", comment: "Address")){
            
            parameters = ["userProfileId": userProfileId,
                          "latitude" : latitude,
                          "longitude" : longitude,
                          "searchType":"location"] as [String : Any]
        }
        
        
        
        
        print(parameters)
        
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions())
            let task = session.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) in
                if let response = response {
                    let nsHTTPResponse = response as! HTTPURLResponse
                    let statusCode = nsHTTPResponse.statusCode
                    print ("status code = \(statusCode)")
                }
                
                
                
                if let error = error {
                    print ("\(error)")
                    showAlert(kEmptyString, message: "\(error)")
                    hideActivityIndicator()
                }
                if let data = data {
                    do{
                        
                        let jsonData =  try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary
                        
                        let status: String = (jsonData as AnyObject).value(forKey: "status") as! String

                        print(jsonData)
                        
                        DispatchQueue.main.async {

                            hideActivityIndicator()

                            if(status == "InValid" || status == "Error"){
                            let data: String = (jsonData as AnyObject).value(forKey: "data") as! String
                            showAlert(kEmptyString, message:data)
                        }
                        else
                        {
                        
                        let data =  jsonData!["data"] as! NSDictionary
                        
                        print(data)
                        if(data.count == 0){
                            self.allLogDataArray = []
                            showAlert("", message: NSLocalizedString("No results found", comment: "No results found"))
                            
                                self.datalookupMapView.clear()
                        }
                        else{
                            
                            self.allLogDataArray =  data["logData"] as! NSMutableArray
                                self.loadMapView()
                        }
                    }
                }
                        
                    }catch _ {
                    }
                    
                }
            })
            task.resume()
        }catch _ {
            print ("Oops something went wrong")
        }
    }
    
    
    
    
    func loadMapView(){
        
        
        
        
        
        
        
        datalookupMapView.clear()
        
        let path = GMSMutablePath()
        
        
        
        
        datalookupMapView.clear()
        
        
        
        for i in 0 ..< allLogDataArray.count {
            
            var  latitude:Double = 0
            var  longtitude:Double = 0
            
            
            
            
            if let value = (allLogDataArray.value(forKey: "latitude") as AnyObject).object(at: i) as? String{
                latitude = Double(value)!
            }
            if let value = (allLogDataArray.value(forKey: "longtitude") as AnyObject).object(at: i) as? String{
                longtitude = Double(value)!
            }
            
            
            
            let lookupMarker = GMSMarker()
            
            lookupMarker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)
            lookupMarker.title = ""
            lookupMarker.opacity = 1.0
            lookupMarker.map = datalookupMapView
            
            lookupMarker.icon = GMSMarker.markerImage(with: UIColor(red: 133/255.0, green:185.0/255.0, blue: 51.0/255.0, alpha: 1.0))
            
            lookupMarker.userData = (allLogDataArray.value(forKey: "logDataId") as AnyObject).object(at: i) as! Int
            
            print(lookupMarker.userData)
            
            path.add(lookupMarker.position)
        }
        let bounds = GMSCoordinateBounds(path: path)
        self.datalookupMapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 30.0))
        
        
    }
    
    
    
    func mapView(_ mapView: GMSMapView!, didTap marker: GMSMarker!) -> Bool {
        
        print(marker.userData)
        
        searchbar.resignFirstResponder()
        logDataId = marker.userData as! Int
        
        print(logDataId)
        
        
        
        let index = (allLogDataArray.value(forKey: "logDataId") as AnyObject).index(of: logDataId)
        logDataArray = allLogDataArray.object(at: index) as! NSDictionary
        
        
        if(self.storage == "Cloud Storage"){
            self.logDataDetailAPICall()
        }
        else{
            let viewController = self.storyboard!.instantiateViewController(withIdentifier: "DataDetailLookupViewController") as! DataDetailLookupViewController
            viewController.storage = storage
            viewController.logDataArray = logDataArray
            viewController.logDataDetailsArray = database.getTblLogDataDetails(logDataId: logDataId)
            self.navigationController!.pushViewController(viewController, animated: true)
            
        }
        
        
        
        return true
    }
    
    
    func logDataDetailAPICall()
    {
        
        searchbar.resignFirstResponder()
        
        showActivityIndicator(false)
        
        let session = URLSession.shared
        
        let url = String(format:"%@data-look-up-details",kUrlBase)
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        request.httpMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        
        
        
        let params = ["logDataId": logDataId,
                      "userProfileId":userProfileId] as [String : Any]
        
        print(params)
        
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions())
            let task = session.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) in
                if let response = response {
                    let nsHTTPResponse = response as! HTTPURLResponse
                    let statusCode = nsHTTPResponse.statusCode
                    print ("status code = \(statusCode)")
                }
                
                
                
                if let error = error {
                    print ("\(error)")
                    showAlert(kEmptyString, message: "\(error)")
                    hideActivityIndicator()
                }
                if let data = data {
                    do{
                        
                        let jsonData =  try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary
                        
                        
                        let data =  jsonData!["data"] as! NSDictionary
                        hideActivityIndicator()
                        
                        DispatchQueue.main.async {
                            
                            let viewController = self.storyboard!.instantiateViewController(withIdentifier: "DataDetailLookupViewController") as! DataDetailLookupViewController
                            viewController.logDataArray = self.logDataArray
                            viewController.storage = self.storage
                            
                            
                            if(data.count != 0){
                                
                                let logDataDetailsArray =  data["logDataDetails"] as! NSArray
                                viewController.logDataDetailsArray = logDataDetailsArray
                                
                                
                            }
                            self.navigationController!.pushViewController(viewController, animated: true)
                        }
                        
                        
                    }catch _ {
                    }
                    
                }
            })
            task.resume()
        }catch _ {
            print ("Oops something went wrong")
        }
    }
    
    
    
    @IBAction func exportClicked() {
        
        
        if(self.storage == "Cloud Storage"){

            if(allLogDataArray.count == 0){
                showAlert("", message: NSLocalizedString("No records found", comment: "No records found"))
            }
            else{
                self.onlineExportAPICall()
            }
        }
        else{
            
            if(logDataforApiFormat.count == 0){
                showAlert("", message: NSLocalizedString("No records found", comment: "No records found"))
            }
            else{
                self.offlineExportAPICall()
            }
        }
        
        
    }
    
    
    
    func offlineExportAPICall(){
        showActivityIndicator(false)
        
        
        
        print(logDataforApiFormat)
        
        var imageArray = NSArray()
        var logDataDetailsApiFormat = [[String: Any]]()
        (imageArray, logDataDetailsApiFormat) = self.database.exportLogDataDetails(logData: logDataforApiFormat)
        
        
        
        
        print(imageArray)
        
        let utilityCompanyId:String = UserDefaults.standard.value(forKey: "utilityCompanyId") as! String
        
        let params = ["lastSyncTime":"",
                      "utilityCompanyId": utilityCompanyId,
                      "tables":["tblLogData":["records":logDataforApiFormat],
                                "tblLogDataDetails":["records":logDataDetailsApiFormat]]] as [String : Any]
        
        print(params)
        
        
        let session = URLSession.shared
        
        
        let url = String(format:"%@export-data-look-up-offline",kUrlBase)
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        
        
        request.httpMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions())
            let task = session.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) in
                if let response = response {
                    let nsHTTPResponse = response as! HTTPURLResponse
                    let statusCode = nsHTTPResponse.statusCode
                    print ("status code = \(statusCode)")
                }
                
                
                
                if let error = error {
                    print ("\(error)")
                    showAlert(kEmptyString, message: "\(error)")
                    hideActivityIndicator()
                }
                if let data = data {
                    do{
                        
                        
                        
                        print(data)
                        
                        
                        
                        
                        
                        
                        let documentsPathURL = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
                        let documentsPath = documentsPathURL.path!
                        
                        
                        let currentDateTime = Date()
                        let formatter = DateFormatter()
                        formatter.timeZone = NSTimeZone.default
                        
                        formatter.dateFormat = "dd-MM-yyyy_HH-mm-ss"
                        
                        
                        let userName:String = UserDefaults.standard.value(forKey: "userName") as! String
                        
                        let folderName = String(format:"%@_%@",userName,(formatter.string(from: currentDateTime)))
                        
                        print(folderName)
                        
                        
                        let ExportdataPath = documentsPathURL.appendingPathComponent(folderName)
                        print(ExportdataPath!)
                        do {
                            try FileManager.default.createDirectory(atPath: ExportdataPath!.path, withIntermediateDirectories: true, attributes: nil)
                        } catch let error as NSError {
                            NSLog("Unable to create directory \(error.debugDescription)")
                        }
                        
                        
                        let fileURL = ExportdataPath?.appendingPathComponent("search.kml")
                        try data.write(to: fileURL!)
                        
                        
                        
                        do {
                            
                            for filePath in imageArray{
                                let sourcePath:String = String(format:"%@/%@",documentsPath,filePath as! CVarArg)
                                print(sourcePath)
                                let exportDataPath = documentsPathURL.appendingPathComponent(String(format:"%@/%@",folderName,filePath as! CVarArg))
                                let destinationPath = exportDataPath!.path
                                print(destinationPath)
                                
                                try FileManager.default.moveItem(atPath: sourcePath, toPath: destinationPath)
                            }
                        }
                        catch let error as NSError {
                            print("Ooops! Something went wrong: \(error)")
                        }
                        
                        

                        
                        
                        let fileShare:String = String(format:"To get your data:\n 1. Connect your iOS device to your computer.\n 2. In iTunes, select your iOS device and then click the File Sharing tab.\n 3. Select \"3M Asset Tracking\" from the list.\n 4. Select %@.\n 5. Now click \"Save to\".",folderName)
                        
                        
                         showAlert(NSLocalizedString("Your data exported successfully", comment: "Your data exported successfully"), message: NSLocalizedString(fileShare, comment: fileShare))
                  
                        self.database.deleteLogData(logData: logDataDetailsApiFormat)
                        
                        hideActivityIndicator()
                        
                        
                    }catch _ {
                    }
                }
            })
            task.resume()
        }catch _ {
            print ("Oops something went wrong")
        }
        
        
        
    }
    
    
    
    
    
    //Export Online API call
    func onlineExportAPICall()
    {
        
        
        showActivityIndicator(false)
        
        let session = URLSession.shared
        
        let url = String(format:"%@export-data-look-up-kmz",kUrlBase)
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        
        request.httpMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        
        
        print(parameters)
        
        var searchType:String = ""
        if(typeTextField.text! == NSLocalizedString("Project Name", comment: "Project Name")){
            searchType = "projectName"
        }
        else if(typeTextField.text! == NSLocalizedString("UPC Code", comment: "UPC Code")){
            searchType = "UPCCode"
        }
        else if(typeTextField.text! == NSLocalizedString("Product Description", comment: "Product Description")){
            searchType = "productDesc"
        }
        else if(typeTextField.text! == NSLocalizedString("Record Type", comment: "Record Type")){
            searchType = "recordTypeDesc"
        }
        
        
        
        parameters = ["userProfileId": userProfileId,
                      "searchKey": searchbar.text!,
                      "searchType":searchType] as [String : Any]
        
        
        if(typeTextField.text! == NSLocalizedString("Address", comment: "Address")){
            
            parameters = ["userProfileId": userProfileId,
                          "latitude" : latitude,
                          "longitude" : longitude,
                          "searchType":"location"] as [String : Any]
        }
        
        
        
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions())
            let task = session.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) in
                if let response = response {
                    let nsHTTPResponse = response as! HTTPURLResponse
                    let statusCode = nsHTTPResponse.statusCode
                    print ("status code = \(statusCode)")
                }
                
                
                
                if let error = error {
                    print ("\(error)")
                    showAlert(kEmptyString, message: "\(error)")
                    hideActivityIndicator()
                }
                if let data = data {
                    do{
                        
                        let jsonData =  try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary
                        
                        hideActivityIndicator()
                        
                        print(jsonData)
                        
                        let data =  jsonData!["data"] as! String
                        print(data)
                        
                        hideActivityIndicator()
                        
                        if(data == "true"){
                            showAlert("", message: NSLocalizedString("Search details will be sent to your registered email id", comment: "Search details will be sent to your registered email id"))
                            
                        }
                        else{
                            showAlert("", message: NSLocalizedString("No records found", comment: "No records found"))
                        }
                        
                        
                    }catch _ {
                    }
                    
                }
            })
            task.resume()
        }catch _ {
            print ("Oops something went wrong")
        }
    }
    
    
    func determineMyCurrentLocation() {
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        
        // A minimum distance a device must move before update event generated
        locationManager.distanceFilter = 500
        
        // Request permission to use location service
        locationManager.requestWhenInUseAuthorization()
        
        // Request permission to use location service when the app is run
        locationManager.requestWhenInUseAuthorization()
        
        // Start getting update of user's location
        locationManager.startUpdatingLocation()
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
        
        locationManager.stopUpdatingLocation()
        
        
        let camera = GMSCameraPosition.camera(withLatitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude, zoom: 10)
        self.datalookupMapView = GMSMapView.map(withFrame:  CGRect(x: 0, y: 0, width: self.view.frame.size.width - 20, height: self.view.frame.size.height - 166), camera: camera)
        self.datalookupMapView.camera = camera
        self.datalookupMapView.mapType = kGMSTypeHybrid
        self.datalookupMapView.delegate = self
        self.mapView .addSubview(self.datalookupMapView)
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
    
    
    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    
    
}






