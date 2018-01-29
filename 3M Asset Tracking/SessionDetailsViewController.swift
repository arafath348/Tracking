//
//  SessionDetailsViewController.swift
//  AirconsoleSwift
//
//  Created by Daniel Hope on 01/12/2015.
//  Copyright © 2015 Cloudstore. All rights reserved.
//

import UIKit

class SessionDetailsViewController: UITableViewController, AirconsoleSessionDelegate,CLLocationManagerDelegate {
    @IBOutlet var statusLabel:UITextField?
    @IBOutlet var connectDisconnectLabel:UITextField?
    var rfidBytesArray : [UInt8] = []
    @IBOutlet var submitLabel:UILabel!
    
    
    var session:AirconsoleSession?
    var responseArray = [UInt8]()
    var success: Bool = true
    let database = DatabaseHandler()
    let recordTypeID:String = "1"
    var tblLogData: [String : Any] = [:]
    var rfidTemplateTypeId: String = "1"
    var dataCollectionTemplateTypeId: String = "2"
    var dataLabelArray = NSArray()
    var dataDescriptionArray = NSArray()
    var fromScreen: String = ""
    var dummyArray = [UInt8]()
    
    
    
    var LocatorRecordCapture:LocatorRecordCaptureViewController?
    var storage:String = ""
    let timestampFormatter = DateFormatter()
    var locationManager = CLLocationManager()
    let task = DispatchWorkItem {
        hideActivityIndicator()
        showAlert(NSLocalizedString("", comment: ""), message: NSLocalizedString("Request Timeout", comment: "Request Timeout"))
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        //TealiumHelper.trackView(NSStringFromClass(self.classForCoder), dataSources: [:])
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        self.session?.setLineParameters(Int32("4800")!, dataBits: self.session!.dataBits, parity: self.session!.parity, stopBits: self.session!.stopBits)
        
        
        
        storage = database.getSettings(columnName: "Storage")
        
        self.session?.delegate = self
        updateSessionDetails()
        
        
        if(fromScreen == "Locator Record Capture"){
            submitLabel.text = NSLocalizedString("Locator Record Capture", comment: "Locator Record Capture")
        }
        else{
            
            timestampFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
            timestampFormatter.dateFormat = "HHmmss.SSS"
            
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.distanceFilter = 200
            locationManager.requestWhenInUseAuthorization()
            
            
            
        }
        
        
    }
    
    func updateSessionDetails() {
        if (self.session!.connected || self.session!.connecting) {
            connectDisconnectLabel?.text = NSLocalizedString("Disconnect", comment: "Disconnect");
            if (self.session!.connected) {
                statusLabel?.text = NSLocalizedString("Connected", comment: "Connected");
            } else {
                statusLabel?.text = NSLocalizedString("Connecting", comment: "Connecting");
            }
        } else {
            connectDisconnectLabel?.text = NSLocalizedString("Connect", comment: "Connect");
            statusLabel?.text = NSLocalizedString("Disconnected", comment: "Disconnected");
        }
        
    }
    
    func sessionWillConnect(_ session: Any!) {
        updateSessionDetails()
    }
    func sessionDidConnect(_ session: Any!) {
        updateSessionDetails()
    }
    
    func sessionFailed(toConnect session: Any!, errorMessage: String!) {
        updateSessionDetails()
        // TODO: Display a dialog?
    }
    
    func sessionDidDisconnect(_ session: Any!) {
        updateSessionDetails()
    }
    
    func sessionBytesAvailable(_ session: Any!, count: UInt) {
        updateSessionDetails()
        
        if(fromScreen == "Locator Record Capture"){
            if (LocatorRecordCapture != nil) {
                LocatorRecordCapture!.readBytesAvailable(count)
            }
        }
        else{
            
            self.readBytesAvailable(count)
        }
    }
    
    func sessionDidOverflow(_ session: Any!) {
        updateSessionDetails()
    }
    
    func sessionLinePropertiesChanged(_ session: Any!) {
        updateSessionDetails()
    }
    
