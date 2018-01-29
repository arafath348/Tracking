//
//  EmsPassiveViewController.swift
//  3M L&M
//
//  Created by IndianRenters on 22/08/17.
//  Copyright © 2017 3M L&M. All rights reserved.
//

import UIKit
import CoreLocation

class RFIDViewController: UIViewController,SearchBarDelegate,CLLocationManagerDelegate,LocationDelegate, tblRFIDLogDataDetailsDelegate, tblLogDataDetailsDelegate{
    //For Localization
    //Innerview***
    @IBOutlet weak var projNameLbl: UILabel!
    
    @IBOutlet weak var canInnerBtn: UIButton!
    @IBOutlet weak var subInnerBtn: UIButton!
    //***
    @IBOutlet weak var SumbitBtn: UIButton!
    @IBOutlet weak var gpslocLbl: UILabel!
    @IBOutlet weak var dataColLbl: UILabel!
    @IBOutlet weak var rfidTempLbl: UILabel!
    @IBOutlet weak var rfidSerialLbl: UILabel!
    @IBOutlet weak var upcLbl: UILabel!
    @IBOutlet weak var productLbl: UILabel!
    @IBOutlet weak var prjLbl: UILabel!
    @IBOutlet weak var utilityLbl: UILabel!
    @IBOutlet weak var verifyBtn: UIButton!
    //______
    
    @IBOutlet var RFIDView: UIView!
    @IBOutlet var dataCollectionLabel: UILabel!
    @IBOutlet var projectLabel: UILabel!
    @IBOutlet var productTypeLabel: UILabel!
    @IBOutlet var utilityTypeLabel: UILabel!
    @IBOutlet var upcCodeLabel: UILabel!
    @IBOutlet var RFIDSerialNoLabel: UILabel!
    @IBOutlet var gpsLabel: UILabel!
    @IBOutlet var rfidTemplateLabel: UILabel!
    @IBOutlet var productUrlButton: UIButton!
    @IBOutlet var dataSheetUrlButton: UIButton!
    @IBOutlet var instructionSheetUrlButton: UIButton!
    @IBOutlet var productVideoUrlButton: UIButton!
    @IBOutlet weak var projectView: UIView?
    @IBOutlet weak var projectInnerView: UIView?
    var projectInnerViewYposition:CGFloat!
    
    
    let database = DatabaseHandler()
    var rfidTemplateTypeId: String = "1"
    var dataCollectionTemplateTypeId: String = "2"
    
    var projectId: String = ""
    var UpcCodeArray: NSArray = []
    var locationManager = CLLocationManager()
    var userProfileId:String = ""
    var installerCompanyId:String = ""
    
    
    var lattitudeDouble:Double = 0.0
    var longitudeDouble:Double = 0.0
    var utilityCompanyId:String = ""
    var storage:String = ""
    
    var dataLabelArray = NSArray()
    var dataDescriptionArray = NSArray()
    
    
    var rfidLabelArray = NSArray()
    var rfidDescriptionArray = NSArray()
    
    let recordTypeID:String = "1"
    var rfidBytesArray : [UInt8] = []
    
    
    var  canStoreDataToCloud:String = ""
    var  utilityCompanyVerifiedState:String = ""
    
    
    @IBOutlet var projectTextField: UITextField!
    var currentTextField: UITextField!
    
