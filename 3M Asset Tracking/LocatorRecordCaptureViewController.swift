//
//  LocatorRecordCaptureViewController.swift
//  3M Asset Tracking
//
//  Created by IndianRenters on 25/10/17.
//  Copyright © 2017 IndianRenters. All rights reserved.
//

import UIKit

class LocatorRecordCaptureViewController: UIViewController , CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource,UITextViewDelegate
{
    
    @IBOutlet weak var cancelOutBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    var locationManager = CLLocationManager()
    weak var delegate: LocationDelegate?
    let timestampFormatter = DateFormatter()
    var timer = Timer()
    var session:AirconsoleSession?
    var responseArray = [UInt8]()
    var labelArray: NSMutableArray = []
    var descriptionArray: NSMutableArray = []
    @IBOutlet var logPointDescTextView:UITextView!
    @IBOutlet var table:UITableView!
    @IBOutlet var sendingLocationView:UIView!
    let backButton = UIButton(type: .custom)
    var recordTypeId:String = ""
    var utilityCompanyId:String = ""
    let database = DatabaseHandler()
    var projectName:String = ""
    var projectId:String = ""
    var storage:String = ""
    var carriageReturnArray = NSMutableArray()
    var commaArray = NSMutableArray()
    var totalRows: Int = 0
    var totalRowSting:String = ""


    
    //    MARK: - View Life Cycle Methods
    
    override func viewWillAppear(_ animated: Bool) {
        self.changeLanguage()
    }
    func changeLanguage(){
        self.title = NSLocalizedString("Locator Record Capture", comment: "Locator Record Capture")
        saveBtn.setAttributedTitle(nil, for:  UIControlState.normal)
        cancelBtn.setAttributedTitle(nil, for:  UIControlState.normal)
        cancelOutBtn.setAttributedTitle(nil, for:  UIControlState.normal)
        cancelOutBtn.setTitle(NSLocalizedString("CANCEL", comment: "verify"), for: UIControlState.normal)
        cancelBtn.setTitle(NSLocalizedString("CANCEL", comment: "verify"), for: UIControlState.normal)
        saveBtn.setTitle(NSLocalizedString("SAVE", comment: "verify"), for: UIControlState.normal)
        
    }
    override func viewDidLoad() {
        self.changeLanguage()
        
        utilityCompanyId = UserDefaults.standard.value(forKey: "utilityCompanyId") as! String
        
        
        timestampFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        timestampFormatter.dateFormat = "HHmmss.SSS"
        
        let iconSize = CGRect(origin: CGPoint.zero, size: CGSize(width: 21, height: 44))
        let backButton = UIButton(frame: iconSize)
        backButton.setImage(UIImage(named: "customBackArrow1.png"), for: .normal)
        backButton.addTarget(self, action: #selector(self.cancelBackButton(sender:)), for: .touchUpInside)
        backButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 200
        locationManager.requestWhenInUseAuthorization()
        
        
        
        self.sendLocationView()
        
        
        logPointDescTextView.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        logPointDescTextView.layer.borderWidth = 1.0
        logPointDescTextView.layer.cornerRadius = 5
        
        
        
        storage = database.getSettings(columnName: "Storage")
        
        
        
        
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationItem.setHidesBackButton(true, animated:false)
        // //TealiumHelper.trackView(NSStringFromClass(self.classForCoder), dataSources: [:])
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        timer.invalidate()
        locationManager.stopUpdatingLocation()
        self.navigationItem.setHidesBackButton(false, animated:false)
    }
    
    
    
    @IBAction func cancelBackButton(sender: UIButton){
        logPointDescTextView.resignFirstResponder()
        
        let alert = UIAlertController(title: NSLocalizedString("Cancel Screen", comment: "Cancel Screen"), message: NSLocalizedString("Are you sure you want to cancel this screen?", comment: "Are you sure you want to cancel this screen?"), preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: "Ok"), style: .default, handler: { (action: UIAlertAction!) in
            
            
            if sender.tag == 1 {
                self.sendLocationView()
            }
            else{
                self.navigationController?.popViewController(animated: true)
            }
            
            
        }))
        
        alert.addAction(UIAlertAction(title:NSLocalizedString("Cancel", comment: "Cancel") , style: .cancel, handler: { (action: UIAlertAction!) in
        }))
        
