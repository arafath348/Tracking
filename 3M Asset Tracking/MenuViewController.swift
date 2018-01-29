//
//  MenuViewController.swift
//  3M L&M
//
//  Created by dcwaters on 19/07/17.
//  Copyright © 2017 3M L&M. All rights reserved.
//

import UIKit


class MenuViewController: UIViewController {
    
    var companyArray:NSArray = []
    @IBOutlet var syncLabel: UILabel!
    @IBOutlet var syncTimeLabel: UILabel!
    @IBOutlet weak var userGuideBtn: UIButton!

    @IBOutlet weak var logoutBtn: UIButton!
    @IBOutlet weak var settingsBtn: UIButton!
    @IBOutlet weak var dataLookupBtn: UIButton!
    @IBOutlet weak var dataCaptureBtn: UIButton!
    let database = DatabaseHandler()
    var databasePath = "databasePath"
    var oldFileSize:Int = 0
    var utilityCompanyId: String = ""
    var dataString: String = ""

    

    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationItem.backBarButtonItem?.isEnabled = false
        self.navigationItem.setHidesBackButton(true, animated:false)
        
        //TealiumHelper.trackView(NSStringFromClass(self.classForCoder), dataSources: [:])

        
        let differnceTime:String = offsetFrom(date: NSDate() as Date)
        if differnceTime == "0" {
            syncTimeLabel.text = String(format:NSLocalizedString("Last sync:0s ago", comment: "Last sync:0s ago"))
        }
        syncTimeLabel.text = String(format:NSLocalizedString("Last sync:%@ ago", comment: "Last sync:%@ ago"),differnceTime)

