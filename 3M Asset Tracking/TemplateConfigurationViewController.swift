//
//  TemplateConfigurationViewController.swift
//  3M L&M
//
//  Created by IndianRenters on 26/07/17.
//  Copyright © 2017 3M L&M. All rights reserved.
//

import UIKit

class TemplateConfigurationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PopupDelegate {
    @IBOutlet weak var table: UITableView?
    @IBOutlet weak var popupView: UIView?
    @IBOutlet weak var popupTitleLabel: UILabel?

    @IBOutlet weak var createRadioButton: UIImageView!
    @IBOutlet weak var editRadioButton: UIImageView!
    @IBOutlet weak var createTextField: UITextField!
    @IBOutlet weak var editTextField: UITextField!
    @IBOutlet weak var dropDownButton: UIButton!

    var labelArray: NSArray = []
    var descriptionArray: NSArray = []
    var dropdownArray: NSArray = []
    var templateDetailIdArray: NSArray = []


    var templateArray: NSArray = []
    var editTemplateArray: NSArray = []
    let database = DatabaseHandler()
    var templateId: String = ""
    var templateTypeId: String = ""
    @IBOutlet weak var popOkBtn: UIButton!
    @IBOutlet weak var popCanBtn: UIButton!
    @IBOutlet weak var popEditLbl: UILabel!
    @IBOutlet weak var popCreateLbl: UILabel!
    var navBarHeight: CGFloat = 0

    override func viewWillAppear(_ animated: Bool) {
        popupView?.isHidden = true
        //For localization
        DispatchQueue.main.async {
self.popOkBtn.setAttributedTitle(nil, for: UIControlState.normal)
            self.popCanBtn.setAttributedTitle(nil, for: UIControlState.normal)

        self.popOkBtn.setTitle(NSLocalizedString("OK", comment: "ok"), for: UIControlState.normal)
        self.popCanBtn.setTitle(NSLocalizedString("CANCEL", comment: "ok"), for: UIControlState.normal)
        self.popEditLbl.text = NSLocalizedString("Edit template", comment: "edit")
        self.popCreateLbl.text = NSLocalizedString("Create a new Template", comment: "create")

        }
        self.title = NSLocalizedString("Template Configuration", comment: "Template Configuration")
             templateArray = [NSLocalizedString("RFID Template", comment: "RFID Template"),NSLocalizedString("Data Collection Template", comment: "Data Collection Template")]
        //----
        createRadioButton.image = UIImage(named: "radio_btn_off" )
        editRadioButton.image = UIImage(named: "radio_btn_off" )
        
       createTextField.text = ""
        editTextField.text = ""
        
        createTextField.isEnabled = false
        dropDownButton.isEnabled = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
 //TealiumHelper.trackView(NSStringFromClass(self.classForCoder), dataSources: [:])
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        
        navBarHeight = UIApplication.shared.statusBarFrame.height + self.navigationController!.navigationBar.frame.height

        templateArray = [NSLocalizedString("RFID Template", comment: "RFID Template"),NSLocalizedString("Data Collection Template", comment: "Data Collection Template")]
        
        
        
    }
    
    

     // MARK: - textField Delegate row lifecycle
    
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
        
        frame.origin.y = -needToMove
        self.view.frame = frame
        UIView.setAnimationDuration(movementDuration )
        UIView.commitAnimations()
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //move textfields back down
        UIView.beginAnimations( "animateView", context: nil)
        let movementDuration:TimeInterval = 0.35
        