    func sessionModemStatusChanged(_ session: Any!) {
        updateSessionDetails()
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "LocatorRecordCaptureViewController") {
            LocatorRecordCapture = segue.destination as? LocatorRecordCaptureViewController
            LocatorRecordCapture?.session = session
        }
        
    }
    
    
    override func shouldPerformSegue(withIdentifier identifier: String?, sender: Any?) -> Bool {
        
        if (self.session!.connected){
            if(fromScreen == "Locator Record Capture"){
                return true
            }
            else{
                //                self.sendLocation()
                showActivityIndicator(false)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 120, execute: task)
                session?.write(self.rfidBytesArray, length: UInt(self.rfidBytesArray.count))
            }
        }
        else{
            showAlert(NSLocalizedString("Bluetooth not connected", comment: "Bluetooth not connected"), message: NSLocalizedString("Please connect bluetooth with any device and try again", comment: "Please connect bluetooth with any device and try again"))
        }
        
        return false
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        if (indexPath.section == 0 && indexPath.row == 1) {
            // they have tapped the connect / disconnect cell
            if (self.session!.connected || self.session!.connecting) {
                self.session!.disconnect()
            } else {
                self.session!.connect()
            }
            updateSessionDetails()
        }
        
    }
    
    
    
    func readBytesAvailable(_ count: UInt) {
        
        
        let buffer:UnsafeMutablePointer<UInt8> = UnsafeMutablePointer<UInt8>.allocate(capacity: 1024)
        let bytesRead:UInt = session!.read(buffer, bufferLength: 1024)
        
        if (bytesRead > 0) {
            
            if(buffer[0] == 213 && buffer[1] == 2){
                print(buffer[2])
                if buffer[2] == 1 {
                    success = true
                }
                else if(buffer[2] == 18 || buffer[2] == 19 || buffer[2] == 20 || buffer[2] == 21 || buffer[2] == 22){
                    success = false
                }
                else
                {
                    // Error Message
                    success = false
                    hideActivityIndicator()
                    self.task.cancel()
                    
                    if(buffer[2] == 2){
                        showAlert(NSLocalizedString("Verification failed", comment: "Verification failed"), message: NSLocalizedString("Please try again", comment: "Please try again"))
                    }
                    else if(buffer[2] == 3){
                        showAlert(NSLocalizedString("Lock failed", comment: "Lock failed"), message: NSLocalizedString("Please try again", comment: "Please try again"))
                    }
                    else if(buffer[2] == 4){
                        showAlert(NSLocalizedString("More than one marker detected", comment: "More than one marker detected"), message: NSLocalizedString("Please try again", comment: "Please try again"))
                    }
                    else if(buffer[2] == 5){
                        showAlert(NSLocalizedString("CRC Failure", comment: "CRC Failure"), message: NSLocalizedString("Please try again", comment: "Please try again"))
                    }
                    else if(buffer[2] == 6){
                        showAlert(NSLocalizedString("Incomplete Data", comment: "Incomplete Data"), message: NSLocalizedString("Please try again", comment: "Please try again"))
                    }
                    else if(buffer[2] == 7){
                        showAlert(NSLocalizedString("No iD Marker Found", comment: "No iD Marker Found"), message: NSLocalizedString("Please try again", comment: "Please try again"))
                    }
                    else if(buffer[2] == 8){
                        showAlert(NSLocalizedString("Error in reading marker", comment: "Error in reading marker"), message: NSLocalizedString("Please try again", comment: "Please try again"))
                    }
                    else if(buffer[2] == 9){
                        showAlert(NSLocalizedString("Incompatible marker", comment: "Incompatible marker"), message: NSLocalizedString("Please try again", comment: "Please try again"))
                    }
                    else if(buffer[2] == 16){
                        showAlert(NSLocalizedString("User Data Locked", comment: "User Data Locked"), message: NSLocalizedString("User data is locked on the marker. Cannot program this marker. Please place another marker to program and try again", comment: "User data is locked on the marker. Cannot program this marker. Please place another marker to program and try again"))
                    }
                    else if(buffer[2] == 17){
                        showAlert(NSLocalizedString("Template language mismatch", comment: "Template language mismatch"), message: NSLocalizedString("Please try again", comment: "Please try again"))
                    }
                    else {
                        showAlert(NSLocalizedString("Something went wrong", comment: "Something went wrong"), message: NSLocalizedString("Please try again", comment: "Please try again"))
                    }
                }
                
                if(buffer[2] != 22){
                    responseArray = []
                }
            }
            
            if(success){
                
            }
        }
        
        buffer.deinitialize()
        buffer.deallocate(capacity: 1024)
        
        
        
        let count:Int = responseArray.count
        if(success && count > 8 && responseArray[0] == 213 && responseArray[1] == 2 && responseArray[2] == 1 && responseArray[count-2] == 213 && responseArray[count-1] == 3){
            self.sendToLocalDB()
        }
        
    }
    
    
    
    
    
    
    func sendToLocalDB(){
        let rfidLabelArray: NSMutableArray = []
        let rfidDescArray: NSMutableArray = []
        
        var string: String? = ""
        
        for i in 4 ..< responseArray.count - 4{
            
            if (responseArray[i] == 31){
                rfidLabelArray.add(string!)
                string = ""
            }
            else if (responseArray[i] == 30){
                rfidDescArray.add(string!)
                string = ""
            }
            else
            {
                let charcter = String(describing: UnicodeScalar(UInt8(responseArray[i])))
                string! += charcter
            }
            print(string!)
            
        }
        print(rfidLabelArray)
        print(rfidDescArray)
        
        
        
        self.insrtlogDataToLocalDB()
        self .insrtLogDataDetailsToLocalDB(labelArray: rfidLabelArray, descriptonArray: rfidDescArray, TemplateTypeId: rfidTemplateTypeId)
        
        self .insrtLogDataDetailsToLocalDB(labelArray: dataLabelArray, descriptonArray: dataDescriptionArray, TemplateTypeId: dataCollectionTemplateTypeId)
        
        
        
        let  canStoreDataToCloud:String = database.getUserProfile(columnName: "canStoreDataToCloud")
        let utilityCompanyVerifiedState:String = database.getUtilityCompany(columnName: "verified")
        
        if canStoreDataToCloud != "Y" || utilityCompanyVerifiedState != "Y"{
            
            let alert = UIAlertController(title: "", message: NSLocalizedString("Limited functionality - Data stored locally. Cloud data access is not setup. Click here to contact 3M sales representative", comment: "Limited functionality - Cloud data access is not setup. Click here to contact 3M sales representative"), preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title:NSLocalizedString("Ok", comment: "Ok") , style: .default, handler: { (action: UIAlertAction!) in
                let viewController = UIStoryboard(name: "Custom", bundle: nil).instantiateViewController(withIdentifier: "WebViewViewController") as! WebViewViewController
                viewController.urlString = "https://www.3m.com/3M/en_US/company-us/all-3m-products/~/All-3M-Products/Locating-Marking/Path-Marking/?N=5002385+8710662+8711017+8731984+3294857497&rt=r3&utm_source=app&utm_medium=asset_mgt"
                self.navigationController!.pushViewController(viewController, animated: true)                }))
            self.present(alert, animated: true, completion: nil)
            
        }
        else
        {
            // Check cloud storage access available
            
            if self.storage != "Cloud Storage"{
                self.successMessage(Message: "Data stored locally.")
            }
            else if !isConnectedToNetwork(){
                self.successMessage(Message: "No internet connection. So your data stored locally.")
            }
            else{
                self.sendToCloud()
            }
        }
    }
    
    
    
    
    func sendToCloud(){
        
        
        
        let imagePathDetailsArray: NSArray = database .getimagePathDetails(recordTypeId: "2")
        let imagePathArray:NSArray = imagePathDetailsArray .object(at: 0) as! NSArray
        let logDataDetailIDArray:NSArray = imagePathDetailsArray .object(at: 1) as! NSArray
        
        if imagePathArray.count != 0 {
            self .imageAPICall(imagePathArray: imagePathArray, logDataDetailIDArray: logDataDetailIDArray, index: 0)
        }
        else
        {
            self .performSyncApptoCloud()
        }
    }
    
    
    
    func insrtlogDataToLocalDB()
    {
        self.database .insertLogData(array: [tblLogData])
    }
    
    
    func insrtLogDataDetailsToLocalDB(labelArray:NSArray, descriptonArray:NSArray, TemplateTypeId:String){
        
        
        
        let logDataId:String = self.database.getLogData() .object(at: 0) as! String
        let createdDate:String = self.database.getLogData() .object(at: 1) as! String
        
        print(logDataId)
        print(createdDate)
        
        
        var tblLogDataDetails = [[String: Any]]()
        
        
        for i in 0 ..< labelArray.count {
            
            
            let labelString:String = labelArray .object(at: i) as! String
            var descriptionString:String = descriptonArray .object(at: i) as! String
            
            
            var imagePath:String = ""
            
            
            var tempDetails:[String : Any]
            let lblArray:NSArray = database .getPredefinedLabel(LabelName: labelString)
            
            
            
            
            if(String(descriptionString.characters.prefix(6)) == "~img~_"){
                imagePath = descriptionString
                descriptionString = "Image"
            }
            
            
            
            if  lblArray.count != 0 {
                let labelId:String = lblArray .object(at: 0) as! String
                let dataTypeId:String = lblArray .object(at: 1) as! String
                let descriptionId:String = database .getDescriptionId(DescriptionName: descriptionString)
                
                
                
                
                if descriptionId == "" {
                    tempDetails = ["logDataId": logDataId,
                                   "label": labelString,
                                   "labelId": labelId,
                                   "description": descriptionString,
                                   "templateTypeId": TemplateTypeId,
                                   "createdDate": createdDate,
                                   "dataTypeId":dataTypeId] as [String : Any]
                }
                else
                {
                    tempDetails = ["logDataId": logDataId,
                                   "label": labelString,
                                   "labelId": labelId,
                                   "templateTypeId": TemplateTypeId,
                                   "descriptionId": descriptionId,
                                   "createdDate": createdDate,
                                   "description": descriptionString,
                                   "dataTypeId":dataTypeId] as [String : Any]
                }
                
            }
            else
            {
                tempDetails = ["logDataId": logDataId,
                               "label": labelString,
                               "description": descriptionString,
                               "createdDate": createdDate,
                               "templateTypeId": TemplateTypeId] as [String : Any]
                
            }
            
            
            if (imagePath != ""){
                tempDetails["imagePath"] = imagePath
            }
            
            
            
            tblLogDataDetails.append(tempDetails)
            
            
            
            
        }
        
        
        print(tblLogDataDetails)
        
        
        if tblLogDataDetails.count != 0{
            database .insertLogDataDetails(array: tblLogDataDetails as NSArray)
        }
        
        
        
    }
    
    
    
    func performSyncApptoCloud()
    {
        
        
        
        var tblLogData = [[String: Any]]()
        tblLogData = database .getTblLogData()
        
        var tblLogDataDetails = [[String: Any]]()
        tblLogDataDetails = database .getTblLogDataDetails()
        
        let utilityCompanyId = UserDefaults.standard.value(forKey: "utilityCompanyId") as! String
        
        
        let params = ["lastSyncTime":"",
                      "utilityCompanyId": utilityCompanyId,
                      "tables":["tblLogData":["records":tblLogData],
                                "tblLogDataDetails":["records":tblLogDataDetails]]] as [String : Any]
        
        print(params)
        
        
        let session = URLSession.shared
        
        let url = String(format:"%@sync-app-to-cloud",kUrlBase)
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
                    self.task.cancel()
                }
                if let data = data {
                    do{
                        
                        
                        let jsonData =  try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary
                        let status =  jsonData?["status"] as! String
                        
                        
                        DispatchQueue.main.async {
                            hideActivityIndicator()
                            self.task.cancel()
                            
                            if(status == "Error"){
                                let data: String = (jsonData as AnyObject).value(forKey: "data") as! String
                                showAlert(kEmptyString, message:data)
                            }
                            else
                            {
                                
                                self.database.deleteLogData()
                                self.successMessage(Message: "Log data added successfully")
                                
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
    
    //image api call
    func imageAPICall(imagePathArray:NSArray, logDataDetailIDArray:NSArray, index:Int){
        
        
        let imagePath:String = imagePathArray .object(at: index) as! String
        let logDataDetailID:String = logDataDetailIDArray .object(at: index) as! String
        
        
        
        let session = URLSession.shared
        
        let utilityCompanyId:String = UserDefaults.standard.value(forKey: "utilityCompanyId") as! String
        
        
        let url = NSURL(string: String(format:"%@%@/file/%@/",kUrlBase,utilityCompanyId,imagePath))
        let request = NSMutableURLRequest(url: url! as URL)
        
        request.httpMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        
        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let path =  String(format:"%@/%@",documentsDirectory,imagePath)
        
        
        let image = UIImage(contentsOfFile: path)
        let data = UIImageJPEGRepresentation(image!, 0.5)
        
        
        
        
        
        do{
            request.httpBody = data! as Data
            let task = session.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) in
                if let response = response {
                    let nsHTTPResponse = response as! HTTPURLResponse
                    let statusCode = nsHTTPResponse.statusCode
                    print ("status code = \(statusCode)")
                }
                
                
                
                if let error = error {
                    print ("\(error)")
                    showAlert(kEmptyString, message: NSLocalizedString("Please check your network availability", comment: "Please check your network availability"))
                    hideActivityIndicator()
                    self.task.cancel()
                }
                if let data = data {
                    do{
                        
                        
                        let jsonData =  try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary
                        
                        
                        let data =  jsonData?["data"] as! NSDictionary
                        
                        
                        print(data)
                        
                        let fileId:NSNumber = data.value(forKey: "fileId") as! NSNumber
                        
                        print(fileId)
                        
                        self.database.updateDescriptionLogDataDetail(description: String(describing: fileId),logDataDetailID:logDataDetailID)
                        
                        
                        
                        if(imagePathArray.count - 1 ==  index){
                            self .performSyncApptoCloud()
                        }
                        else
                        {
                            self .imageAPICall(imagePathArray: imagePathArray, logDataDetailIDArray: logDataDetailIDArray, index: index + 1)
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
    
    
    
    //    func sendLocation(){
    //        if (CLLocationManager.locationServicesEnabled())
    //        {
    //            showActivityIndicator(false)
    //            locationManager.startUpdatingLocation()
    //
    //            let when = DispatchTime.now() + 5
    //            DispatchQueue.main.asyncAfter(deadline: when) {
    //
    //                hideActivityIndicator()
    //                self.locationManager.stopUpdatingLocation()
    //                self.session?.write(self.rfidBytesArray, length: UInt(self.rfidBytesArray.count))
    //            }
    //        }
    //        else
    //        {
    //            hideActivityIndicator()
    //            showAlert(NSLocalizedString("Location Services Disabled", comment: "Location Services Disabled"), message: NSLocalizedString("Please enable location services and try again", comment: "Please enable location services and try again"))
    //        }
    //    }
    
    //    MARK: - CLLocationManagerDelegate Methods
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        locationManager.stopUpdatingLocation()
        let newLocation = locations.last
        
        
        let latitude = convertCLLocationDegreesToNmea(degrees: newLocation!.coordinate.latitude)
        let longitude = convertCLLocationDegreesToNmea(degrees: newLocation!.coordinate.longitude)
        
        // GPGGA
        var nmea0183GPGGA = "GPGGA," + timestampFormatter.string(from: newLocation!.timestamp)
        nmea0183GPGGA += String(format: ",%08.4f,", arguments: [abs(latitude)])
        nmea0183GPGGA += latitude > 0.0 ? "N" : "S"
        nmea0183GPGGA += String(format: ",%08.4f,", arguments: [abs(longitude)])
        nmea0183GPGGA += longitude > 0.0 ? "E" : "W"
        nmea0183GPGGA += ",1,08,1.0,"
        nmea0183GPGGA += String(format: "%1.1f,M,%1.1f,M,,,", arguments: [newLocation!.altitude, newLocation!.altitude])
        nmea0183GPGGA += String(format: "*%02lX", arguments: [nmeaSentenceChecksum(sentence: nmea0183GPGGA)])
        nmea0183GPGGA = "$" + nmea0183GPGGA
        
        
        debugPrint(nmea0183GPGGA)
        print("LOCATION")
        
        
        
        var byesArray = [UInt8]()
        byesArray = Array(nmea0183GPGGA.utf8)
        byesArray += [13, 10]
        
        session?.write(byesArray, length: UInt(byesArray.count))
        
    }
    
    
    
    func convertCLLocationDegreesToNmea(degrees: CLLocationDegrees) -> Double {
        let degreeSign = ((degrees > 0.0) ? 1.0 : ((degrees < 0.0) ? -1.0 : 0));
        let degree = abs(degrees);
        let degreeDecimal = floor(degree);
        let degreeFraction = degree - degreeDecimal;
        let minutes = degreeFraction * 60.0;
        let nmea = degreeSign * (degreeDecimal * 100.0 + minutes);
        return nmea;
    }
    
    func nmeaSentenceChecksum(sentence: String) -> CLong {
        var checksum: unichar = 0;
        var stringUInt16 = [UInt16]()
        stringUInt16 += sentence.utf16
        for char in stringUInt16 {
            checksum ^= char
        }
        checksum &= 0x0ff
        return CLong(checksum)
    }
    func successMessage(Message:String){
        hideActivityIndicator()
        self.task.cancel()
        
        if(session!.connected){
            self.session!.disconnect()
        }
        
        let message = NSLocalizedString(Message, comment: Message)
        let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: "Ok"), style: .default, handler: { (action: UIAlertAction!) in
            let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
            self.navigationController!.popToViewController(viewControllers[viewControllers.count - 4], animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
}


