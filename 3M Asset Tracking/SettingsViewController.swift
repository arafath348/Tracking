//
//  SettingsViewController.swift
//  3M L&M
//
//  Created by IndianRenters on 24/07/17.
//  Copyright © 2017 3M L&M. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,PopupDelegate,SearchBarDelegate,UIPickerViewDelegate,UIPickerViewDataSource  {
    
    
    //For localization
    @IBOutlet weak var assoCanBtn: UIButton!
    @IBOutlet weak var assoSubBtn: UIButton!
    @IBOutlet weak var assoUtilcomLbl: UILabel!
    @IBOutlet weak var inscompanyNameLbl: UILabel!
    
    @IBOutlet weak var insFirstNameLbl: UILabel!
    
    @IBOutlet weak var insLastNameLbl: UILabel!
    
    @IBOutlet weak var insprimaryContactNoLbl: UILabel!
    @IBOutlet weak var insEmailLbl: UILabel!
    @IBOutlet weak var insaddBtn: UIButton!
    
    @IBOutlet weak var inscancelBtn: UIButton!
    
    //UtilityCOView
    @IBOutlet weak var utilcompanyNameLbl: UILabel!
    
    @IBOutlet weak var utilFirstNameLbl: UILabel!
    
    @IBOutlet weak var utilLastNameLbl: UILabel!
    
    @IBOutlet weak var utilprimaryContactNoLbl: UILabel!
    @IBOutlet weak var utilEmailLbl: UILabel!
    @IBOutlet weak var utiladdBtn: UIButton!
    
    @IBOutlet weak var utilcancelBtn: UIButton!
    
    @IBOutlet weak var utilCoTypeLbl: UILabel!
    
    
    @IBOutlet weak var popCancelBtn: UIButton!
    //---------
    var settingsArray: NSArray = []
    var companyArray: NSArray = []
    
    var selectedArray: NSMutableArray = []
    
    
    var imageArray: NSArray = []
    var barcodeArray: NSArray = []
    var dataStorageArray: NSArray = []
    var gpsArray: NSArray = []
    
    var popupArray: NSArray = []
    
    
    var row: Int = 0
    @IBOutlet weak var table: UITableView?
    @IBOutlet weak var popupView: UIView?
    @IBOutlet weak var companyView: UIView?
    @IBOutlet weak var companyInnerView: UIView?
    @IBOutlet weak var installerCompanyView: UIView?
    @IBOutlet weak var installerCompanyInnerView: UIView?
    @IBOutlet weak var associateCompanyView: UIView?
    @IBOutlet weak var associateCompanyInnerView: UIView?
    
    
    
    
    //Add company
    @IBOutlet weak var addCompanyTextField: UITextField!
    @IBOutlet weak var addFirstNameTextField: UITextField!
    @IBOutlet weak var addLastNameTextField: UITextField!
    @IBOutlet weak var addcontactNoTextField: UITextField!
    @IBOutlet weak var addemailTextField: UITextField!
    @IBOutlet weak var addCompanyTypeLabel: UILabel!
    
    
    //Add Installer company
    @IBOutlet weak var addInstallerCompanyTextField: UITextField!
    @IBOutlet weak var addInstallerFirstNameTextField: UITextField!
    @IBOutlet weak var addInstallerLastNameTextField: UITextField!
    @IBOutlet weak var addInstallercontactNoTextField: UITextField!
    @IBOutlet weak var addInstalleremailTextField: UITextField!
    
    var currentTextField: UITextField!
    
    @IBOutlet weak var popupTitleLabel: UILabel?
    @IBOutlet weak var popupLabel1: UILabel?
    @IBOutlet weak var popupLabel2: UILabel?
    @IBOutlet weak var radioButton1: UIImageView!
    @IBOutlet weak var radioButton2: UIImageView!
    
    @IBOutlet weak var selectedTextfield: UITextField?
    @IBOutlet weak var dropDownButton: UIButton!
    var utilityCompanyIDString:String = ""
    var utilityCompanyTypeArray: NSArray = []
    var utilityCompanyTypeIdArray: NSArray = []
    var utilityCompanyTypeId: Int = 0
    
    
    var transView:UIView!
    var actionView:UIView!
    var selectedRow = 0;
    var picker = UIPickerView()
    
    
    var companyInnerViewYposition:CGFloat!
    var installerCompanyInnerViewYposition:CGFloat!
    
    @IBOutlet weak var utilityCompanyLabel: UILabel!
    var utilityCompanyID:String = ""
    let database = DatabaseHandler()
    var functionTypeId: String = ""
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        //TealiumHelper.trackView(NSStringFromClass(self.classForCoder), dataSources: [:])
        
    }
    func changeLanguage(){
        
        self.title =  NSLocalizedString("Settings", comment: "Settings")
        settingsArray = [NSLocalizedString("Locator Pairing", comment: "Locator Pairing"),NSLocalizedString("Template Configuration", comment: "Template Configuration"),NSLocalizedString("Barcode Scanner", comment: "Barcode Scanner"),NSLocalizedString("GPS Provider", comment: "GPS Provider"),NSLocalizedString("Language Settings", comment: "Language Settings"),NSLocalizedString("Data Storage", comment: "Data Storage"),NSLocalizedString("Add Utility Company", comment: "Add Utility Company"),NSLocalizedString("Add Installer Company", comment: "Add Installer Company"),NSLocalizedString("Change Primary Function", comment: "Change Primary Function"),NSLocalizedString("Associate Another Company", comment: "Associate Another Company"),NSLocalizedString("Change Password", comment: "Change Password")]
        
        insFirstNameLbl.text = NSLocalizedString("First Name", comment: "")
        insLastNameLbl.text = NSLocalizedString("Last Name", comment: "")
        insprimaryContactNoLbl.text = NSLocalizedString("Primary Phone Number", comment: "")
        insEmailLbl.text = NSLocalizedString("Email", comment: "")
        utilcompanyNameLbl.text = NSLocalizedString("Company Name", comment: "")
        utilFirstNameLbl.text = NSLocalizedString("First Name", comment: "")
        utilLastNameLbl.text = NSLocalizedString("Last Name", comment: "")
        utilprimaryContactNoLbl.text = NSLocalizedString("Primary Phone Number", comment: "")
        utilEmailLbl.text = NSLocalizedString("Email", comment: "")
        utilCoTypeLbl.text = NSLocalizedString("Utility Company Type", comment: "")
        insaddBtn.setTitle(NSLocalizedString("ADD", comment: "Login"), for: UIControlState.normal)
        inscancelBtn.setTitle(NSLocalizedString("CANCEL", comment: "CANCEL"), for: UIControlState.normal)
        utiladdBtn.setTitle(NSLocalizedString("ADD", comment: "Login"), for: UIControlState.normal)
        utilcancelBtn.setTitle(NSLocalizedString("CANCEL", comment: "CANCEL"), for: UIControlState.normal)
        assoCanBtn.setTitle(NSLocalizedString("CANCEL", comment: "CANCEL"), for: UIControlState.normal)
        assoSubBtn.setTitle(NSLocalizedString("SUBMIT", comment: "CANCEL"), for: UIControlState.normal)
        assoUtilcomLbl.text = NSLocalizedString("Utility Company", comment: "")
        //For association
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        self.changeLanguage()
        
        let storage:String = database.getSettings(columnName: "Storage")
        
        let functionTypeID:String = database.getUserProfile(columnName: "functionTypeID")
        var primaryFunction:String = ""
        if (functionTypeID == "1"){
            primaryFunction = NSLocalizedString("RFID Marker / EMS Passive Marker", comment: "")
        }
        else if (functionTypeID == "2"){
            primaryFunction = NSLocalizedString("Cable Accessories", comment: "")
        }
        else{
            primaryFunction = NSLocalizedString("Both", comment: "")
        }
        
        
        
        
        let app:String = database.getLanguageSettings().object(at: 0) as! String
        let glossary:String = database.getLanguageSettings().object(at: 1) as! String
        
        
        let selectedLang:String = String(format:"%@, %@",app,glossary)
        selectedArray = NSMutableArray()
        
        let locStorage = NSLocalizedString(storage, comment: storage)
        
        
        
        
        selectedArray = ["","","","",selectedLang,locStorage,"","",primaryFunction,"",""]
        
        
        self .addNextButton()
        
        companyInnerViewYposition = self.companyInnerView?.frame.origin.y
        installerCompanyInnerViewYposition = self.installerCompanyInnerView?.frame.origin.y
        
        table? .reloadData()
        
    }
    
    
    
    
    func addNextButton() {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                            target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(title: "Next", style: .plain, target:self, action: #selector(self.nextButtonAction))
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        addcontactNoTextField.inputAccessoryView = keyboardToolbar
        addInstallercontactNoTextField.inputAccessoryView = keyboardToolbar
        
    }
    
    
    func nextButtonAction()
    {
        if currentTextField == self.addcontactNoTextField {
            
            if !validatePhoneWithString(addcontactNoTextField.text!){
                showAlert(kEmptyString, message: NSLocalizedString("Please enter a 10 digit valid primary contact number", comment: "Please enter a 10 digit valid primary contact number"))
            }
            else
            {
                self.addemailTextField.becomeFirstResponder()
            }
            
        }
            
            
        else if currentTextField == self.addInstallercontactNoTextField {
            if !validatePhoneWithString(addInstallercontactNoTextField.text!){
                showAlert(kEmptyString, message: NSLocalizedString("Please enter a 10 digit valid primary contact number", comment: "Please enter a 10 digit valid primary contact number"))
            }
            else
            {
                self.addInstalleremailTextField.becomeFirstResponder()
            }
            
        }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        currentTextField = addCompanyTextField
        
        settingsArray = [NSLocalizedString("Locator Pairing", comment: "Locator Pairing"),NSLocalizedString("Template Configuration", comment: "Template Configuration"),NSLocalizedString("Barcode Scanner", comment: "Barcode Scanner"),NSLocalizedString("GPS Provider", comment: "GPS Provider"),NSLocalizedString("Language Settings", comment: "Language Settings"),NSLocalizedString("Data Storage", comment: "Data Storage"),NSLocalizedString("Add Utility Company", comment: "Add Utility Company"),NSLocalizedString("Add Installer Company", comment: "Add Installer Company"),NSLocalizedString("Change Primary Function", comment: "Change Primary Function"),NSLocalizedString("Associate Another Company", comment: "Associate Another Company"),NSLocalizedString("Change Password", comment: "Change Password")]
        imageArray = ["settings_pairing","settings_template","settings_barcode","settings_locator","settings_language", "settings_data_storage","settings_template","settings_barcode","settings_locator","settings_language", "settings_data_storage"]
        
        
        
        
        
        companyInnerView?.layer.cornerRadius = 8
        installerCompanyInnerView?.layer.cornerRadius = 8
        associateCompanyInnerView?.layer.cornerRadius = 8
        
        
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(self.getUtilityCompanyType))
        addCompanyTypeLabel.addGestureRecognizer(tap1)
        
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(self.getUnassociatedCompanyList))
        utilityCompanyLabel.addGestureRecognizer(tap2)
        
        
        
        
        
        
        
        
    }
    
    
    
    
    func selectedValue(company: String,utilityCompanyId: String,titleString: String){
        
        
        
        
        
        if titleString == "Select Utility Company"{
            utilityCompanyLabel.text = company
            utilityCompanyID = utilityCompanyId
            
        }
        else
        {
            utilityCompanyIDString = utilityCompanyId
            installerCompanyView?.isHidden = false
        }
        
        
    }
    
    
    
    
    
    @IBAction func submitAssociateCompanyButtonClicked()
    {
        
        
        
        if (utilityCompanyLabel.text! .isEmpty) {
            showAlert(kEmptyString, message:NSLocalizedString("Please select utility company", comment: "Please select utility company") )
        }
        else
        {
            showActivityIndicator(false)
            
            let session = URLSession.shared
            
            let url = String(format:"%@user/associate-company",kUrlBase)
            let request = NSMutableURLRequest(url: NSURL(string: url)! as URL)
            
            request.httpMethod = "POST"
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            
            let installerCompanyID:String = database.getUserProfile(columnName: "installerCompanyID")
            let functionTypeID:String = database.getUserProfile(columnName: "functionTypeID")
            
            
            
            let params = ["functionTypeId": functionTypeID,
                          "utilityCompany": ["utilityCompanyId": utilityCompanyID],
                          "installerCompany": ["installerCompanyId": installerCompanyID]] as [String : Any]
            
            
            
            
            
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
                                    
                                    let alert = UIAlertController(title: "", message:NSLocalizedString("Success", comment: "Success") , preferredStyle: UIAlertControllerStyle.alert)
                                    alert.addAction(UIAlertAction(title:NSLocalizedString("Ok", comment: "Ok") , style: .default, handler: { (action: UIAlertAction!) in
                                        
                                        self .cancelButtonClicked()
                                        
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
    
    
    // MARK:  UITableView Data Source Methods
    private func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat    {
        
        
        let installerCompanyID:String = database.getUserProfile(columnName: "installerCompanyID")
        
        
        if indexPath.row == 0 {
            return 0.1
        }
        if indexPath.row == 2 {
            return 0.1
        }
        if indexPath.row == 3 {
            return 0.1
        }
        if indexPath.row == 6 {
            return 0.1
        }
        if indexPath.row == 7 {
            return 0.1
        }
        if indexPath.row == 9 &&  installerCompanyID == "0"{
            return 0.1
        }
        
        
        
        
        return 73
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return settingsArray.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : CustomTableViewCell = (tableView.dequeueReusableCell(withIdentifier: "CustomSettingsCell") as! CustomTableViewCell!)
        
        
        cell.titleLabel.text = settingsArray .object(at: indexPath.row) as? String
        
        
        
        if(indexPath.row == 4 || indexPath.row == 5 ||  indexPath.row == 8){
            let string:String = selectedArray[indexPath.row]  as! String
            cell.subLabel.text = string
        }
        
        
        
        let imageName = imageArray .object(at: indexPath.row)
        cell.iconImageView.image = UIImage(named: imageName as! String)
        
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        row = indexPath.row
        
        let canCreateNewTemplate:String = database.getUserProfile(columnName: "canCreateNewTemplate")
        
        
        if(indexPath.row == 1){
            
            if (canCreateNewTemplate == "N"){
                showAlert("", message: NSLocalizedString("You don't have privilege to create new template", comment: "You don't have privilege to create new template"))
            }
            else{
                let viewController = self.storyboard!.instantiateViewController(withIdentifier: "TemplateConfigurationViewController") as! TemplateConfigurationViewController
                self.navigationController!.pushViewController(viewController, animated: true)
            }
            
        }
        else if(indexPath.row == 4){
            let viewController = self.storyboard!.instantiateViewController(withIdentifier: "LanguageSettingsViewController") as! LanguageSettingsViewController
            self.navigationController!.pushViewController(viewController, animated: true)
        }
        else if(indexPath.row == 6){
            companyView?.isHidden = false
        }
        else if(indexPath.row == 7){
            
            
            let viewController = UIStoryboard(name: "Custom", bundle: nil).instantiateViewController(withIdentifier: "SearchBarViewController") as! SearchBarViewController
            
            
            let companyNameArray = NSMutableArray()
            let utilityCompanyIdArray = NSMutableArray()
            
            
            for i in 0 ..< companyArray.count {
                companyNameArray.add((companyArray.value(forKey: "utilityCompanyName") as AnyObject) .object(at: i) as! String)
                utilityCompanyIdArray.add(String(describing: (companyArray.value(forKey: "utilityCompanyId") as AnyObject) .object(at: i) as! NSNumber))
            }
            
            
            viewController.delegate = self
            
            
            viewController.companyArray = companyNameArray
            viewController.utilityCompanyIdArray = utilityCompanyIdArray
            viewController.titleString = NSLocalizedString("Select Utility Company", comment: "Select Utility Company")
            self.navigationController!.pushViewController(viewController, animated: true)
        }
            
        else if(indexPath.row == 9)
        {
            associateCompanyView?.isHidden = false
        }
        else if(indexPath.row == 10){
            let viewController = self.storyboard!.instantiateViewController(withIdentifier: "ChangePasswordViewController") as! ChangePasswordViewController
            self.navigationController!.pushViewController(viewController, animated: true)
        }
            
        else
        {
            
            let popOverVC = UIStoryboard(name: "Custom", bundle: nil).instantiateViewController(withIdentifier: "sbPopUpID") as! PopUpViewController
            self.addChildViewController(popOverVC)
            popOverVC.delegate = self
            
            
            if(indexPath.row == 5){
                popOverVC.titleString = NSLocalizedString("Data Storage", comment: "Data Storage")
                popOverVC.popupArray = [NSLocalizedString("Cloud Storage", comment: "Cloud Storage"),NSLocalizedString("Local Storage", comment: "Local Storage")]
                
                
                let string:String = selectedArray[indexPath.row]  as! String
                if !string.isEmpty {
                    popOverVC.selectedString = string
                }
                
                popOverVC.view.frame = CGRect(x: 0, y: -64, width: self.view.frame.width, height: self.view.frame.height+64)
                self.view.addSubview(popOverVC.view)
                popOverVC.didMove(toParentViewController: self)
                
            }
            else if(indexPath.row == 8){
                
                popOverVC.titleString = NSLocalizedString("Primary Functional Area", comment: "Primary Functional Area")
                popOverVC.popupArray = [NSLocalizedString("RFID Marker / EMS Passive Marker", comment: "RFID Marker / EMS Passive Marker"),NSLocalizedString("Cable Accessories", comment: "Cable Accessories"),NSLocalizedString("Both", comment: "Both")]
                
                
                let string:String = selectedArray[indexPath.row]  as! String
                if !string.isEmpty {
                    popOverVC.selectedString = string
                }
                
                popOverVC.view.frame = CGRect(x: 0, y: -64, width: self.view.frame.width, height: self.view.frame.height+64)
                self.view.addSubview(popOverVC.view)
                popOverVC.didMove(toParentViewController: self)
                
            }
            
            
            
            
            
        }
        
    }
    
    func selectedValue(_ selectedString: String){
        
        print(row)
        
        if row == 5 {
            
            let  canStoreDataToCloud:String = database.getUserProfile(columnName: "canStoreDataToCloud")
            let utilityCompanyVerifiedState:String = database.getUtilityCompany(columnName: "verified")
            
            var reloadData:Bool = true
            
            var storage:String = "Local Storage"
            
            if(selectedString == NSLocalizedString("Cloud Storage", comment: "")){
                if canStoreDataToCloud != "Y" || utilityCompanyVerifiedState != "Y"  {
                    showAlert("", message: NSLocalizedString("You don't have privilege for cloud storage", comment: "You don't have privilege for cloud storage"))
                    reloadData = false
                }
                storage = "Cloud Storage"
            }
            
            if(reloadData){
                self.database.updateStorage(storage: storage)
                selectedArray[row] = selectedString
                table? .reloadData()
            }
        }
        else if (row == 8){
            selectedArray[row] = selectedString
            
            if(selectedString == NSLocalizedString("RFID Marker / EMS Passive Marker", comment: ""))
            {
                functionTypeId = "1"
            }
            else if(selectedString == NSLocalizedString("Cable Accessories", comment: ""))
            {
                functionTypeId = "2"
            }
            else
            {
                functionTypeId = "3"
            }
            self .updatePrimaryFunctionalAreaAPI()
            
        }
        
        
        
        
        
    }
    
    
    
    
    
    @IBAction func selectRadioButton(sender: UIButton) {
        let selectionTag: Int = sender.tag
        
        radioButton1.image = UIImage(named: "radio_btn_off" )
        radioButton2.image = UIImage(named: "radio_btn_off" )
        
        
        if selectionTag == 1 {
            radioButton1.image = UIImage(named: "radio_btn_on" )
            dropDownButton.isEnabled = false
            selectedTextfield?.text = ""
            popupView?.isHidden = true
            
            //            selectedValuesArray[row] = popupArray .object(at: 0)
            
            table? .reloadData()
            
            
        }
        else if selectionTag == 2 {
            radioButton2.image = UIImage(named: "radio_btn_on" )
            dropDownButton.isEnabled = true
        }
        
        
    }
    
    
    
    @IBAction func cancelButtonClicked()
    {
        popupView?.isHidden = true
        companyView?.isHidden = true
        installerCompanyView?.isHidden = true
        associateCompanyView?.isHidden = true
        
        currentTextField .resignFirstResponder()
        
        self.utilityCompanyTypeId = 0
        
        
        self.utilityCompanyLabel.text = ""
        utilityCompanyID = ""
        
        self.addCompanyTextField.text = ""
        self.addFirstNameTextField.text = ""
        self.addLastNameTextField.text = ""
        self.addcontactNoTextField.text = ""
        self.addemailTextField.text = ""
        self.addCompanyTypeLabel.text = ""
        
        self.addInstallerCompanyTextField.text = ""
        self.addFirstNameTextField.text = ""
        self.addInstallerLastNameTextField.text = ""
        self.addInstallercontactNoTextField.text = ""
        self.addInstalleremailTextField.text = ""
        
        
        
    }
    
    
    
    
    
    
    //pragma mark - textField Delegate row lifecycle
    
    func textFieldDidBeginEditing(_ textField: UITextField) { // became first responder
        
        currentTextField = textField
        
        //move textfields up
        let myScreenRect: CGRect = UIScreen.main.bounds
        let keyboardHeight : CGFloat
        
        if companyView?.isHidden == false || installerCompanyView?.isHidden == false {
            keyboardHeight = 350
        }
        else{
            keyboardHeight = 300
        }
        
        
        UIView.beginAnimations( "animateView", context: nil)
        let movementDuration:TimeInterval = 0.35
        
        
        var needToMove: CGFloat = -64
        
        var frame : CGRect = self.view.frame
        
        
        if (textField.frame.origin.y + textField.frame.size.height +
            /*self.navigationController.navigationBar.frame.size.height + */
            UIApplication.shared.statusBarFrame.size.height > (myScreenRect.size.height - keyboardHeight)) {
            needToMove = (textField.frame.origin.y + textField.frame.size.height + /*self.navigationController.navigationBar.frame.size.height +*/ UIApplication.shared.statusBarFrame.size.height) - (myScreenRect.size.height - keyboardHeight);
        }
        
        if companyView?.isHidden == false {
            self.companyInnerView?.frame.origin.y = -needToMove
        }
        else if installerCompanyView?.isHidden == false {
            self.installerCompanyInnerView?.frame.origin.y = -needToMove
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
        
        
        
        if companyView?.isHidden == false {
            self.companyInnerView?.frame.origin.y = companyInnerViewYposition
        }
        else if installerCompanyView?.isHidden == false {
            self.installerCompanyInnerView?.frame.origin.y = installerCompanyInnerViewYposition
        }
        else
        {
            var frame : CGRect = self.view.frame
            frame.origin.y = 64
            self.view.frame = frame
        }
        
        
        
        UIView.setAnimationDuration(movementDuration)
        UIView.commitAnimations()
        
        
        
        
        if textField == self.addCompanyTextField {
            self.addFirstNameTextField.becomeFirstResponder()
        }
        else if textField == self.addFirstNameTextField {
            self.addLastNameTextField.becomeFirstResponder()
        }
        else if textField == self.addLastNameTextField {
            self.addcontactNoTextField.becomeFirstResponder()
        }
            
            
        else if textField == self.addInstallerCompanyTextField {
            self.addInstallerFirstNameTextField.becomeFirstResponder()
        }
        else if textField == self.addInstallerFirstNameTextField {
            self.addInstallerLastNameTextField.becomeFirstResponder()
        }
        else if textField == self.addInstallerLastNameTextField {
            self.addInstallercontactNoTextField.becomeFirstResponder()
        }
            
            
        else
        {
            textField.resignFirstResponder()
        }
        
        
        
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        
        return true
    }
    
    
    
    
    
    func validateDataAddCompany() -> Bool {
        
        var alertMessage = kEmptyString
        
        let company = addCompanyTextField.text!.trimmingCharacters(in: NSCharacterSet.whitespaces)
        let firstName = addFirstNameTextField.text!.trimmingCharacters(in: NSCharacterSet.whitespaces)
        let email = addemailTextField.text!.trimmingCharacters(in: NSCharacterSet.whitespaces)
        
        
        
        if (company .isEmpty) {
            alertMessage.append(NSLocalizedString("Please enter company name", comment: "Please enter company name"))
        }
        else if (firstName .isEmpty) {
            alertMessage.append(NSLocalizedString("Please enter first name", comment: "Please enter first name"))
        }
        else if (addcontactNoTextField.text? .isEmpty)! {
            alertMessage.append(NSLocalizedString("Please enter primary contact number", comment: "Please enter primary contact number"))
        }
        else if !validatePhoneWithString(addcontactNoTextField.text!){
            alertMessage.append(NSLocalizedString("Please enter a 10 digit valid primary phone number", comment: "Please enter a 10 digit valid primary phone number"))
        }
        else if (email .isEmpty) {
            alertMessage.append(NSLocalizedString("Please enter email", comment: "Please enter email"))
        }
        else if !validateEmailWithString(addemailTextField.text) {
            alertMessage.append(NSLocalizedString("Enter a valid primary email address", comment: "Enter a valid primary email address"))
        }
        else if (utilityCompanyTypeId == 0) {
            alertMessage.append(NSLocalizedString("Please select utility company type", comment: "Please select utility company type"))
            
        }
        
        if alertMessage.isEmpty {
            return true
        }
        
        showAlert(kEmptyString, message: alertMessage)
        return false
        
    }
    
    
    @IBAction func companyAddBtnClicked() {
        
        currentTextField .resignFirstResponder()
        
        if(validateDataAddCompany()){
            showActivityIndicator(false)
            let session = URLSession.shared
            let url = String(format:"%@utility-company",kUrlBase)
            let request = NSMutableURLRequest(url: NSURL(string: url)! as URL)
            request.httpMethod = "POST"
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            
            
            
            let params = ["utilityCompanyName": self.addCompanyTextField.text!,
                          "utilityCompanyTypeId":utilityCompanyTypeId,
                          "primaryContactFirstName": self.addFirstNameTextField.text!,
                          "primaryContactLastName": self.addLastNameTextField.text!,
                          "primaryContactPhone1": self.addcontactNoTextField.text!,
                          "primaryContactEmail1": self.addemailTextField.text!] as [String : Any]
            
            
            
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
                                    
                                    let alert = UIAlertController(title: "", message: NSLocalizedString("Utility company added successfully", comment: "Utility company added successfully"), preferredStyle: UIAlertControllerStyle.alert)
                                    alert.addAction(UIAlertAction(title:NSLocalizedString("Ok", comment: "Ok") , style: .default, handler: { (action: UIAlertAction!) in
                                        
                                        self .cancelButtonClicked()
                                        
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
    
    
    
    
    
    
    
    
    @IBAction func installerCompanyAddBtnClicked() {
        if(validateDataAddInstallerCompany()){
            
            
            showActivityIndicator(false)
            
            let session = URLSession.shared
            
            
            let url = String(format:"%@installer-company",kUrlBase)
            let request = NSMutableURLRequest(url: NSURL(string: url)! as URL)
            
            request.httpMethod = "POST"
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            
            
            
            let params = ["installerCompanyName": self.addInstallerCompanyTextField.text!,
                          "utilityCompanyId": utilityCompanyIDString,
                          "primaryContactFirstName": self.addInstallerFirstNameTextField.text!,
                          "primaryContactLastName": self.addInstallerLastNameTextField.text!,
                          "primaryContactPhone1": self.addInstallercontactNoTextField.text!,
                          "primaryContactEmail1": self.addInstalleremailTextField.text!] as [String : Any]
            
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
                            
                            let status =  jsonData?["status"] as! String
                            
                            
                            
                            DispatchQueue.main.async {
                                hideActivityIndicator()
                                
                                if(status == "Error"){
                                    let data: String = (jsonData as AnyObject).value(forKey: "data") as! String
                                    showAlert(kEmptyString, message:data)
                                }
                                else
                                {
                                    
                                    let alert = UIAlertController(title: "", message: NSLocalizedString("Installer company added successfully", comment: "Installer company added successfully"), preferredStyle: UIAlertControllerStyle.alert)
                                    alert.addAction(UIAlertAction(title:NSLocalizedString("Ok", comment: "Ok") , style: .default, handler: { (action: UIAlertAction!) in
                                        self.installerCompanyView?.isHidden = true
                                        self.addInstallerCompanyTextField.text = ""
                                        self.addFirstNameTextField.text = ""
                                        self.addInstallerLastNameTextField.text = ""
                                        self.addInstallercontactNoTextField.text = ""
                                        self.addInstalleremailTextField.text = ""
                                        self.utilityCompanyIDString = ""
                                        
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
    
    
    
    func validateDataAddInstallerCompany() -> Bool {
        
        var alertMessage = kEmptyString
        
        let company = addInstallerCompanyTextField.text!.trimmingCharacters(in: NSCharacterSet.whitespaces)
        let firstName = addInstallerFirstNameTextField.text!.trimmingCharacters(in: NSCharacterSet.whitespaces)
        let email = addInstalleremailTextField.text!.trimmingCharacters(in: NSCharacterSet.whitespaces)
        
        
        
        if (company .isEmpty) {
            alertMessage.append(NSLocalizedString("Please enter company name", comment: "Please enter company name"))
        }
        else if (firstName .isEmpty) {
            alertMessage.append(NSLocalizedString("Please enter first name", comment: "Please enter first name"))
        }
            
        else if (addInstallercontactNoTextField.text? .isEmpty)! {
            alertMessage.append(NSLocalizedString("Please enter primary contact number", comment: "Please enter primary contact number"))
        }
        else if !validatePhoneWithString(addInstallercontactNoTextField.text!){
            alertMessage.append(NSLocalizedString("Please enter a 10 digit valid primary phone number", comment: "Please enter a 10 digit valid primary phone number"))
        }
        else if (email .isEmpty) {
            alertMessage.append(NSLocalizedString("Please enter email", comment: "Please enter email"))
        }
        else if !validateEmailWithString(addInstalleremailTextField.text) {
            alertMessage.append(NSLocalizedString("Enter a valid primary email address", comment: "Enter a valid primary email address"))
        }
        
        
        
        if alertMessage.isEmpty {
            return true
        }
        
        showAlert(kEmptyString, message: alertMessage)
        return false
        
    }
    
    
    
    
    
    
    func getUtilityCompanyType()
    {
        showActivityIndicator(false)
        let Parameter: String = "utility-company-types"
        
        RestApiManager.sharedInstance.getRandomUser(Parameter as String)
        {
            json in
            let status = json["status"]
            let data = json["data"]
            
            
            hideActivityIndicator()
            
            if(status == "Success")
            {
                
                
                let array:NSArray =  data.object as! NSArray
                self.utilityCompanyTypeArray = array.value(forKey: "utilityCompanyTypeDesc") as! NSArray
                self.utilityCompanyTypeIdArray = array.value(forKey: "utilityCompanyTypeId") as! NSArray
                
                
                
                
                DispatchQueue.main.async {
                    //TODO: need to list companytype in popupview
                    
                    self.currentTextField .resignFirstResponder()
                    
                    
                    if (self.utilityCompanyTypeArray.count == 0) {
                        showAlert(kEmptyString, message:NSLocalizedString("No values in dropdown", comment: "No values in dropdown") )
                    }
                    else
                    {
                        self.actionSheet()
                        
                        self.picker = UIPickerView(frame: CGRect(x: 0, y: 44, width: self.view.frame.size.width, height: 216))
                        self.picker.showsSelectionIndicator = true
                        self.picker.delegate = self
                        self.picker.tag = 103
                        self.picker.reloadAllComponents()
                        
                        
                        
                        let isTheObjectThere: Bool = self.utilityCompanyTypeArray.contains(self.addCompanyTypeLabel.text!)
                        if isTheObjectThere == true {
                            let indexValue: Int = self.utilityCompanyTypeArray.index(of: self.addCompanyTypeLabel.text!)
                            self.picker.selectRow(indexValue, inComponent: 0, animated: true)
                            self.selectedRow = indexValue
                        }
                        else {
                            self.picker.selectRow(0, inComponent: 0, animated: true)
                            self.addCompanyTypeLabel.text = self.utilityCompanyTypeArray[0] as? String
                            self.selectedRow = 0
                        }
                        self.actionView.addSubview(self.picker)
                        
                        
                        
                        
                    }
                    
                }
                
            }
            
        }
    }
    
    
    
    
    public func numberOfComponents(in pickerView:  UIPickerView) -> Int  {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        
        if (picker.tag == 103){
            return utilityCompanyTypeArray.count
        }
        return 0
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let pickerLabel = UILabel(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 30))
        pickerLabel.textAlignment = .center
        pickerLabel.backgroundColor = UIColor.clear
        pickerLabel.font = UIFont(name: "3MCircularTT-Book", size: 14)
        
        
        if (picker.tag == 103){
            pickerLabel.text =  utilityCompanyTypeArray.object(at: row) as? String
        }
        
        
        return pickerLabel
        
        
    }
    
    
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedRow = row;
        
        print(selectedRow)
        
        
        if (picker.tag == 103){
            addCompanyTypeLabel.text = utilityCompanyTypeArray.object(at: row) as? String
            utilityCompanyTypeId = utilityCompanyTypeIdArray.object(at: row) as! Int
            
        }
        
        
        
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
        
        
        
        let height: CGFloat = self.view.bounds.height
        
        actionView = UIView(frame: CGRect(x: 0, y: height, width: self.view.frame.size.width, height: 256))
        actionView.backgroundColor=(UIColor .white)
        actionView.addSubview(pickerToolbar)
        
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options:  UIViewAnimationOptions.curveEaseInOut, animations:
            {
                self.actionView.frame = CGRect(x: 0, y: height - 256, width: self.view.frame.size.width, height: 256)
                
        }, completion: {(finished: Bool) in
        })
        
        
        self.view.addSubview(actionView)
        
        
    }
    
    
    
    func donePicker() {
        
        
        if (picker.tag == 103  && utilityCompanyTypeArray.count != 0){
            addCompanyTypeLabel.text = utilityCompanyTypeArray.object(at: selectedRow) as? String
            utilityCompanyTypeId = utilityCompanyTypeIdArray.object(at: selectedRow) as! Int
        }
        
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseInOut
            , animations:
            {
                self.actionView.frame = CGRect(x: 0, y: self.view.frame.size.height, width: self.view.frame.size.width, height: 256)
                
        }, completion: {(finished: Bool) in    if finished {
            self.actionView.removeFromSuperview()
            }
            self.transView.removeFromSuperview()
            
        })
        
    }
    
    
    
    func getUnassociatedCompanyList()
    {
        
        showActivityIndicator(false)
        
        let session = URLSession.shared
        
        let url = String(format:"%@utility-companies-unassociated",kUrlBase)
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        
        request.httpMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        let installerCompanyID:String = database.getUserProfile(columnName: "installerCompanyID")
        let params = ["installerCompanyId": Int(installerCompanyID)!] as [String : Any]
        
        
        
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
                            
                            
                            
                            if(status == "Success")
                            {
                                DispatchQueue.main.async {
                                    hideActivityIndicator()
                                    
                                    self.companyArray =   jsonData?["data"] as! NSArray
                                    
                                    
                                    
                                    let viewController = UIStoryboard(name: "Custom", bundle: nil).instantiateViewController(withIdentifier: "SearchBarViewController") as! SearchBarViewController
                                    
                                    
                                    let companyNameArray = NSMutableArray()
                                    let utilityCompanyIdArray = NSMutableArray()
                                    
                                    
                                    for i in 0 ..< self.companyArray.count {
                                        companyNameArray.add((self.companyArray.value(forKey: "utilityCompanyName") as AnyObject) .object(at: i) as! String)
                                        utilityCompanyIdArray.add(String(describing: (self.companyArray.value(forKey: "utilityCompanyId") as AnyObject) .object(at: i) as! NSNumber))
                                    }
                                    
                                    
                                    viewController.delegate = self
                                    viewController.companyArray = companyNameArray
                                    viewController.utilityCompanyIdArray = utilityCompanyIdArray
                                    viewController.titleString = "Select Utility Company"
                                    self.navigationController!.pushViewController(viewController, animated: true)
                                    
                                    
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
    
    
    func updatePrimaryFunctionalAreaAPI(){
        
        showActivityIndicator(false)
        let session = URLSession.shared
        let url = String(format:"%@user/update-primary-function",kUrlBase)
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        
        request.httpMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        
        let userProfileId:String = UserDefaults.standard.value(forKey: "userProfileId") as! String
        
        
        
        
        
        
        let params = ["userProfileId": userProfileId, "functionTypeId": functionTypeId] as [String : Any]
        
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
                        
                        
                        let data =  jsonData?["data"] as! NSDictionary
                        
                        
                        print(data)
                        
                        
                        DispatchQueue.main.async {
                            
                            hideActivityIndicator()
                            
                            
                            let functionTypeID:Int = data.value(forKey: "functionTypeId") as! Int
                            
                            
                            if (functionTypeID == 1){
                                self.selectedArray[self.row] = NSLocalizedString("RFID Marker / EMS Passive Marker", comment: "")
                            }
                            else if (functionTypeID == 2){
                                self.selectedArray[self.row] = NSLocalizedString("Cable Accessories", comment: "")
                                
                            }
                            else{
                                self.self.selectedArray[self.row] = NSLocalizedString("Both", comment: "")
                            }
                            
                            self.database.updatePrimaryFunction(functionTypeID: String(functionTypeID))
                            self.table? .reloadData()
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