        databasePath = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("db.sqlite").path
        
       

        
    }
    @IBAction func userGuideBtnClicked(_ sender: Any) {
        
        let viewController = UIStoryboard(name: "Custom", bundle: nil).instantiateViewController(withIdentifier: "WebViewViewController") as! WebViewViewController
        viewController.urlString = "https://multimedia.3m.com/mws/media/1466836O/instructions-for-3m-asset-tracking-app.pdf"
        self.navigationController!.pushViewController(viewController, animated: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        self.changeLanguage()
        
    }
    func changeLanguage(){
        //self.syncLabel.text = String(format:NSLocalizedString("Sync: %@", comment: "Sync: %@"),dataString)
        userGuideBtn.setAttributedTitle(nil, for: UIControlState.normal)
        userGuideBtn.setTitle(NSLocalizedString("3M Asset Tracking User Guide", comment: "3M Asset Tracking User Guide"), for: UIControlState.normal)
        self.title = NSLocalizedString("Main Menu", comment: "Main Menu")
         syncTimeLabel.text = String(format:NSLocalizedString("Last sync:0s ago", comment: "Last sync:0s ago"))
      //  self.syncLabel.text = String(format:NSLocalizedString("Syncing data and it may take 2-3 minutes. Please wait…", comment: "Syncing data and it may take 2-3 minutes. Please wait…"))
        logoutBtn.setTitle(NSLocalizedString("Logout", comment: "Logout"), for: UIControlState.normal)
       settingsBtn.setTitle(NSLocalizedString("Settings", comment: "Logout"), for: UIControlState.normal)
      dataLookupBtn.setTitle(NSLocalizedString("Data Lookup", comment: "Logout"), for: UIControlState.normal)
       dataCaptureBtn.setTitle(NSLocalizedString("Data Capture", comment: "Logout"), for: UIControlState.normal)
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationItem.backBarButtonItem?.isEnabled = true
        self.navigationItem.setHidesBackButton(false, animated:false)
    }
    
    
    func offsetFrom(date: Date) -> String {
        
        
        let currentDate = NSDate()
        let lastSyncTime:String = database.getLastSyncTimeSettings()

        if lastSyncTime != ""{
        var lastSyncDate = Date(timeIntervalSince1970: (Double(lastSyncTime)! / 1000.0))
            
            
            let calendar = Calendar.current
            lastSyncDate =  calendar.date(byAdding: .minute, value: 2, to: lastSyncDate as Date)!

            
        let dayHourMinuteSecond: Set<Calendar.Component> = [.day, .hour, .minute, .second]
        let difference = NSCalendar.current.dateComponents(dayHourMinuteSecond, from: lastSyncDate, to: currentDate as Date);
        let seconds = "\(difference.second ?? 0)s"
        let minutes = "\(difference.minute ?? 0)m" + " " + seconds
        let hours = "\(difference.hour ?? 0)h" + " " + minutes
        let days = "\(difference.day ?? 0)d" + " " + hours
        
        if let day = difference.day, day          > 0 { return days }
        if let hour = difference.hour, hour       > 0 { return hours }
        if let minute = difference.minute, minute > 0 { return minutes }
        if let second = difference.second, second > 0 { return seconds }
        }
        return "0"
    }
 
    
 
    

    override func viewDidLoad() {
        super.viewDidLoad()
        utilityCompanyId = UserDefaults.standard.value(forKey: "utilityCompanyId") as! String
        
        self .performApiSync()

       self.syncLabel.text = String(format:NSLocalizedString("Syncing data and it may take 2-3 minutes. Please wait…", comment: "Syncing data and it may take 2-3 minutes. Please wait…"))
        let tapSync = UITapGestureRecognizer(target: self, action: #selector(self.performApiSync))
        syncLabel.addGestureRecognizer(tapSync)
        let tapSync1 = UITapGestureRecognizer(target: self, action: #selector(self.performApiSync))

        syncTimeLabel.addGestureRecognizer(tapSync1)

    }
    func connectDb()
    {
        let sourcePath = Bundle.main.path(forResource: "db", ofType: "sqlite")
        databasePath = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("db.sqlite").path
        do {
            try FileManager().copyItem(atPath: sourcePath!, toPath: databasePath)
            
        } catch _ {
        }
    }
    
    
    func currentTimeInMiliseconds(){
        
        
        let UTCDate = Date()
        print(UTCDate)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone(identifier:"GMT")
        let calendar = Calendar.current
        let newDate =  calendar.date(byAdding: .minute, value: -2, to: UTCDate as Date)
        
        
        let date =  formatter.date(from: formatter.string(from: newDate!))
        
        let nowDouble = date!.timeIntervalSince1970
        let lastSyncTime:String = String(Int64(nowDouble*1000))
        print(lastSyncTime)
        
        database.updateLastSyncTimeSetting(lastSyncTime: lastSyncTime)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func performApiSync() {
        
        self.syncLabel.text = String(format:NSLocalizedString("Syncing data and it may take 2-3 minutes. Please wait…", comment: "Syncing data and it may take 2-3 minutes. Please wait…"))

        showActivityIndicator(false)
        
        
        let session = URLSession.shared
        
        
        let url = String(format:"%@sync-cloud-to-app",kUrlBase)
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        
        
        request.httpMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        let params:[String: String]
        
        
        let lastSyncTime:String = database.getLastSyncTimeSettings()
        
        if lastSyncTime == "" {
            database.deleteAllTable()
        }
        
        

        params = ["lastSyncTime" : lastSyncTime,"utilityCompanyId" : utilityCompanyId]
     
 

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
                    showAlert(kEmptyString, message:NSLocalizedString("Please check your network availability", comment: "Please check your network availability") )
                    hideActivityIndicator()
                }
                if let data = data {
                    do{
                      
                        let json =  (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String:Any]
                       
                        
                        
                        self.connectDb()
                        
                        
                        if lastSyncTime == "" {
                            self.oldFileSize = 0
                        }
                        else {
                        self.oldFileSize = try! FileManager.default.attributesOfItem(atPath: self.databasePath)[FileAttributeKey.size] as! Int
                        }
                        
  
                               print(json)
                        
                          if let data = json?["data"] as? [String : Any],
                             let tables = data["tables"] as? [String : Any],
                             let tblFunctionType = tables["tblFunctionType"] as? [String : Any],
                            let records = tblFunctionType["records"] as? NSArray
                           {
                            self.database .insertFunctionType(array: records)
                           }
                        
                        
                        
                        
                        if let data = json?["data"] as? [String : Any],
                            let tables = data["tables"] as? [String : Any],
                            let tblDataCategory = tables["tblDataCategory"] as? [String : Any],
                            let records = tblDataCategory["records"] as? NSArray
                        {
                            self.database .insertDataCategory(array: records)
                        }
                        
                        if let data = json?["data"] as? [String : Any],
                            let tables = data["tables"] as? [String : Any],
                            let tblDataType = tables["tblDataType"] as? [String : Any],
                            let records = tblDataType["records"] as? NSArray
                        {
                            self.database .insertDataType(array: records)
                        }
                        
                                                
                        if let data = json?["data"] as? [String : Any],
                            let tables = data["tables"] as? [String : Any],
                            let tblDescriptionTranslation = tables["tblDescriptionTranslation"] as? [String : Any],
                            let records = tblDescriptionTranslation["records"] as? NSArray
                        {
                            self.database .insertDescriptionTranslation(array: records)
                        }
                        
                        
                        if let data = json?["data"] as? [String : Any],
                            let tables = data["tables"] as? [String : Any],
                            let tblLabelTranslation = tables["tblLabelTranslation"] as? [String : Any],
                            let records = tblLabelTranslation["records"] as? NSArray
                        { 
                            self.database .insertLabelTranslation(array: records)
                        }
                        
                        if let data = json?["data"] as? [String : Any],
                            let tables = data["tables"] as? [String : Any],
                            let tblLabelVsDescXREF = tables["tblLabelVsDescXREF"] as? [String : Any],
                            let records = tblLabelVsDescXREF["records"] as? NSArray
                        {
                            self.database .insertLabelVsDescXREF(array: records)
                        }
                        
                        

                        
                        if let data = json?["data"] as? [String : Any],
                            let tables = data["tables"] as? [String : Any],
                            let tblLanguage = tables["tblLanguage"] as? [String : Any],
                            let records = tblLanguage["records"] as? NSArray
                        {
                            self.database .insertLanguage(array: records)
                        }
                        
                        
                        if let data = json?["data"] as? [String : Any],
                            let tables = data["tables"] as? [String : Any],
                            let tblPredefinedDescription = tables["tblPredefinedDescription"] as? [String : Any],
                            let records = tblPredefinedDescription["records"] as? NSArray
                        {
                            self.database .insertPredefinedDescription(array: records)
                        }
                        

                        
                        if let data = json?["data"] as? [String : Any],
                            let tables = data["tables"] as? [String : Any],
                            let tblPredefinedLabel = tables["tblPredefinedLabel"] as? [String : Any],
                            let records = tblPredefinedLabel["records"] as? NSArray
                        {
                            self.database .insertPredefinedLabel(array: records)
                        }
                        
                        
                        if let data = json?["data"] as? [String : Any],
                            let tables = data["tables"] as? [String : Any],
                            let tblProductCatalogue = tables["tblProductCatalogue"] as? [String : Any],
                            let records = tblProductCatalogue["records"] as? NSArray
                        {
                            self.database .insertProductCatalogue(array: records)
                        }
                    
                        
                        if let data = json?["data"] as? [String : Any],
                            let tables = data["tables"] as? [String : Any],
                            let tblProject = tables["tblProject"] as? [String : Any],
                            let records = tblProject["records"] as? NSArray
                        {
                            self.database .insertProject(array: records)
                        }
                        
                        
                        
                        if let data = json?["data"] as? [String : Any],
                            let tables = data["tables"] as? [String : Any],
                            let tblRecordType = tables["tblRecordType"] as? [String : Any],
                            let records = tblRecordType["records"] as? NSArray
                        {
                            self.database .insertRecordType(array: records)
                        }
                        
                        
                        

                        
                        if let data = json?["data"] as? [String : Any],
                            let tables = data["tables"] as? [String : Any],
                            let tblSecurityQuestion = tables["tblSecurityQuestion"] as? [String : Any],
                            let records = tblSecurityQuestion["records"] as? NSArray
                        {
                            self.database .insertSecurityQuestion(array: records)
                        }

                        
                        
                        if let data = json?["data"] as? [String : Any],
                            let tables = data["tables"] as? [String : Any],
                            let tblSmartUser = tables["tblSmartUser"] as? [String : Any],
                            let records = tblSmartUser["records"] as? NSArray
                        {
                            self.database .insertSmartUser(array: records)
                        }
                        
                        
                        
                        if let data = json?["data"] as? [String : Any],
                            let tables = data["tables"] as? [String : Any],
                            let tblTemplate = tables["tblTemplate"] as? [String : Any],
                            let records = tblTemplate["records"] as? NSArray
                        {
                            self.database .insertTemplate(array: records)
                        }
                        
                        if let data = json?["data"] as? [String : Any],
                            let tables = data["tables"] as? [String : Any],
                            let tblTemplateDetails = tables["tblTemplateDetails"] as? [String : Any],
                            let records = tblTemplateDetails["records"] as? NSArray
                        {
                            self.database .insertTemplateDetails(array: records)
                        }
               
                    
                        if let data = json?["data"] as? [String : Any],
                            let tables = data["tables"] as? [String : Any],
                            let tblTemplateType = tables["tblTemplateType"] as? [String : Any],
                            let records = tblTemplateType["records"] as? NSArray
                        {
                            self.database .insertTemplateType(array: records)
                        }
                        
                        
                        if let data = json?["data"] as? [String : Any],
                            let tables = data["tables"] as? [String : Any],
                            let tblUserProfile = tables["tblUserProfile"] as? [String : Any],
                            let records = tblUserProfile["records"] as? NSArray
                        {
                            self.database .insertUserProfile(array: records)
                        }
                        

                        if let data = json?["data"] as? [String : Any],
                            let tables = data["tables"] as? [String : Any],
                            let tblUtilityCompany = tables["tblUtilityCompany"] as? [String : Any],
                            let records = tblUtilityCompany["records"] as? NSArray
                        {
                            self.database .insertUtilityCompany(array: records)
                        }
                        
                        
                        if let data = json?["data"] as? [String : Any],
                            let tables = data["tables"] as? [String : Any],
                            let tblUtilityCompanyType = tables["tblUtilityCompanyType"] as? [String : Any],
                            let records = tblUtilityCompanyType["records"] as? NSArray
                        {
                            self.database .insertUtilityCompanyType(array: records)
                        }
                        
                        
                        
                        
                        self .currentTimeInMiliseconds()
                        
                        
                        let newFileSize:Int = try! FileManager.default.attributesOfItem(atPath: self.databasePath)[FileAttributeKey.size] as! Int
                        
                        print(self.oldFileSize)
                        print(newFileSize)

                        
                        let fileSize:Int = newFileSize - self.oldFileSize

                        print("There were \(fileSize) bytes")
                        if (fileSize > 100000){
                            let bcf = ByteCountFormatter()
                            bcf.allowedUnits = [.useMB] // optional: restricts the units to MB only
                            bcf.countStyle = .file
                            self.dataString = bcf.string(fromByteCount: Int64(fileSize))
                            print("******formatted result: \(self.dataString)")
                            
                        }
                        else{
                            let bcf = ByteCountFormatter()
                            bcf.allowedUnits = [.useKB]
                            bcf.countStyle = .file
                            self.dataString = bcf.string(fromByteCount: Int64(fileSize))
                            print("******formatted result: \(self.dataString)")
                            
                        }

                   
                        
                        
                        let  canStoreDataToCloud:String = self.database.getUserProfile(columnName: "canStoreDataToCloud")
                        let utilityCompanyVerifiedState:String = self.database.getUtilityCompany(columnName: "verified")
                        let storage:String = self.database.getSettings(columnName: "Storage")

                        if canStoreDataToCloud == "Y" && utilityCompanyVerifiedState == "Y" && storage == "Cloud Storage"{
                            self.sendToCloud()
                        }
                        else{
                                
                                DispatchQueue.main.async {
                                    self.syncLabel.text = String(format:NSLocalizedString("Sync: %@", comment: "Sync: %@"),self.dataString)
                                    self.syncTimeLabel.text = String(format:NSLocalizedString("Last sync:0s ago", comment: "Last sync:0s ago"))
                                    hideActivityIndicator()
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
    

    
    
    
    func getCompanyList()
    {
        
        if !isConnectedToNetwork() {
            showAlert("", message: NSLocalizedString("No internet data connection. Settings cannot be changed now. Data can still be captured", comment: "No internet data connection. Settings cannot be changed now. Data can still be captured"))
        }
        else{
        
        let Parameter:String = "utility-companies"
        
        RestApiManager.sharedInstance.getRandomUser(Parameter as String)
        {
            json in
            let status = json["status"]
            let data = json["data"]
            
            
            if(status == "Success")
            {
                self.companyArray =  data.object as! NSArray
                DispatchQueue.main.async {
                    hideActivityIndicator()

                    let viewController = self.storyboard!.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
                    viewController.companyArray = self.companyArray
                    self.navigationController!.pushViewController(viewController, animated: true)
                }
            }
        }
        }
        
    }
    
    
    
    
    
    
    
    
   @IBAction func settingsButtonClicked()
    {
        self .getCompanyList()
       
    }
    
    

    
    @IBAction func logoutButtonClicked()
    {
        let alert = UIAlertController(title: NSLocalizedString("Logout", comment: "Logout"), message: NSLocalizedString("Are you sure you want to logout?", comment: "Are you sure you want to logout?"), preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: "Ok"), style: .default, handler: { (action: UIAlertAction!) in
            self.navigationController?.popViewController(animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .cancel, handler: { (action: UIAlertAction!) in
        }))
        
        present(alert, animated: true, completion: nil)
    }
    

    @IBAction func dataLookupButtonClicked()
    {
        let canlookuputilitycompanyData:String = database.getUserProfile(columnName: "canlookuputilitycompanyData")
        let canlookupinstallercompanyData:String = database.getUserProfile(columnName: "canlookupinstallercompanyData")
        let Canlookupowndata:String = database.getUserProfile(columnName: "Canlookupowndata")
        
        if(canlookuputilitycompanyData == "Y" || canlookupinstallercompanyData == "Y" || Canlookupowndata == "Y"){
            let viewController = self.storyboard!.instantiateViewController(withIdentifier: "DataLookupViewController") as! DataLookupViewController
            self.navigationController!.pushViewController(viewController, animated: true)
        }
        else{
            showAlert("", message: NSLocalizedString("You don't have privilege for data lookup", comment: "You don't have privilege for data lookup"))
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
    
    
    
    func performSyncApptoCloud()
    {
        
        
        var tblLogData = [[String: Any]]()
        tblLogData = database .getTblLogData()
        
        var tblLogDataDetails = [[String: Any]]()
        tblLogDataDetails = database .getTblLogDataDetails()
        
        
        if(tblLogData.count == 0 || tblLogDataDetails.count == 0){
            DispatchQueue.main.async {
                self.syncLabel.text = String(format:NSLocalizedString("Sync: %@", comment: "Sync: %@"),self.dataString)
                self.syncTimeLabel.text = String(format:NSLocalizedString("Last sync:0s ago", comment: "Last sync:0s ago"))
                hideActivityIndicator()
            }
        }
        else{
        
        let params = ["lastSyncTime":"",
                      "utilityCompanyId": utilityCompanyId,
                      "tables":["tblLogData":["records":tblLogData],
                                "tblLogDataDetails":["records":tblLogDataDetails]]] as [String : Any]
        
        
        
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
                        
                        
                        DispatchQueue.main.async {
                            self.syncLabel.text = String(format:NSLocalizedString("Sync: %@", comment: "Sync: %@"),self.dataString)
                            self.syncTimeLabel.text = String(format:NSLocalizedString("Last sync:0s ago", comment: "Last sync:0s ago"))
                            hideActivityIndicator()
                            
                            
                            
                            if(status == "Error"){
                                let data: String = (jsonData as AnyObject).value(forKey: "data") as! String
                                showAlert(kEmptyString, message:data)
                            }
                            else
                            {
                                self.database.deleteLogData()
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
    
    //image api call
    func imageAPICall(imagePathArray:NSArray, logDataDetailIDArray:NSArray, index:Int){
        
        
        let imagePath:String = imagePathArray .object(at: index) as! String
        let logDataDetailID:String = logDataDetailIDArray .object(at: index) as! String
        
        
        
        let session = URLSession.shared
        
        
        
        let url = NSURL(string: String(format:"%@%@/file/%@/",kUrlBase,utilityCompanyId,imagePath))
        let request = NSMutableURLRequest(url: url! as URL)
        
        request.httpMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        
        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let path =  String(format:"%@/%@",documentsDirectory,imagePath)
        
        print(path)
        
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
    
    
    
    
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