        present(alert, animated: true, completion: nil)
        
        
    }
    
    
    func sendLocationView(){
        backButton.tag = 0
        self.sendingLocationView.isHidden = false
        self.timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.updateLocation), userInfo: nil, repeats: true)
        self.locationManager.startUpdatingLocation()
    }
    
    
    
    //pragma mark - textView Delegate row lifecycle
    
    func textViewDidBeginEditing(_ textView: UITextView) { // became first responder
        
        //move textViews up
        let myScreenRect: CGRect = UIScreen.main.bounds
        let keyboardHeight : CGFloat = 300
        
        UIView.beginAnimations( "animateView", context: nil)
        let movementDuration:TimeInterval = 0.35
        var needToMove: CGFloat = 0
        
        var frame : CGRect = self.view.frame
        if (textView.frame.origin.y + textView.frame.size.height + /*self.navigationController.navigationBar.frame.size.height + */UIApplication.shared.statusBarFrame.size.height > (myScreenRect.size.height - keyboardHeight)) {
            needToMove = (textView.frame.origin.y + textView.frame.size.height + /*self.navigationController.navigationBar.frame.size.height +*/ UIApplication.shared.statusBarFrame.size.height) - (myScreenRect.size.height - keyboardHeight);
        }
        
        frame.origin.y = -needToMove
        self.view.frame = frame
        UIView.setAnimationDuration(movementDuration )
        UIView.commitAnimations()
        
        
        
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        //move textViews back down
        UIView.beginAnimations( "animateView", context: nil)
        let movementDuration:TimeInterval = 0.35
        
        var frame : CGRect = self.view.frame
        frame.origin.y = 64
        self.view.frame = frame
        UIView.setAnimationDuration(movementDuration)
        UIView.commitAnimations()
        
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
        
    }
    
    
    
    
    
    func updateLocation(){
        locationManager.stopUpdatingLocation()
        locationManager.startUpdatingLocation()
        
    }
    
    
    //    MARK: - CLLocationManagerDelegate Methods
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
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
    
    
    func readBytesAvailable(_ count: UInt) {
        
        
        let buffer:UnsafeMutablePointer<UInt8> = UnsafeMutablePointer<UInt8>.allocate(capacity: 1024)
        let bytesRead:UInt = session!.read(buffer, bufferLength: 1024)
        
        if (bytesRead > 0) {
            var index:UInt = 0
            while (index < bytesRead) {
                responseArray += [buffer[Int(index)]]
    
                
                if(commaArray.count == 3){
                    
                    if(buffer[Int(index)] == 44){
                        commaArray.add(",")
                        totalRows = Int(totalRowSting)!
                    }
                    else{
                    let charcter = String(describing: UnicodeScalar(UInt8(buffer[Int(index)])))
                    totalRowSting += charcter
                    }
                }
                
                if buffer[Int(index)] == 44 && commaArray.count < 4{
                    commaArray.add(",")
                }
    
                
                if  buffer[Int(index)] == 10{
                    carriageReturnArray.add("Carriage Return")
                }
                
                index = index + 1;
            }
            
            
        }
        
        buffer.deinitialize()
        buffer.deallocate(capacity: 1024)
        
        
        
        if(carriageReturnArray.count == totalRows + 1){
            self.parser()
        }
        
        print(responseArray)
        
        
    }
    
    
    
    func parser(){
        
        logPointDescTextView.text = ""
        
        
        if (responseArray[3] == 77 && responseArray[4] == 82){
            projectName = NSLocalizedString("Read marker records captured from Locator", comment: "Read marker records captured from Locator")
            recordTypeId = "1"
        }
        else if (responseArray[3] == 77 && responseArray[4] == 80){
            projectName = NSLocalizedString("Program marker records from Locator", comment: "Program marker records from Locator")
            recordTypeId = "1"
        }
        else if (responseArray[3] == 84 && responseArray[4] == 82){
            projectName = NSLocalizedString("Cable depth records from Locator", comment: "Cable depth records from Locator")
            recordTypeId = "3"
        }
        
        projectId = database.getProjectId(projectName: projectName)
        
        
        
        
        labelArray = NSMutableArray()
        descriptionArray = NSMutableArray()
        
        var string: String? = ""
        
        if(responseArray.count > 22){
            
            for i in 23 ..< responseArray.count{
                
                print(responseArray[i])
                
                if (responseArray[i] == 58 && responseArray[i-1] == 32){
                    labelArray.add(string!)
                    string = ""
                }
                else if (responseArray[i] == 13){
                    descriptionArray.add(string!)
                    string = ""
                }
                else if ((responseArray[i] == 32 && responseArray[i+1] == 58) ||  (responseArray[i] == 32 && responseArray[i-1] == 58) || (responseArray[i] == 10)){
                }
                else if (responseArray[i] == 44){
                    string = ""
                }
                else
                {
                    let charcter = String(describing: UnicodeScalar(UInt8(responseArray[i])))
                    string! += charcter
                }
            }
        }
        print(labelArray)
        print(descriptionArray)
        
        totalRowSting = ""
        totalRows = 0
        carriageReturnArray = []
        commaArray = []
        responseArray = []
        timer.invalidate()
        locationManager.stopUpdatingLocation()
        backButton.tag = 1
        self.sendingLocationView.isHidden = true
        self.table!.reloadData()
    }
    
    
    
    // MARK:  UITableView Data Source Methods
    private func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat    {
        return 44
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return labelArray.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : CustomTableViewCell = (tableView.dequeueReusableCell(withIdentifier: "CustomLocatorRecordCaptureCell") as! CustomTableViewCell!)
        
        cell.leftTextfield.text = labelArray .object(at: indexPath.row) as? String
        cell.rightTextfield.text = descriptionArray .object(at: indexPath.row) as? String
        
        return cell
    }
    
    
    
    
    
    @IBAction func submitButtonClicked(){
        
        
        
        let  canStoreDataToCloud:String = database.getUserProfile(columnName: "canStoreDataToCloud")
        let utilityCompanyVerifiedState:String = database.getUtilityCompany(columnName: "verified")
        if canStoreDataToCloud != "Y" || utilityCompanyVerifiedState != "Y"{
            
            self.storeLocalDB()
            
            let alert = UIAlertController(title: "", message: NSLocalizedString("Limited functionality - Data stored locally. Cloud data access is not setup. Click here to contact 3M sales representative", comment: "Limited functionality - Cloud data access is not setup. Click here to contact 3M sales representative"), preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title:NSLocalizedString("Ok", comment: "Ok") , style: .default, handler: { (action: UIAlertAction!) in
                let viewController = UIStoryboard(name: "Custom", bundle: nil).instantiateViewController(withIdentifier: "WebViewViewController") as! WebViewViewController
                viewController.urlString = "https://www.3m.com/3M/en_US/company-us/all-3m-products/~/All-3M-Products/Locating-Marking/Path-Marking/?N=5002385+8710662+8711017+8731984+3294857497&rt=r3&utm_source=app&utm_medium=asset_mgt"
                self.navigationController!.pushViewController(viewController, animated: true)                }))
            self.present(alert, animated: true, completion: nil)
            
        }
        else
        {
            // Cloud storage access available
            
            
            if self.storage != "Cloud Storage"{
                self.storeLocalDB()
                self.successMessage(Message: "Data stored locally.")
                
            }
            else if !isConnectedToNetwork(){
                self.storeLocalDB()
                self.successMessage(Message: "No internet connection. So your data stored locally.")
            }
            else{
                self.sendToCloud()
            }
        }
    }
    
    
    
    
    
    func successMessage(Message:String){
        
        let message = NSLocalizedString(Message, comment: Message)
        let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: "Ok"), style: .default, handler: { (action: UIAlertAction!) in
            self.sendLocationView()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func storeLocalDB(){
        self.insrtlogDataToLocalDB()
        self .insrtlogDataDetailsToLocalDB()
    }
    
    
    
    
    func sendToCloud(){
        
        showActivityIndicator(false)
        self.storeLocalDB()
        self .performSyncApptoCloud()
    }
    
    
    
    func insrtlogDataToLocalDB()
    {
        
        let installerCompanyId:String = database.getUserProfile(columnName: "installerCompanyID")
        let userProfileId:String = UserDefaults.standard.value(forKey: "userProfileId") as! String
        
        let tblLogData: [String : Any] = ["recordTypeId" : recordTypeId,
                                          "utilityCompanyId" : utilityCompanyId,
                                          "installerCompanyId": installerCompanyId,
                                          "projectId" : projectId,
                                          "projectName" : projectName,
                                          "logPointDescription":logPointDescTextView.text,
                                          "userProfileId" : userProfileId] as [String : Any]
        
        
        self.database .insertLogData(array: [tblLogData])
    }
    
    
    func insrtlogDataDetailsToLocalDB(){
        
        
        let logDataId:String = self.database.getLogData() .object(at: 0) as! String
        let createdDate:String = self.database.getLogData() .object(at: 1) as! String
        
        
        var tblLogDataDetails = [[String: Any]]()
        
        
        for i in 0 ..< labelArray.count {
            
            
            
            let labelString:String = labelArray .object(at: i) as! String
            let descriptionString:String = descriptionArray .object(at: i) as! String
            
            
            if labelString != "" {
                
                let logDataDetails:[String : Any] = ["logDataId": logDataId,
                                                     "label": labelString,
                                                     "description": descriptionString,
                                                     "templateTypeId": "2",
                                                     "createdDate": createdDate] as [String : Any]
                tblLogDataDetails.append(logDataDetails)
                
            }
            
        }
        
        
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
                }
                if let data = data {
                    do{
                        
                        
                        let jsonData =  try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary
                        let status =  jsonData?["status"] as! String
                        
                        print(status)
                        print(jsonData)
                        
                        DispatchQueue.main.async {
                            hideActivityIndicator()
                            
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
    
    
    
    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    
    
    
    
}

