//
//  EmsPassiveViewController.swift
//  3M L&M
//
//  Created by IndianRenters on 22/08/17.
//  Copyright © 2017 3M L&M. All rights reserved.
//

import UIKit
import CoreLocation

class EmsPassiveViewController: UIViewController,SearchBarDelegate,CLLocationManagerDelegate,LocationDelegate, tblLogDataDetailsDelegate,GMSMapViewDelegate{
    
    //For localization
    @IBOutlet weak var canInnerBtn: UIButton!
    @IBOutlet weak var subInnerBtn: UIButton!
    @IBOutlet weak var projInnerLbl: UILabel!
    @IBOutlet weak var productLbl: UILabel!
    @IBOutlet weak var utilityLbl: UILabel!
    @IBOutlet weak var dataColLbl: UILabel!
    @IBOutlet weak var locationCommentLbl: UILabel!
    @IBOutlet weak var projLbl: UILabel!
    @IBOutlet weak var gpsLbl: UILabel!
    @IBOutlet weak var upcLbl: UILabel!
    @IBOutlet weak var sumbitBtn: UIButton!
    @IBOutlet weak var verifyBtn: UIButton!
    @IBOutlet var dataCollectionLabel: UILabel!
    @IBOutlet var projectLabel: UILabel!
    @IBOutlet var productTypeLabel: UILabel!
    @IBOutlet var utilityTypeLabel: UILabel!
    @IBOutlet var upcCodeLabel: UILabel!
    @IBOutlet var gpsLabel: UILabel!
    @IBOutlet var sequenceTextField: UITextField!
    @IBOutlet weak var projectView: UIView?
    @IBOutlet weak var projectInnerView: UIView?
    @IBOutlet var productUrlButton: UIButton!
    @IBOutlet var dataSheetUrlButton: UIButton!
    @IBOutlet var instructionSheetUrlButton: UIButton!
    @IBOutlet var productVideoUrlButton: UIButton!
    
    
    
    let database = DatabaseHandler()
    var templateId: String = ""
    var templateTypeId: String = ""
    var projectId: String = ""
    var UpcCodeArray: NSArray = []
    var locationManager = CLLocationManager()
    var userProfileId:String = ""
    var installerCompanyId:String = ""
    var storage:String = ""
    var projectInnerViewYposition:CGFloat!
    

    var lattitudeDouble:Double = 0.0
    var longitudeDouble:Double = 0.0
    var utilityCompanyId:String = ""
    
    
    var labelArray1 = NSArray()
    var rightArray1 = NSArray()

    @IBOutlet var projectTextField: UITextField!
    var currentTextField: UITextField!
    var vwGMap = GMSMapView()
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var currentLocationSwitch: UISwitch!
    var bottomPadding:CGFloat = 0.0
    var navBarHeight: CGFloat = 0

    