        var frame : CGRect = self.view.frame
        frame.origin.y = navBarHeight
        self.view.frame = frame
        UIView.setAnimationDuration(movementDuration)
        UIView.commitAnimations()
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        
        return true
    }
    
    
    
    
    // MARK:  UITableView Data Source Methods
    private func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat    {
        return 44
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return templateArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : CustomTableViewCell = (tableView.dequeueReusableCell(withIdentifier: "CustomTemplateConfigurationCell") as! CustomTableViewCell!)
        cell.titleLabel.text = templateArray .object(at: indexPath.row) as? String
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
          popupTitleLabel?.text = NSLocalizedString("RFID Template", comment: "RFID Template")
            editTemplateArray = database .getTemplateName(TemplateTypeId: "1")

        }
        else{
            popupTitleLabel?.text = NSLocalizedString("Data Collection Template", comment: "Data Collection Template")
            editTemplateArray = database .getTemplateName(TemplateTypeId: "2")
        }
        
        popupView?.isHidden = false
    }
    
    
    @IBAction func cancelButtonClicked()
    {
        popupView?.isHidden = true
        
        createRadioButton.image = UIImage(named: "radio_btn_off" )
        editRadioButton.image = UIImage(named: "radio_btn_off" )

        createTextField.text = ""
        editTextField.text = ""

    }
    
    @IBAction func okButtonClicked()
    {
        if validateData() {
            
            
            if popupTitleLabel?.text == NSLocalizedString("RFID Template", comment: "RFID Template") {
                
                
                if(createTextField.isEnabled == true){
                    self.validateTemplatenameApi()
                }
                else{
                    let viewController = self.storyboard!.instantiateViewController(withIdentifier: "CreateRFIDTemplateViewController") as! CreateRFIDTemplateViewController
                    viewController.titleString = NSLocalizedString("Edit RFID Template", comment: "Edit RFID Template")
                    viewController.templateNameString = editTextField.text!
                    viewController.leftArray = labelArray as! NSMutableArray
                    viewController.rightArray = descriptionArray as! NSMutableArray
                    viewController.dropDownArray = dropdownArray as! NSMutableArray
                    viewController.templateId = templateId
                    viewController.templateTypeId = templateTypeId
                    viewController.templateDetailIdArray = templateDetailIdArray
                    self.navigationController!.pushViewController(viewController, animated: true)
                    
                }
            }
            else
            {
                
                if(createTextField.isEnabled == true){
                    self.validateTemplatenameApi()
                }
                else{
                    let viewController = self.storyboard!.instantiateViewController(withIdentifier: "CreateDataCollectionViewController") as! CreateDataCollectionViewController
                    viewController.titleString = NSLocalizedString("Edit Data Collection Template", comment: "Edit Data Collection Template")
                    viewController.templateNameString = editTextField.text!
                    viewController.leftArray = labelArray as! NSMutableArray
                    viewController.rightArray = descriptionArray as! NSMutableArray
                    viewController.dropDownArray = dropdownArray as! NSMutableArray
                    viewController.templateId = templateId
                    viewController.templateTypeId = templateTypeId
                    viewController.templateDetailIdArray = templateDetailIdArray
                    self.navigationController!.pushViewController(viewController, animated: true)
                }
            }            
            
        }
        
    }

    
    
    
    func validateData() -> Bool {
        
        let createText = self.createTextField.text!.trimmingCharacters(in: NSCharacterSet.whitespaces)
        
        var alertMessage = kEmptyString
        if createTextField.isEnabled == false && dropDownButton.isEnabled == false {
            alertMessage.append(NSLocalizedString("Please select create or edit template", comment: "Please select create or edit template"))
        }
        else if (createTextField.isEnabled == true &&  createText.isEmpty)
        {
            alertMessage.append(NSLocalizedString("Please enter a new template name", comment: "Please enter a new template name"))
        }
        else if (dropDownButton.isEnabled == true &&  editTextField.text!.isEmpty)
        {
            alertMessage.append(NSLocalizedString("Please select anyone from edit template dropdown", comment: "Please select anyone from edit template dropdown"))
        }
        
        
        if alertMessage.isEmpty {
            return true
        }
        
        showAlert(kEmptyString, message: alertMessage)
        return false
        
    }
    

    
    
    
    
    @IBAction func selectTemplate(sender: UIButton) {
        let selectionTag: Int = sender.tag
        
        createRadioButton.image = UIImage(named: "radio_btn_off" )
        editRadioButton.image = UIImage(named: "radio_btn_off" )

        
        if selectionTag == 1 {
             createRadioButton.image = UIImage(named: "radio_btn_on" )
            createTextField.isEnabled = true
            dropDownButton.isEnabled = false
            editTextField.text = ""
        }
        else if selectionTag == 2 {
            editRadioButton.image = UIImage(named: "radio_btn_on" )
            dropDownButton.isEnabled = true
            createTextField.isEnabled = false
            createTextField.text = ""

        }
      
        
    }
    
    
    
    @IBAction func dropDownClicked(sender: UIButton)
    {
        let popOverVC = UIStoryboard(name: "Custom", bundle: nil).instantiateViewController(withIdentifier: "sbPopUpID") as! PopUpViewController
        self.addChildViewController(popOverVC)
        popOverVC.delegate = self
        
        
        popOverVC.titleString = NSLocalizedString("Select Template", comment: "Select Template")
        popOverVC.popupArray = editTemplateArray
        
        
        let string:String = editTextField.text!
        if !string.isEmpty {
            popOverVC.selectedString = string
        }
        
        popOverVC.view.frame = CGRect(x: 0, y: -64, width: self.view.frame.width, height: self.view.frame.height+64)
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
    }
    
    
    func selectedValue(_ selectedString: String){
        editTextField.text = selectedString
        
        templateId = database .getTemplateId(TemplateName: selectedString) .object(at: 0) as! String
        templateTypeId = database .getTemplateId(TemplateName: selectedString) .object(at: 1) as! String

        
        
        let templateDetailsArray:NSArray = database .getLabelDescriptionArray(TemplateId: templateId)
        
        labelArray = templateDetailsArray .object(at: 0) as! NSArray
        descriptionArray = templateDetailsArray .object(at: 1) as! NSArray
        dropdownArray = templateDetailsArray .object(at: 2) as! NSArray
        templateDetailIdArray = templateDetailsArray .object(at: 3) as! NSArray

        print(dropdownArray)

  
    }

    
    
    
    
    func validateTemplatenameApi()
    {
        
        
        let userProfileId:String = UserDefaults.standard.value(forKey: "userProfileId") as! String
        
        
        let params = [ "templateName": createTextField.text!,
                       "userProfileId": userProfileId] as [String : Any]
        print(params)
        
        showActivityIndicator(false)
        
        let session = URLSession.shared
        
        
        let url = String(format:"%@check-avilable-templatename",kUrlBase)
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
                            
                            if(status == "InValid" || status == "Error"){
                                let data: String = (jsonData as AnyObject).value(forKey: "data") as! String
                                showAlert(kEmptyString, message:data)
                            }
                            else
                            {
                                
                                if self.popupTitleLabel?.text == NSLocalizedString("RFID Template", comment: "RFID Template") {
                                    let viewController = self.storyboard!.instantiateViewController(withIdentifier: "CreateRFIDTemplateViewController") as! CreateRFIDTemplateViewController
                                    viewController.titleString = NSLocalizedString("Create RFID Template", comment: "Create RFID Template")
                                    viewController.templateNameString = self.createTextField.text!
                                    self.navigationController!.pushViewController(viewController, animated: true)
                                    
                                }
                                else{
                                    let viewController = self.storyboard!.instantiateViewController(withIdentifier: "CreateDataCollectionViewController") as! CreateDataCollectionViewController
                                    viewController.titleString = NSLocalizedString("Create Data Collection Template", comment: "Create Data Collection Template")
                                    viewController.templateNameString = self.createTextField.text!
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

    



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
