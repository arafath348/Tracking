//
//  LocatorRecordCaptureViewController.swift
//  3M Asset Tracking
//
//  Created by IndianRenters on 25/10/17.
//  Copyright © 2017 IndianRenters. All rights reserved.
//

import UIKit

class LocatorRecordCaptureViewController: UIViewController , CLLocationManagerDelegate, SearchBarDelegate
{
    
    var locationManager = CLLocationManager()
    let timestampFormatter = DateFormatter()
    var timer = Timer()
    var session:AirconsoleSession?
    var responseArray = [UInt8]()
    var labelArray: NSMutableArray = []
    var descriptionArray: NSMutableArray = []
    @IBOutlet var projectLabel: UILabel!
    @IBOutlet var projectTextField: UITextField!
    @IBOutlet weak var projLbl: UILabel!
    @IBOutlet weak var projectView: UIView?
    @IBOutlet weak var projectInnerView: UIView?
    @IBOutlet weak var subInnerBtn: UIButton!
    @IBOutlet weak var canInnerBtn: UIButton!
    @IBOutlet weak var projInnerView: UILabel!
    @IBOutlet weak var startLocationBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var arrowButton: UIButton!
    @IBOutlet weak var sendGpsLabel: UILabel!
    @IBOutlet weak var recordsCountLabel: UILabel!
    

    var recordsCount: Int = 0
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
    var byesArray = [UInt8]()
    var backgroundTaskIdentifier: UIBackgroundTaskIdentifier?
    var navBarHeight: CGFloat = 0
    var projectInnerViewYposition:CGFloat!

    
    //    MARK: - View Life Cycle Methods
    
    override func viewWillAppear(_ animated: Bool) {
        self.changeLanguage()
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        self.navigationItem.setHidesBackButton(true, animated:false)
        projectInnerViewYposition = self.projectInnerView?.frame.origin.y

        TealiumHelper.sharedInstance().trackView(title: "Locator Record Capture", data: [:])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        timer.invalidate()
        locationManager.stopUpdatingLocation()
        self.navigationItem.setHidesBackButton(false, animated:false)
    }
    
    func changeLanguage(){
        DispatchQueue.main.async {
        self.title = NSLocalizedString("Locator Record Capture", comment: "Locator Record Capture")
        self.projLbl.text = NSLocalizedString("Select Project or Add Project", comment: "Project")
        self.projInnerView.text = NSLocalizedString("Project Name", comment: "")
        self.subInnerBtn.setTitle(NSLocalizedString("SUBMIT", comment: "verify"), for: UIControlState.normal)
        self.canInnerBtn.setTitle(NSLocalizedString("CANCEL", comment: "verify"), for: UIControlState.normal)
        self.startLocationBtn.setTitle(NSLocalizedString("SEND LOCATION", comment: "SEND LOCATION"), for: UIControlState.normal)
        self.cancelBtn.setTitle(NSLocalizedString("CANCEL", comment: "CANCEL"), for: UIControlState.normal)
        self.sendGpsLabel.text = ""
        }
    }
    override func viewDidLoad() {
       
        
        navBarHeight = UIApplication.shared.statusBarFrame.height + self.navigationController!.navigationBar.frame.height

        
        utilityCompanyId = UserDefaults.standard.value(forKey: "utilityCompanyId") as! String
        
        
        timestampFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        timestampFormatter.dateFormat = "HHmmss.SSS"
        
        let iconSize = CGRect(origin: CGPoint.zero, size: CGSize(width: 21, height: 44))
        let backButton = UIButton(frame: iconSize)
        backButton.setImage(UIImage(named: "customBackArrow1.png"), for: .normal)
        backButton.addTarget(self, action: #selector(self.cancelBackButton), for: .touchUpInside)
        backButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        
    
        storage = database.getSettings(columnName: "Storage")

        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.allowsBackgroundLocationUpdates = true
        
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(self.projectDropdownClicked))
        projectLabel.addGestureRecognizer(tap1)

    }

    
    @IBAction func startSendingLocation(){
     
        if projectLabel.text!.isEmpty {
            
            showAlert(kEmptyString, message: NSLocalizedString("Please select project or add project", comment: "Please select project"))
        }
        else{
            self.locationManager.startUpdatingLocation()
        }
    }
    
   
    
