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
    var responseAllValuesArray = [UInt8]()
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
     let textView = UITextView()
    var serialNo: String? = ""
    var locatorLanguageCode = [UInt8]()

    
    var LocatorRecordCapture:LocatorRecordCaptureViewController?
    var storage:String = ""
    let timestampFormatter = DateFormatter()
    var locationManager = CLLocationManager()
    let task = DispatchWorkItem {
        SVProgressHUD.showInfo(withStatus: NSLocalizedString("Request Timeout", comment: "Request Timeout"))
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        //TealiumHelper.trackView(NSStringFromClass(self.classForCoder), dataSources: [:])
        
        textView.frame = CGRect(x: 10.0, y: self.view.frame.size.height / 2 + 40, width: self.view.frame.size.width - 20, height: self.view.frame.size.height / 2 - 45)
        self.view.addSubview(textView)
        self.view?.superview!.bringSubview(toFront: textView)
        
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
                SVProgressHUD.show(withStatus: "Loading...")
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 120, execute: task)
                
                success = true
                responseAllValuesArray = []
                responseArray = []
                
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
        
       var index:UInt = 0
        while (index < bytesRead) {
            
            let count:Int = responseAllValuesArray.count
            if(count < 3){
                responseAllValuesArray += [buffer[Int(index)]]
            }
            else if(success && responseAllValuesArray[count-3] == 213 && responseAllValuesArray[count-2] == 2){
                
                if(responseAllValuesArray[count-1] == 2){
                     SVProgressHUD.showError(withStatus: NSLocalizedString("Verification failed", comment: "Verification failed"))
                    success = false
                }
                else if(responseAllValuesArray[count-1] == 3){
                    SVProgressHUD.showError(withStatus: NSLocalizedString("Lock failed", comment: "Lock failed"))
                    success = false
                }
                else if(responseAllValuesArray[count-1] == 4){
                     SVProgressHUD.showError(withStatus: NSLocalizedString("More than one marker detected", comment: "More than one marker detected"))
                    success = false
                }
                else if(responseAllValuesArray[count-1] == 5){
                     SVProgressHUD.showError(withStatus: NSLocalizedString("CRC Failure", comment: "CRC Failure"))
                    success = false
                }
                else if(responseAllValuesArray[count-1] == 6){
                     SVProgressHUD.showError(withStatus: NSLocalizedString("Incomplete Data", comment: "Incomplete Data"))
                    success = false
                }
                else if(responseAllValuesArray[count-1] == 7){
                    
                     SVProgressHUD.showError(withStatus: NSLocalizedString("No ID Marker Found", comment: "No ID Marker Found"))
                    success = false
                }
                else if(responseAllValuesArray[count-1] == 8){
                    SVProgressHUD.showError(withStatus: NSLocalizedString("Error in reading marker", comment: "Error in reading marker"))
                    success = false
                    
                }
                else if(responseAllValuesArray[count-1] == 9){
                     SVProgressHUD.showError(withStatus: NSLocalizedString("Incompatible Marker", comment: "Incompatible Marker"))
                     success = false
                }
                else if(responseAllValuesArray[count-1] == 17){
                    SVProgressHUD.showError(withStatus: NSLocalizedString("User data is locked on the marker. Cannot program this marker. Please place another marker to program and press Retry", comment: ""))
                    success = false
                }
                else if(responseAllValuesArray[count-1] == 11){
                    
                    if(buffer[Int(index)] != 213 && buffer[Int(index)] != 3){
                        locatorLanguageCode += [buffer[Int(index)]]
                    }
                    else if(buffer[Int(index)] == 3){
                        let database = DatabaseHandler()

                        let locatorLanguage:String = getLanguageFromCode(languageCode: locatorLanguageCode)
                        let appLanguage:String = database.getLanguageSettings().object(at: 0) as! String
                        let errorMessage:String = NSLocalizedString(String(format:"Template language mismatch. Locator Language is %@ while app language is %@",locatorLanguage,appLanguage), comment: "")
                        SVProgressHUD.showError(withStatus: errorMessage)
                        success = false
                    }
                }
                else if(responseAllValuesArray[count-1] == 12){
                    SVProgressHUD.show(withStatus: NSLocalizedString("Command received...", comment: ""))
                    success = true
                   if(buffer[Int(index)] == 3){
                      responseAllValuesArray = []
                    }
                }
                else if(responseAllValuesArray[count-1] == 18){
                    success = true
                    
                     if(buffer[Int(index)] != 213 && buffer[Int(index)] != 3){
                      let charcter = String(describing: UnicodeScalar(UInt8(buffer[Int(index)])))
                      serialNo! += charcter
                    }
                     else if(buffer[Int(index)] == 3){
                        let serialNumber:String = NSLocalizedString(String(format:"ID marker found (%@). Writing to the marker...",serialNo!), comment: "")
                        SVProgressHUD.show(withStatus: serialNumber)
                        responseAllValuesArray = []
                    }
                
                }
                else if(responseAllValuesArray[count-1] == 14){
                    success = true
                    SVProgressHUD.show(withStatus: NSLocalizedString("Writing to the marker done. Verifying the data", comment: ""))
                    if(buffer[Int(index)] == 3){
                        responseAllValuesArray = []
                    }
                }
                else if(responseAllValuesArray[count-1] == 15){
                    success = true
                    SVProgressHUD.show(withStatus: NSLocalizedString("Verifying the data done", comment: ""))
                    if(buffer[Int(index)] == 3){
                        responseAllValuesArray = []
                    }
                }
                else if(responseAllValuesArray[count-1] == 1){
                    success = true
                    if(buffer[Int(index)] != 213 && buffer[Int(index)] != 3){
                        SVProgressHUD.show(withStatus: NSLocalizedString("Marker write is successful", comment: ""))
                        responseArray += [buffer[Int(index)]]
                    }
                   else if(buffer[Int(index)] == 3){
                     responseAllValuesArray = []
                     self.sendToLocalDB()
                    }
                }
                else if(responseAllValuesArray[count-1] == 16){
                    SVProgressHUD.show(withStatus: NSLocalizedString("Progmkrs command is completed", comment: ""))
                    responseAllValuesArray = []
                }
                else {
                    success = false
                     SVProgressHUD.showError(withStatus: NSLocalizedString("Something went wrong", comment: ""))
                }
            }

            index = index + 1
        }


    }

    buffer.deinitialize()
    buffer.deallocate(capacity: 1024)


    }




    
    
    
    
    
    
    
    
    func sendToLocalDB(){
        let rfidLabelArray: NSMutableArray = []
        let rfidDescArray: NSMutableArray = []
        
        var string: String? = ""
        
        for i in 1 ..< responseArray.count - 1{
            
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
                    SVProgressHUD.showError(withStatus: "\(error)")
                    self.task.cancel()
                }
                if let data = data {
                    do{
                        
                        
                        let jsonData =  try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary
                        let status =  jsonData?["status"] as! String
                        
                        
                        DispatchQueue.main.async {
                            SVProgressHUD.dismiss()
                            self.task.cancel()
                            
                            if(status == "Error"){
                                let data: String = (jsonData as AnyObject).value(forKey: "data") as! String
                                SVProgressHUD.showError(withStatus: data)
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
            
                
                if let error = error {
                    SVProgressHUD.showError(withStatus: "\(error)")
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
        }
        
    }
    
    

    
    //    func sendLocation(){
    //        if (CLLocationManager.locationServicesEnabled())
    //        {
    //            SVProgressHUD.show(withStatus: "Loading...")
    //            locationManager.startUpdatingLocation()
    //
    //            let when = DispatchTime.now() + 5
    //            DispatchQueue.main.asyncAfter(deadline: when) {
    //
    //                SVProgressHUD.dismiss()
    //                self.locationManager.stopUpdatingLocation()
    //                self.session?.write(self.rfidBytesArray, length: UInt(self.rfidBytesArray.count))
    //            }
    //        }
    //        else
    //        {
    //            SVProgressHUD.dismiss()
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
        SVProgressHUD.dismiss()
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