    func changeLanguage(){
        
        self.title = NSLocalizedString("EMS Passive / Path / Cable depth", comment: "EMS Passive / Path / Cable depth")
        DispatchQueue.main.async {
            self.canInnerBtn.setAttributedTitle(nil, for: UIControlState.normal)
            self.subInnerBtn.setAttributedTitle(nil, for: UIControlState.normal)
            self.sumbitBtn.setAttributedTitle(nil, for: UIControlState.normal)
            self.verifyBtn.setAttributedTitle(nil, for: UIControlState.normal)
            self.sumbitBtn.setTitle(NSLocalizedString("SUBMIT", comment: "verify"), for: UIControlState.normal)
            self.verifyBtn.setTitle(NSLocalizedString("VERIFY", comment: "verify"), for: UIControlState.normal)
            self.subInnerBtn.setTitle(NSLocalizedString("SUBMIT", comment: "verify"), for: UIControlState.normal)
            self.canInnerBtn.setTitle(NSLocalizedString("CANCEL", comment: "verify"), for: UIControlState.normal)
            
            self.projInnerLbl.text = NSLocalizedString("Project Name", comment: "")
            self.productLbl.text = NSLocalizedString("Product Type", comment: "GPS Location")
            self.utilityLbl.text = NSLocalizedString("Utility Type", comment: "GPS Location")
            self.dataColLbl.text = NSLocalizedString("Data Collection Template", comment: "GPS Location")
            self.locationCommentLbl.text = NSLocalizedString("Location Comments", comment: "GPS Location")
            self.projLbl.text = NSLocalizedString("Project", comment: "GPS Location")
            self.gpsLbl.text = NSLocalizedString("GPS Location", comment: "GPS Location")
            self.upcLbl.text = NSLocalizedString("UPC Code", comment: "GPS Location")
            
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.changeLanguage()
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationItem.setHidesBackButton(false, animated:false)
        self.locationManager.stopUpdatingLocation()
    }
    
    
    func customBackButton(){
        
        let alert = UIAlertController(title: NSLocalizedString("Cancel EMS Passive?", comment: "Cancel EMS Passive?"), message: NSLocalizedString("Are you sure you want to cancel this EMS passive screen?",comment:"Are you sure you want to cancel this EMS passive screen?"), preferredStyle: UIAlertControllerStyle.alert)
        
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: "Ok"), style: .default, handler: { (action: UIAlertAction!) in
            self.navigationController?.popViewController(animated: true)
        }))
        
        alert.addAction(UIAlertAction(title:NSLocalizedString("Cancel", comment: "Cancel") , style: .cancel, handler: { (action: UIAlertAction!) in
            
        }))
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.changeLanguage()
        
        // Do any additional setup after loading the view.
        
        navBarHeight = UIApplication.shared.statusBarFrame.height + self.navigationController!.navigationBar.frame.height


        
        let iconSize = CGRect(origin: CGPoint.zero, size: CGSize(width: 21, height: 44))
        let backButton = UIButton(frame: iconSize)
        backButton.setImage(UIImage(named: "customBackArrow1.png"), for: .normal)
        backButton.addTarget(self, action: #selector(self.customBackButton), for: .touchUpInside)
        backButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        
        
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(self.dataCollectionClicked))
        dataCollectionLabel.addGestureRecognizer(tap1)
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(self.projectDropdownClicked))
        projectLabel.addGestureRecognizer(tap2)
        
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(self.productTypeDropdownClicked))
        productTypeLabel.addGestureRecognizer(tap3)
        
        let tap4 = UITapGestureRecognizer(target: self, action: #selector(self.utilityTypeDropdownClicked))
        utilityTypeLabel.addGestureRecognizer(tap4)
        
        
        currentTextField = projectTextField
        
        
        
        utilityCompanyId = UserDefaults.standard.value(forKey: "utilityCompanyId") as! String
        userProfileId = UserDefaults.standard.value(forKey: "userProfileId") as! String
        installerCompanyId = database.getUserProfile(columnName: "installerCompanyID")
        
        
        storage = database.getSettings(columnName: "Storage")
        
        
        
        
        productUrlButton.imageView?.contentMode = .scaleAspectFit

   

        let camera: GMSCameraPosition = GMSCameraPosition.camera(withLatitude: 0, longitude: 0, zoom: 15.0)
        vwGMap = GMSMapView.map(withFrame:  CGRect(x: 0, y: 0, width: self.view.frame.size.width - 40, height: 300), camera: camera)
        vwGMap.camera = camera
        // Add GMSMapView to current view
        self.mapView .addSubview(vwGMap)
        vwGMap.delegate = self
        vwGMap.settings.compassButton = true
        vwGMap.isMyLocationEnabled = true
        vwGMap.mapType = kGMSTypeHybrid
        vwGMap.settings.myLocationButton = true
        
    }
    override func viewDidAppear(_ animated: Bool) {
        
        self.navigationItem.setHidesBackButton(true, animated:false)
        projectInnerViewYposition = self.projectInnerView?.frame.origin.y
        TealiumHelper.sharedInstance().trackView(title: "EMS Passive", data: [:])
        self.determineMyCurrentLocation()
        
        if #available(iOS 11.0, *) {
            bottomPadding = view.safeAreaInsets.bottom
            print(bottomPadding)
            
        }
        
    }
    
    func determineMyCurrentLocation() {
        
        if(currentLocationSwitch.isOn){
            self.locationManager.requestWhenInUseAuthorization()
            if CLLocationManager.locationServicesEnabled() {
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.distanceFilter = 1
                locationManager.startUpdatingLocation()
            }
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
    
    func productTypeDropdownClicked(sender: UIButton)
    {
        if projectLabel.text!.isEmpty {
            showAlert("", message: NSLocalizedString("Please select project", comment: "Please select project"))
        }
        else
        {
            let viewController = UIStoryboard(name: "Custom", bundle: nil).instantiateViewController(withIdentifier: "SearchBarViewController") as! SearchBarViewController
            
            let productTypeArray:NSArray = database .getProductCatalogue(recordTypeID: "2")
            viewController.delegate = self
            viewController.companyArray = productTypeArray
            viewController.utilityCompanyIdArray = productTypeArray
            viewController.titleString = NSLocalizedString("Select Product Type", comment: "Select Product Type")
            self.navigationController!.pushViewController(viewController, animated: true)
            
        }
    }
    
    
    
    func utilityTypeDropdownClicked(sender: UIButton)
    {
        if projectLabel.text!.isEmpty {
            showAlert("", message: NSLocalizedString("Please select project", comment: "Please select project"))
        }
        else if productTypeLabel.text!.isEmpty {
            showAlert("", message:NSLocalizedString("Please select product type", comment: "Please select product type") )
        }
        else
        {
            let viewController = UIStoryboard(name: "Custom", bundle: nil).instantiateViewController(withIdentifier: "SearchBarViewController") as! SearchBarViewController
            let utiliyTypeArray:NSArray = database .getSubProductCategory(recordTypeID: "2", productCategory: productTypeLabel.text!)
            viewController.delegate = self
            viewController.companyArray = utiliyTypeArray
            viewController.utilityCompanyIdArray = utiliyTypeArray
            viewController.titleString = NSLocalizedString("Select Utility Type", comment: "Select Utility Type")
            self.navigationController!.pushViewController(viewController, animated: true)
        }
    }
    
    func hideURL(){
        productUrlButton.isHidden = true
        dataSheetUrlButton.isHidden = true
        instructionSheetUrlButton.isHidden = true
        productVideoUrlButton.isHidden = true
    }
    
    func getUpcCode(){
        UpcCodeArray = database .getUpcCode(productCategory: productTypeLabel.text!, subProductCategory: utilityTypeLabel.text!, recordTypeID: "2")
        
        print(UpcCodeArray)
        
        let productURL:String = UpcCodeArray .object(at: 0) as! String
        let dataSheetURL:String = UpcCodeArray .object(at: 1) as! String
        let instructionSheetURL:String = UpcCodeArray .object(at: 2) as! String
        let productVideoURL:String = UpcCodeArray .object(at: 3) as! String
        let record:String = UpcCodeArray .object(at: 5) as! String

        if !(productURL .isEmpty) {
            productUrlButton.isHidden = false
        }
        if !(dataSheetURL .isEmpty) {
            dataSheetUrlButton.isHidden = false
        }
        if !(instructionSheetURL .isEmpty) {
            instructionSheetUrlButton.isHidden = false
        }
        if !(productVideoURL .isEmpty) {
            productVideoUrlButton.isHidden = false
        }
        upcCodeLabel.text = UpcCodeArray .object(at: 4) as? String
        
        
        if (record .isEmpty){
            showAlert("", message: NSLocalizedString("No product available", comment: "No product available"))
        }
        
        
        
        
    }
    
    @IBAction func urlButtonClicked(sender: UIButton) {
        currentTextField.resignFirstResponder()
        
        let viewController = UIStoryboard(name: "Custom", bundle: nil).instantiateViewController(withIdentifier: "WebViewViewController") as! WebViewViewController
        viewController.urlString = UpcCodeArray .object(at: sender.tag) as! String
        self.navigationController!.pushViewController(viewController, animated: true)
        
    }
    
    
    func dataCollectionClicked(sender: UIButton)
    {
        
        let viewController = UIStoryboard(name: "Custom", bundle: nil).instantiateViewController(withIdentifier: "SearchBarViewController") as! SearchBarViewController
        viewController.delegate = self
        viewController.companyArray = database .getTemplateName(TemplateTypeId: "2")
        viewController.utilityCompanyIdArray = database .getTemplateName(TemplateTypeId: "2")
        viewController.titleString = NSLocalizedString("Select Template", comment: "Select Template")
        
        self.navigationController!.pushViewController(viewController, animated: true)
    }
    
    func selectedValue(company: String,utilityCompanyId: String,titleString: String){
        
        if titleString == NSLocalizedString("Select Project", comment: "Select Project") {
            
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
        else if titleString == NSLocalizedString("Select Product Type", comment: "Select Product Type") {
            productTypeLabel.text = company
            utilityTypeLabel.text = ""
            upcCodeLabel.text = ""
            self.hideURL()
        }
        else if titleString == NSLocalizedString("Select Utility Type", comment: "Select Utility Type") {
            utilityTypeLabel.text = company
            self.hideURL()
            self .getUpcCode()
        }
        else if titleString == NSLocalizedString("Select Template", comment: "Select Template") {
            let selectedValue:String = company
            
            
            templateId = database .getTemplateId(TemplateName: selectedValue) .object(at: 0) as! String
            templateTypeId = database .getTemplateId(TemplateName: selectedValue) .object(at: 1) as! String
            
            
            let templateDetailsArray:NSArray = database .getLabelDescriptionArray1(TemplateId: templateId)
            let labelArray = templateDetailsArray .object(at: 0) as! NSArray
            let descriptionArray = templateDetailsArray .object(at: 1) as! NSArray
            let dropDownArray = templateDetailsArray .object(at: 2) as! NSArray
            
            
            DispatchQueue.main.async {
                let viewController = self.storyboard!.instantiateViewController(withIdentifier: "DataCollectionViewController") as! DataCollectionViewController
                
                viewController.delegate = self
                viewController.templateNameString = selectedValue
                viewController.labelArray = labelArray
                viewController.rightArray = descriptionArray as! NSMutableArray
                viewController.dropDownArray = dropDownArray
                self.navigationController!.pushViewController(viewController, animated: false)
                
                
            }
        }
        
        
    }
    
    
    
    
    
    
    
    
    //pragma mark - textField Delegate row lifecycle
    
    func textFieldDidBeginEditing(_ textField: UITextField) { // became first responder
        
        currentTextField = textField
        
        //move textfields up
        let myScreenRect: CGRect = UIScreen.main.bounds
        let keyboardHeight : CGFloat = 300 + bottomPadding
        

        UIView.beginAnimations( "animateView", context: nil)
        let movementDuration:TimeInterval = 0.35
        
        
        var needToMove: CGFloat = -navBarHeight
        
        var frame : CGRect = self.view.frame
        
        
        if (textField.frame.origin.y + textField.frame.size.height +
            /*self.navigationController.navigationBar.frame.size.height + */
            UIApplication.shared.statusBarFrame.size.height + bottomPadding > (myScreenRect.size.height - keyboardHeight)) {
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
        currentTextField .resignFirstResponder()
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
            currentTextField .resignFirstResponder()
            
            showActivityIndicator(false)
            
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
                        hideActivityIndicator()
                    }
                    if let data = data {
                        do{
                            
                            
                            let jsonData =  try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary
                            
                            let status =  jsonData?["status"] as! String
                            
                            
                            DispatchQueue.main.async {
                                hideActivityIndicator()
                                
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
                                    
                                    let alert = UIAlertController(title: "", message:NSLocalizedString("Project added successfully", comment: "Project added successfully") , preferredStyle: UIAlertControllerStyle.alert)
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
    
    
    @IBAction func verifyButtonClicked(){
        currentTextField.resignFirstResponder()
        
        let viewController = self.storyboard!.instantiateViewController(withIdentifier: "GoogleMapViewController") as! GoogleMapViewController
        viewController.delegate = self
        viewController.latitude = lattitudeDouble
        viewController.longitude = longitudeDouble
        self.navigationController!.pushViewController(viewController, animated: true)
    }
    
    
    
    
    func selectedLocation(lattitude: Double, longitude:Double){
        gpsLabel.text = String(format:"%f, %f", lattitude, longitude)
        lattitudeDouble = lattitude
        longitudeDouble = longitude
        currentLocationSwitch.setOn(false, animated: false)
    }
    
    func validateData() -> Bool {
        
        
        var alertMessage = kEmptyString
        if projectLabel.text!.isEmpty {
            alertMessage.append(NSLocalizedString("Please select project", comment: "Please select project"))
        }
        else if productTypeLabel.text!.isEmpty {
            alertMessage.append(NSLocalizedString("Please select product type", comment: "Please select product type"))
        }
        else if utilityTypeLabel.text!.isEmpty {
            alertMessage.append(NSLocalizedString("Please select utility type", comment: "Please select utility type"))
        }
        
        
        if alertMessage.isEmpty {
            return true
        }
        
        showAlert(kEmptyString, message: alertMessage)
        
        
        return false
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    func sendtblLogDataDetails(labelArray: NSArray, rightArray: NSArray, templateName: String){
        
        labelArray1 = []
        rightArray1 = []
        
        if(labelArray.count == 0){
            dataCollectionLabel.text = ""
        }
        else{
            labelArray1 = labelArray
            rightArray1 = rightArray
            dataCollectionLabel.text = templateName
            
        }
        
        
        print(rightArray1)
    }
    
    
    
    
    @IBAction func submitButtonClicked(){
        
        currentTextField.resignFirstResponder()
        
        if validateData() {
            
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
        }
        
        
        
        
        
        func successMessage(Message:String){
            
            let message = NSLocalizedString(Message, comment: Message)
            let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: "Ok"), style: .default, handler: { (action: UIAlertAction!) in
                self.navigationController?.popViewController(animated: true)
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
        
        
        let tblLogData: [String : Any] = ["recordTypeId" : "2",
                                          "utilityCompanyId" : utilityCompanyId,
                                          "installerCompanyId": installerCompanyId,
                                          "upcCode" : upcCodeLabel.text!,
                                          "latitude" : lattitudeDouble,
                                          "longtitude" : longitudeDouble,
                                          "projectId" : projectId,
                                          "projectName" : projectLabel.text!,
                                          "seqNumber" : sequenceTextField.text!,
                                          "userProfileId" : userProfileId] as [String : Any]
        
        
        
        self.database .insertLogData(array: [tblLogData])
    }
    
    
    func insrtlogDataDetailsToLocalDB(){
        
        
        let logDataId:String = self.database.getLogData() .object(at: 0) as! String
        let createdDate:String = self.database.getLogData() .object(at: 1) as! String
        print(logDataId)
        
        
        var tblLogDataDetails = [[String: Any]]()
        
        
        for i in 0 ..< labelArray1.count {
            
            
            
            let labelString:String = labelArray1 .object(at: i) as! String
            
            
            var imagePath:String = ""
            
            var newDescription:String = ""
            
            
            let Description:String = rightArray1 .object(at: i) as! String
            
            
            if(String(Description.characters.prefix(6)) == "~img~_"){
                imagePath = Description
                newDescription = "Image"
            }
            else
            {
                newDescription = Description
            }
            
            
            var tempDetails:[String : Any]
            
            let lblArray:NSArray = database .getPredefinedLabel(LabelName: labelString)
            
            
            
            
            if  lblArray.count != 0 {
                let labelId:String = lblArray .object(at: 0) as! String
                let dataTypeId:String = lblArray .object(at: 1) as! String
                let descriptionId:String = database .getDescriptionId(DescriptionName: newDescription)
                
                
                
                
                if descriptionId == "" {
                    tempDetails = ["label": labelString,
                                   "logDataId": logDataId,
                                   "labelId": labelId,
                                   "description": newDescription,
                                   "templateTypeId": templateTypeId,
                                   "createdDate": createdDate,
                                   "dataTypeId":dataTypeId] as [String : Any]
                }
                else
                {
                    tempDetails = ["logDataId": logDataId,
                                   "labelId": labelId,
                                   "templateTypeId": templateTypeId,
                                   "label": labelString,
                                   "descriptionId": descriptionId,
                                   "description": newDescription,
                                   "createdDate": createdDate,
                                   "dataTypeId":dataTypeId] as [String : Any]
                    
                }
                
            }
            else
            {
                tempDetails = ["logDataId": logDataId,
                               "label": labelString,
                               "description": newDescription,
                               "createdDate": createdDate,
                               "templateTypeId": templateTypeId] as [String : Any]
                
            }
            
            
            
            
            if (imagePath != ""){
                tempDetails["imagePath"] = imagePath
            }
            
            
            tblLogDataDetails.append(tempDetails)
            
            
            
        }
        
        
        if tblLogDataDetails.count != 0{
            database .insertLogDataDetails(array: tblLogDataDetails as NSArray)
        }
        
        
    }
    
    
    
    func performSyncApptoCloud()
    {
        print("test2")
        
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
    
    
    
    
 

    
    
    
    //    MARK: - CLLocationManagerDelegate Methods
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        
        
        let userLocation = locations.last
        lattitudeDouble = userLocation!.coordinate.latitude
        longitudeDouble = userLocation!.coordinate.longitude
        
        print(lattitudeDouble,longitudeDouble)
        
        DispatchQueue.main.async {
            self.gpsLabel.text = String(format:"%f, %f", userLocation!.coordinate.latitude, userLocation!.coordinate.longitude)
        }

        
        if vwGMap.camera.target.latitude == 0 && vwGMap.camera.target.longitude == 0 {
            let camera = GMSCameraPosition.camera(withLatitude: userLocation!.coordinate.latitude,
                                                  longitude: userLocation!.coordinate.longitude,
                                                  zoom: 15)
            mapView.isHidden = false
            vwGMap.camera = camera
        }
        
        
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
    
    @IBAction func switchChanged(mySwitch: UISwitch) {
        let value = mySwitch.isOn
        print(value)
        if(mySwitch.isOn){
            locationManager.startUpdatingLocation()
        }
        else{
            locationManager.stopUpdatingLocation()
        }
    }
    
    
    
  
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