    func sessionWrite(){
        print("writing session...")
        session?.write(byesArray, length: UInt(byesArray.count))
    }
    
    @IBAction func cancelBackButton(){
        
        
        let alert = UIAlertController(title: NSLocalizedString("Cancel Screen", comment: "Cancel Screen"), message: NSLocalizedString("Are you sure you want to cancel this screen?", comment: "Are you sure you want to cancel this screen?"), preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: "Ok"), style: .default, handler: { (action: UIAlertAction!) in
                self.navigationController?.popViewController(animated: true)
        }))
        
        alert.addAction(UIAlertAction(title:NSLocalizedString("Cancel", comment: "Cancel") , style: .cancel, handler: { (action: UIAlertAction!) in
        }))
        present(alert, animated: true, completion: nil)
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
        
        byesArray = [UInt8]()
        byesArray = Array(nmea0183GPGGA.utf8)
        byesArray += [13, 10]

        
        if(!timer.isValid){
            
            projLbl.isEnabled = false
            projectLabel.isEnabled = false
            arrowButton.isEnabled = false
            projectLabel.isUserInteractionEnabled = false
            startLocationBtn.alpha = 0.5
            startLocationBtn.isUserInteractionEnabled = false
            self.sendGpsLabel.text = NSLocalizedString("Sending location to locator...", comment: "")

            self.sessionWrite()
            backgroundTaskIdentifier = UIApplication.shared.beginBackgroundTask(expirationHandler: {
                UIApplication.shared.endBackgroundTask(self.backgroundTaskIdentifier!)
            })
            self.timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.sessionWrite), userInfo: nil, repeats: true)
        }
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
                    SVProgressHUD.show(withStatus: "Receiving data from locator...")
                    locationManager.stopUpdatingLocation()

                    
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
        
        self.submitButtonClicked()
    }
    
    
    
    
    
    
    func submitButtonClicked(){
        
        
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
            SVProgressHUD.dismiss()
            
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
         SVProgressHUD.showSuccess(withStatus: message)
         self.locationManager.startUpdatingLocation()
        
        recordsCountLabel.isHidden = false
        recordsCount += 1
        recordsCountLabel.text = String(format:"Records Submitted: %d",recordsCount)
    }
    
    func storeLocalDB(){
        self.insrtlogDataToLocalDB()
        self .insrtlogDataDetailsToLocalDB()
    }
    
    
    
    func sendToCloud(){
         
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
                                          "logPointDescription":"",
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
                    SVProgressHUD.dismiss()
                }
                if let data = data {
                    do{
                        
                        
                        let jsonData =  try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary
                        let status =  jsonData?["status"] as! String
                        
                        
                        DispatchQueue.main.async {
                            SVProgressHUD.dismiss()
                            
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
    
    
    
    
    
    func projectDropdownClicked(sender: UIButton)
    {
        
        let viewController = UIStoryboard(name: "Custom", bundle: nil).instantiateViewController(withIdentifier: "SearchBarViewController") as! SearchBarViewController
        
        
        let projectTableArray:NSArray = database .getProjectArray()
        
        
        let projectArray = projectTableArray .object(at: 0) as! NSArray
        let projectIdArray = projectTableArray .object(at: 1) as! NSArray
        
        viewController.delegate = self
        viewController.companyArray = projectArray
        viewController.utilityCompanyIdArray = projectIdArray
        viewController.titleString = NSLocalizedString("Select Project", comment: "Select Project")
        viewController.needAddButton = true
        
        
        self.navigationController!.pushViewController(viewController, animated: true)
        
    }
    
    func selectedValue(company: String,utilityCompanyId: String,titleString: String){
        if company != "" {
            projectLabel.text = company
            projectId = utilityCompanyId
        }
        else
        {
            projectTextField.text = ""
            projectView?.isHidden = false
        }
    }
    
    
    
    
    //pragma mark - textField Delegate row lifecycle
    
    func textFieldDidBeginEditing(_ textField: UITextField) { // became first responder
        
        
        
        
        //move textfields up
        let myScreenRect: CGRect = UIScreen.main.bounds
        let keyboardHeight : CGFloat = 300
        
        
        UIView.beginAnimations( "animateView", context: nil)
        let movementDuration:TimeInterval = 0.35
        
        
        var needToMove: CGFloat = -navBarHeight
        
        var frame : CGRect = self.view.frame
        
        
        if (textField.frame.origin.y + textField.frame.size.height +
            /*self.navigationController.navigationBar.frame.size.height + */
            UIApplication.shared.statusBarFrame.size.height > (myScreenRect.size.height - keyboardHeight)) {
            needToMove = (textField.frame.origin.y + textField.frame.size.height + /*self.navigationController.navigationBar.frame.size.height +*/ UIApplication.shared.statusBarFrame.size.height) - (myScreenRect.size.height - keyboardHeight);
        }
        
        if projectView?.isHidden == false {
            self.projectInnerView?.frame.origin.y = -needToMove
        }
        else
        {
            frame.origin.y = -needToMove
            self.view.frame = frame
        }
        
        
        
        UIView.setAnimationDuration(movementDuration)
        UIView.commitAnimations()
        
        
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        
        //move textfields back down
        UIView.beginAnimations( "animateView", context: nil)
        let movementDuration:TimeInterval = 0.35
        
        
        if projectView?.isHidden == false {
            self.projectInnerView?.frame.origin.y = projectInnerViewYposition
        }
        else
        {
            var frame : CGRect = self.view.frame
            frame.origin.y = navBarHeight
            self.view.frame = frame
        }
        
        
        
        UIView.setAnimationDuration(movementDuration)
        UIView.commitAnimations()
        
        
        
        
        
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        
        return true
    }
    
    
    @IBAction func cancelBtnClicked() {
        projectTextField .resignFirstResponder()
        projectView?.isHidden = true
    }
    
    
    
    
    @IBAction func projectAddBtnClicked() {
        
        let project = projectTextField.text!.trimmingCharacters(in: NSCharacterSet.whitespaces)
        let canCreateNewProjects:String = database .canCreateNewProjects()
        if canCreateNewProjects == "N" {
            showAlert("", message: NSLocalizedString("You don't have privilege to create new project", comment: "You don't have privilege to create new project"))
            self.cancelBtnClicked()
            
        }
        else if (project .isEmpty) {
            showAlert("", message: NSLocalizedString("Please enter project name", comment: "Please enter project name"))
        }
        else{
            projectTextField .resignFirstResponder()
            
            SVProgressHUD.show(withStatus: "Loading...")
            
            let session = URLSession.shared
            
            let url = String(format:"%@project",kUrlBase)
            let request = NSMutableURLRequest(url: NSURL(string: url)! as URL)
            
            request.httpMethod = "POST"
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            
            
            
            let params = ["projectName": self.projectTextField.text!,
                          "utilityCompanyId":utilityCompanyId] as [String : Any]
            
            
            
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
                        SVProgressHUD.dismiss()
                    }
                    if let data = data {
                        do{
                            
                            
                            let jsonData =  try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary
                            
                            let status =  jsonData?["status"] as! String
                            
                            
                            
                            DispatchQueue.main.async {
                                SVProgressHUD.dismiss()
                                
                                
                                
                                
                                if(status == "InValid" || status == "Error"){
                                    self.projectLabel.text = ""
                                    let data: String = (jsonData as AnyObject).value(forKey: "data") as! String
                                    showAlert(kEmptyString, message:data)
                                }
                                else
                                {
                                    self.projectLabel.text = self.projectTextField.text
                                    
                                    let data =  jsonData?["data"] as! NSDictionary
                                    let id:NSNumber = data.value(forKey: "projectId") as! NSNumber
                                    self.projectId = String(describing: id)
                                    self.database.insertProject(array: [data])
                                    
                                    let alert = UIAlertController(title: "", message: NSLocalizedString("Project added successfully", comment: "Project added successfully"), preferredStyle: UIAlertControllerStyle.alert)
                                    alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: "Ok"), style: .default, handler: { (action: UIAlertAction!) in
                                        self.projectView?.isHidden = true
                                        
                                    }))
                                    self.present(alert, animated: true, completion: nil)
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
    }
    
    
    
    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    
    
    
    
}