    func changeLanguage(){
        self.title = NSLocalizedString("Data Capture - RFID", comment: "Data Capture")
        DispatchQueue.main.async {
            
            self.projNameLbl.text = NSLocalizedString("Project Name", comment: "Project Name")
            self.canInnerBtn.setAttributedTitle(nil, for: UIControlState.normal)
            self.subInnerBtn.setAttributedTitle(nil, for: UIControlState.normal)
            self.SumbitBtn.setAttributedTitle(nil, for: UIControlState.normal)
            self.verifyBtn.setAttributedTitle(nil, for: UIControlState.normal)
            
            self.canInnerBtn.setTitle(NSLocalizedString("CANCEL", comment: "CANCEL"), for: UIControlState.normal)
            self.subInnerBtn.setTitle(NSLocalizedString("SUBMIT", comment: "SUBMIT"), for: UIControlState.normal)
            self.SumbitBtn.setTitle(NSLocalizedString("SUBMIT", comment: "SUBMIT"), for: UIControlState.normal)
            self.verifyBtn.setTitle(NSLocalizedString("VERIFY", comment: "verify"), for: UIControlState.normal)
            
            
            self.gpslocLbl.text = NSLocalizedString("GPS Location", comment: "GPS Location")
            self.dataColLbl.text = NSLocalizedString("Data Collection Template", comment: "Data Collection Template")
            
            
            self.rfidTempLbl.text = NSLocalizedString("RFID Data Template", comment: "RFID Data Template")
            
            self.rfidSerialLbl.text = NSLocalizedString("RFID Serial Number", comment: "rfid")
            
            
            self.upcLbl.text = NSLocalizedString("UPC Code", comment: "UPC Code")
            
            
            self.productLbl.text = NSLocalizedString("Product Type", comment: "Product")
            
            
            self.prjLbl.text = NSLocalizedString("Project", comment: "Project")
            
            
            self.utilityLbl.text = NSLocalizedString("Utility Type", comment: "utilityLbl")
            
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.changeLanguage()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationItem.setHidesBackButton(true, animated:false)
        projectInnerViewYposition = self.projectInnerView?.frame.origin.y
        //TealiumHelper.trackView(NSStringFromClass(self.classForCoder), dataSources: [:])
        
        
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationItem.setHidesBackButton(false, animated:false)
    }
    
    
    func customBackButton(){
        
        let alert = UIAlertController(title:NSLocalizedString("Cancel RFID?", comment: "Cancel RFID?") , message: NSLocalizedString("Are you sure you want to cancel this RFID screen?", comment: "Are you sure you want to cancel this RFID screen?"), preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: "Ok"), style: .default, handler: { (action: UIAlertAction!) in
            self.navigationController?.popViewController(animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .cancel, handler: { (action: UIAlertAction!) in
            
        }))
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.changeLanguage()
        
        // Do any additional setup after loading the view.
        
        
        canStoreDataToCloud = database.getUserProfile(columnName: "canStoreDataToCloud")
        utilityCompanyVerifiedState = database.getUtilityCompany(columnName: "verified")
        
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
        
        
        let tap5 = UITapGestureRecognizer(target: self, action: #selector(self.rfidTemplateClicked))
        rfidTemplateLabel.addGestureRecognizer(tap5)
        
        let tap6 = UITapGestureRecognizer(target: self, action: #selector(self.rfidSerialClicked))
        RFIDSerialNoLabel.addGestureRecognizer(tap6)
        
        
        currentTextField = projectTextField
        
        
        
        utilityCompanyId = UserDefaults.standard.value(forKey: "utilityCompanyId") as! String
        userProfileId = UserDefaults.standard.value(forKey: "userProfileId") as! String
        installerCompanyId = database.getUserProfile(columnName: "installerCompanyID")
        
        
        
        
        storage = database.getSettings(columnName: "Storage")
        
        self.determineMyCurrentLocation()
        
        productUrlButton.imageView?.contentMode = .scaleAspectFit

        
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
            
            let productTypeArray:NSArray = database .getProductCatalogue(recordTypeID: recordTypeID)
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
            showAlert("", message: NSLocalizedString("Please select product type", comment: "Please select product type"))
        }
        else
        {
            let viewController = UIStoryboard(name: "Custom", bundle: nil).instantiateViewController(withIdentifier: "SearchBarViewController") as! SearchBarViewController
            let utiliyTypeArray:NSArray = database .getSubProductCategory(recordTypeID: recordTypeID, productCategory: productTypeLabel.text!)
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
        UpcCodeArray = database .getUpcCode(productCategory: productTypeLabel.text!, subProductCategory: utilityTypeLabel.text!, recordTypeID: "1")
        
        
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
    
    
    
    
    func rfidSerialClicked(sender: UIButton){
        
        
        let barcodeScanner = self.storyboard!.instantiateViewController(withIdentifier: "BarcodeScannerViewController") as! BarcodeScannerViewController
        
        // Define the callback which is executed when the barcode has been scanned
        barcodeScanner.barcodeScanned = { (barcode:String) in
            
            // When the screen is tapped, return to first view (barcode is beeing passed as param)
            print("Received following barcode: \(barcode)")
            
            DispatchQueue.main.async {
                self.RFIDSerialNoLabel.text = "\(barcode)"
            }
        }
        
        
        self.navigationController!.pushViewController(barcodeScanner, animated: true)
        
        
        
        
        
        
    }
    
    
    
    
    
    func rfidTemplateClicked(sender: UIButton)
    {
        
        if validateData() {
            
            let viewController = UIStoryboard(name: "Custom", bundle: nil).instantiateViewController(withIdentifier: "SearchBarViewController") as! SearchBarViewController
            viewController.delegate = self
            viewController.companyArray = database .getTemplateName(TemplateTypeId: rfidTemplateTypeId)
            viewController.utilityCompanyIdArray = database .getTemplateName(TemplateTypeId: rfidTemplateTypeId)
            viewController.titleString = NSLocalizedString("Select RFID Template", comment: "Select RFID Template")
            self.navigationController!.pushViewController(viewController, animated: true)
        }
        
    }
    
    func dataCollectionClicked(sender: UIButton)
    {
        let viewController = UIStoryboard(name: "Custom", bundle: nil).instantiateViewController(withIdentifier: "SearchBarViewController") as! SearchBarViewController
        viewController.delegate = self
        viewController.companyArray = database .getTemplateName(TemplateTypeId: dataCollectionTemplateTypeId)
        viewController.utilityCompanyIdArray = database .getTemplateName(TemplateTypeId: dataCollectionTemplateTypeId)
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
            
            
            let templateId:String = database .getTemplateId(TemplateName: selectedValue) .object(at: 0) as! String
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
            
        else if titleString == NSLocalizedString("Select RFID Template", comment: "Select RFID Template")
        {
            let selectedValue:String = company
            
            
            
            let templateId:String = database .getTemplateId(TemplateName: selectedValue) .object(at: 0) as! String
            
            let templateDetailsArray:NSArray = database .getLabelDescriptionArray1(TemplateId: templateId)
            let labelArray = templateDetailsArray .object(at: 0) as! NSArray
            let descriptionArray = templateDetailsArray .object(at: 1) as! NSArray
            let dropDownArray = templateDetailsArray .object(at: 2) as! NSArray
            let  utilityTypeId:Int = self.database.getUtilityCompanyType(utilityCompanyTypeDesc: self.utilityTypeLabel.text!)
            
            
            DispatchQueue.main.async {
                let viewController = self.storyboard!.instantiateViewController(withIdentifier: "RfidDataDetailsViewController") as! RfidDataDetailsViewController
                
                viewController.delegate = self
                viewController.templateNameString = selectedValue
                viewController.labelArray = labelArray as! NSMutableArray
                viewController.rightArray = descriptionArray as! NSMutableArray
                viewController.dropDownArray = dropDownArray as! NSMutableArray
                viewController.freq = String(utilityTypeId - 1)
                
                
                
                
                self.navigationController!.pushViewController(viewController, animated: false)
                
                
                
                
            }
        }
    }
    
    
    
    
    
    
    
    
    //pragma mark - textField Delegate row lifecycle
    
    func textFieldDidBeginEditing(_ textField: UITextField) { // became first responder
        
        currentTextField = textField
        
        //move textfields up
        let myScreenRect: CGRect = UIScreen.main.bounds
        let keyboardHeight : CGFloat = 300
        
        
        UIView.beginAnimations( "animateView", context: nil)
        let movementDuration:TimeInterval = 0.35
        
        
        var needToMove: CGFloat = -64
        
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
            frame.origin.y = 64
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
                            print(jsonData)
                            
                            
                            
                            
                            
                            
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
                                    
                                    
                                    let alert = UIAlertController(title: "", message: NSLocalizedString("Project added successfully", comment: "Project added successfully"), preferredStyle: UIAlertControllerStyle.alert)
                                    alert.addAction(UIAlertAction(title:NSLocalizedString("Ok", comment: "Ok") , style: .default, handler: { (action: UIAlertAction!) in
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
        self.navigationController!.pushViewController(viewController, animated: true)
    }
    
    
    
    
    func selectedLocation(lattitude: Double, longitude:Double){
        
        gpsLabel.text = String(format:"%f, %f", lattitude, longitude)
        lattitudeDouble = lattitude
        longitudeDouble = longitude
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
    
    
    
    
    //    func sendRFIDtblLogDataDetails(labelArray: NSArray, rightArray: NSArray, templateName: String)
    //    {
    //
    //
    //        rfidLabelArray = []
    //        rfidDescriptionArray = []
    //
    //        if(labelArray.count == 0){
    //            rfidTemplateLabel.text = ""
    //        }
    //        else{
    //            rfidLabelArray = labelArray
    //            rfidDescriptionArray = rightArray
    //            rfidTemplateLabel.text = templateName
    //        }
    //    }
    //
    //
    
    
    func sendRFIDtblLogDataDetails(bytesArray: [UInt8], templateName: String)  {
        
        rfidLabelArray = []
        rfidDescriptionArray = []
        
        
        print(bytesArray)
        print(bytesArray.count)
        
        
        if(bytesArray.count == 0){
            rfidTemplateLabel.text = ""
            rfidBytesArray = []
        }
        else{
            rfidBytesArray = bytesArray
            rfidTemplateLabel.text = templateName
        }
    }
    
    
    
    func sendtblLogDataDetails(labelArray: NSArray, rightArray: NSArray, templateName: String){
        
        dataLabelArray = []
        dataDescriptionArray = []
        
        if(labelArray.count == 0){
            dataCollectionLabel.text = ""
        }
        else{
            dataLabelArray = labelArray
            dataDescriptionArray = rightArray
            dataCollectionLabel.text = templateName
        }
        
    }
    
    
    
    
    
    
    
    
    @IBAction func submitButtonClicked(){
        
        currentTextField.resignFirstResponder()
        
        if validateData() {
            
            let  canStoreDataToCloud:String = database.getUserProfile(columnName: "canStoreDataToCloud")
            let utilityCompanyVerifiedState:String = database.getUtilityCompany(columnName: "verified")
            
            
            
            if(rfidBytesArray.count != 0){
                
                let tblLogData: [String : Any] = ["recordTypeId" : recordTypeID,
                                                  "utilityCompanyId" : utilityCompanyId,
                                                  "installerCompanyId": installerCompanyId,
                                                  "upcCode" : upcCodeLabel.text!,
                                                  "latitude" : lattitudeDouble,
                                                  "longtitude" : longitudeDouble,
                                                  "projectId" : projectId,
                                                  "projectName" : projectLabel.text!,
                                                  "RFIDSerialNumber" : RFIDSerialNoLabel.text!,
                                                  "userProfileId" : userProfileId] as [String : Any]
                
                
                
                
                let viewController = UIStoryboard(name: "Airconsole", bundle: nil).instantiateViewController(withIdentifier: "DeviceListViewController") as! DeviceListViewController
                viewController.tblLogData = tblLogData
                viewController.dataLabelArray = dataLabelArray
                viewController.dataDescriptionArray = dataDescriptionArray
                viewController.rfidBytesArray = rfidBytesArray
                
                self.navigationController!.pushViewController(viewController, animated: true)
                
            }
            else if canStoreDataToCloud != "Y" || utilityCompanyVerifiedState != "Y"{
                
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
        self .insrtLogDataDetailsToLocalDB(labelArray: dataLabelArray, descriptonArray: dataDescriptionArray, TemplateTypeId: dataCollectionTemplateTypeId)
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
        let tblLogData: [String : Any] = ["recordTypeId" : recordTypeID,
                                          "utilityCompanyId" : utilityCompanyId,
                                          "installerCompanyId": installerCompanyId,
                                          "upcCode" : upcCodeLabel.text!,
                                          "latitude" : lattitudeDouble,
                                          "longtitude" : longitudeDouble,
                                          "projectId" : projectId,
                                          "projectName" : projectLabel.text!,
                                          "RFIDSerialNumber" : RFIDSerialNoLabel.text!,
                                          "userProfileId" : userProfileId] as [String : Any]
        
        
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
                                   "descriptionId": descriptionId,
                                   "templateTypeId": TemplateTypeId,
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
        
        lattitudeDouble = userLocation.coordinate.latitude
        longitudeDouble = userLocation.coordinate.longitude
        
        
        gpsLabel.text = String(format:"%f, %f", userLocation.coordinate.latitude, userLocation.coordinate.longitude)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
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

