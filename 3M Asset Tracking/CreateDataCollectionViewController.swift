//
//  CreateDataCollectionViewController.swift
//  3M L&M
//
//  Created by IndianRenters on 27/07/17.
//  Copyright © 2017 3M L&M. All rights reserved.
//

import UIKit

class CreateDataCollectionViewController: UIViewController,UITableViewDelegate, UITableViewDataSource,PopupDelegate {
    //For localization
    @IBOutlet weak var lbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    //----
    var labelArray: NSArray = []
    var labelIdArray: NSArray = []
    
    var descriptionArray: NSArray = []

    var leftArray: NSMutableArray = []
    var rightArray: NSMutableArray = []
    var dropDownArray: NSMutableArray = []
    var templateDetailIdArray: NSArray = []
    
    var row: Int = 0
    var templateId: String = ""
    var templateTypeId: String = ""

    var templateNameString: String = ""
    var titleString: String = ""
    var currentTextField: UITextField!
    var datePickerView: UIDatePicker!
    var transView:UIView!
    var actionView:UIView!
    
    var leftDropdownClicked: Bool!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var table: UITableView?
    @IBOutlet weak var templateNameLabel: UILabel?
    var barcodeScanner:BarcodeScannerViewController?
    let database = DatabaseHandler()
    var navBarHeight: CGFloat = 0

    
    override func viewWillAppear(_ animated: Bool) {
        self.changeLanguage()
       
    }
    func changeLanguage(){
        self.title = NSLocalizedString(titleString, comment: titleString)
        DispatchQueue.main.async {

        self.lbl.text = NSLocalizedString("Label", comment: "Label")
        self.descriptionLbl.text = NSLocalizedString("Description", comment: "Description")
            self.saveBtn.setAttributedTitle(nil, for:  UIControlState.normal)
            self.cancelBtn.setAttributedTitle(nil, for:  UIControlState.normal)
        self.saveBtn.setTitle(NSLocalizedString("SAVE", comment: "save"), for: UIControlState.normal)
        self.cancelBtn.setTitle(NSLocalizedString("CANCEL", comment: "cancel"), for: UIControlState.normal)
        self.editButton.title = NSLocalizedString("Edit", comment: "Edit")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.changeLanguage()

        // Do any additional setup after loading the view.
        
        navBarHeight = UIApplication.shared.statusBarFrame.height + self.navigationController!.navigationBar.frame.height

        
        let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 50))
        label.backgroundColor = UIColor.clear
        label.numberOfLines = 2
        label.font = UIFont(name: "3MCircularTT-Bold", size: 16)!
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.text = titleString
        self.navigationItem.titleView = label
        


        
        
        
        labelIdArray = database .getPredefinedLabelId(Template: "Create Template")
        labelArray = database .getPredefinedLabelName(labelIdArray: labelIdArray)
        
        print(templateNameString)
        
        
        
        
        templateNameLabel?.text = templateNameString
        leftDropdownClicked = false
        

        print(titleString)
        
        if (titleString == NSLocalizedString("Create Data Collection Template", comment: "Create Data Collection Template")){
            leftArray = ["", "", "", "", "",""]
            rightArray = ["", "", "", "", "",""]
            dropDownArray = ["", "", "", "", "",""]
            
        }
       
       
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
        
        

    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        TealiumHelper.sharedInstance().trackView(title: "RFID Template", data: [:])
    }
  
    
    // MARK: Keyboard Notifications
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardHeight = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height {
            
            table?.contentInset = UIEdgeInsetsMake(0, 0, keyboardHeight, 0)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.2, animations: {
            // For some reason adding inset in keyboardWillShow is animated by itself but removing is not, that's why we have to use animateWithDuration here
            
            self.table?.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        })
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    

    //pragma mark - textField Delegate row lifecycle
    
    func textFieldDidChange(textField: UITextField) {
        
        
        leftArray.replaceObject(at: textField.tag-50, with: textField.text!)
        
        let txtFld:UITextField = self.table?.viewWithTag(textField.tag + 50) as! UITextField
        let dropdown:UIButton = self.table?.viewWithTag(textField.tag + 100) as! UIButton
        dropdown.isHidden = true
        
        
        if (!textField.text! .isEmpty) {
            txtFld.isEnabled = true
        }
        else{
            txtFld.isEnabled = false
        }
        
    }
    func descTextFieldDidChange(textField: UITextField) {
        
        rightArray.replaceObject(at: textField.tag-100, with: textField.text!)
        
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) { // became first responder
        
        currentTextField = textField
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //move textfields back down
        
        if (!textField.text! .isEmpty && textField.tag < 100) {
            
            leftArray.replaceObject(at: textField.tag-50, with: textField.text!)
            
            let txtFld:UITextField = self.table?.viewWithTag(textField.tag + 50) as! UITextField
            txtFld.isEnabled = true
            let dropdown:UIButton = self.table?.viewWithTag(textField.tag + 100) as! UIButton
            dropdown.isHidden = true
            
            if leftDropdownClicked == false{
                txtFld.becomeFirstResponder()
            }
        }
        
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
        return leftArray.count
    }
    
    
  
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            self.table?.beginUpdates()
            self.leftArray.removeObject(at: indexPath.row)
            self.rightArray.removeObject(at: indexPath.row)
            self.dropDownArray.removeObject(at: indexPath.row)
            
            self.table?.deleteRows(at: [indexPath], with: .automatic)
            self.table?.reloadData()
            self.table?.endUpdates()

        }
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if (tableView.isEditing) {
            return UITableViewCellEditingStyle.delete
        }
        return UITableViewCellEditingStyle.none
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : CustomTableViewCell = (tableView.dequeueReusableCell(withIdentifier: "CustomCreateDataCell") as! CustomTableViewCell!)
        cell.leftDropDownButton.tag = indexPath.row
        cell.leftTextfield.tag = indexPath.row + 50
        cell.rightTextfield.tag = indexPath.row + 100
        cell.rightDropDownButton.tag = indexPath.row + 150
        
        currentTextField =  cell.leftTextfield
        cell.leftTextfield.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        cell.rightTextfield.addTarget(self, action: #selector(descTextFieldDidChange(textField:)), for: .editingChanged)
        
        
        cell.leftDropDownButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        cell.rightDropDownButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        
        
        
        
        let dropString:String = dropDownArray[indexPath.row]  as! String
        
        
        let descString:String = rightArray[indexPath.row]  as! String
        cell.rightTextfield.text = descString
        
        cell.leftTextfield.text = leftArray[indexPath.row]  as? String
        
        
    
        
        if dropString == "Textfield" {
            cell.rightDropDownButton.isHidden = true
            cell.rightTextfield.isEnabled = true
            
        }
        else  if dropString == "DropDown" {
            cell.rightDropDownButton.isHidden = false
            cell.rightTextfield.isEnabled = false
            cell.rightDropDownButton.setImage(UIImage(named: "drop down"), for: .normal)
            cell.rightDropDownButton.isUserInteractionEnabled = true
        }
        else  if dropString == "Combo" {
            cell.rightDropDownButton.isHidden = false
            cell.rightTextfield.isEnabled = true
            cell.rightDropDownButton.setImage(UIImage(named: "drop down"), for: .normal)
            cell.rightDropDownButton.isUserInteractionEnabled = true
        }
        else if dropString == "Date"{
            cell.rightDropDownButton.isHidden = false
            cell.rightTextfield.isEnabled = false
            cell.rightDropDownButton.setImage(UIImage(named: "calender"), for: .normal)
            cell.rightDropDownButton.isUserInteractionEnabled = true
        }
        else  if dropString == "Number"{
            cell.rightDropDownButton.isHidden = true
            cell.rightTextfield.isEnabled = true
            cell.rightTextfield.keyboardType = UIKeyboardType.numberPad
            
            
            let keyboardToolbar = UIToolbar()
            keyboardToolbar.sizeToFit()
            let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                                target: nil, action: nil)
            let doneBarButton = UIBarButtonItem(title: "Done", style: .plain, target:self, action: #selector(self.doneButtonAction))
            keyboardToolbar.items = [flexBarButton, doneBarButton]
            cell.rightTextfield.inputAccessoryView = keyboardToolbar
        }
        else  if dropString == "Photo" {
            cell.rightDropDownButton.isHidden = false
            cell.rightTextfield.isEnabled = false
            cell.rightDropDownButton.setImage(UIImage(named: "camera"), for: .normal)
            cell.rightDropDownButton.isUserInteractionEnabled = false
        }
        else  if dropString == "Barcode" {
            cell.rightDropDownButton.isHidden = false
            cell.rightTextfield.isEnabled = false
            cell.rightDropDownButton.setImage(UIImage(named: "barcode"), for: .normal)
            cell.rightDropDownButton.isUserInteractionEnabled = false
            
            
        }
        else
        {
            cell.rightDropDownButton.isHidden = true
            cell.rightTextfield.isEnabled = true
        }
        
        
        
        
        return cell
    }
    

    
    

    
  
   
    
    
    @IBAction func doEdit(sender: AnyObject) {
        
        if (table?.isEditing)! {
           editButton.title = NSLocalizedString("Edit", comment: "Edit")
            table?.setEditing(false, animated: true)
        } else {
            editButton.title = NSLocalizedString("Done", comment: "Done")
            table?.setEditing(true, animated: true)
        }
    }
    
    
    
    
    
    func doneButtonAction() {
        currentTextField.resignFirstResponder()
    }
    
    
  
    
    
    
    
    
    @IBAction func leftDropDownClicked(sender: UIButton)
    {
        
        
        
        leftDropdownClicked = true
        
        row = sender.tag
        
        self.currentTextField.resignFirstResponder()
        let popOverVC = UIStoryboard(name: "Custom", bundle: nil).instantiateViewController(withIdentifier: "sbPopUpID") as! PopUpViewController
        self.addChildViewController(popOverVC)
        popOverVC.delegate = self
        
        
        popOverVC.titleString = NSLocalizedString("Select Label", comment: "Select Label")
        popOverVC.popupArray = self.labelArray
        
        
        let string:String = self.leftArray[self.row]  as! String
        if !string.isEmpty {
            popOverVC.selectedString = string
        }
        
        popOverVC.view.frame = CGRect(x: 0, y: -64, width: self.view.frame.width, height: self.view.frame.height+64)
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
        
    
        
    }
    
  

    
    
    
    func selectedValue(_ selectedString: String){
        
        print(selectedString)
        
        print(row)
        
        if row >= 150{
            row = row - 150
            rightArray.replaceObject(at: row, with: selectedString)
            table? .reloadData()
            
        }
        else{
            leftArray.replaceObject(at: row, with: selectedString)
            rightArray.replaceObject(at: row, with: "")
            
            leftDropdownClicked = false
            
            
            let dropDownId:String = database .getPredefinedLabel(LabelName: selectedString) .object(at: 1) as! String
            let dataType:String = database .getDataType(DataTypeID: dropDownId)
            dropDownArray.replaceObject(at: row, with: dataType)
            
            print(dropDownArray)
            
            table? .reloadData()
            
            
        }
        
    }
    
    
    @IBAction func rightDropDownClicked(sender: UIButton)
    {
        row = sender.tag
        self.currentTextField.resignFirstResponder()
        
        
        if sender.currentImage!.isEqual(UIImage(named: "calender")) {
            self.openDatePicker()
        }
        else
        {
            
            
            
            print(leftArray .object(at: row-150))
            
            
            
            let labelId:String = database .getPredefinedLabel(LabelName: leftArray .object(at: row-150) as! String) .object(at: 0) as! String
            
            let decriptionIdArray = database .getDescriptionIdArray(LabelId: labelId)
            descriptionArray = database .getDescriptionArray(DescriptionIdArray: decriptionIdArray)
            
            print(descriptionArray)
            
            
            
            
            
            let popOverVC = UIStoryboard(name: "Custom", bundle: nil).instantiateViewController(withIdentifier: "sbPopUpID") as! PopUpViewController
            self.addChildViewController(popOverVC)
            popOverVC.delegate = self
            
            
            popOverVC.titleString = NSLocalizedString("Select Description", comment: "Select Description")
            popOverVC.popupArray = self.descriptionArray
            
            
            let string:String = self.rightArray[self.row - 150]  as! String
            if !string.isEmpty {
                popOverVC.selectedString = string
            }
            
            
            
            popOverVC.view.frame = CGRect(x: 0, y: -64, width: self.view.frame.width, height: self.view.frame.height+64)
            self.view.addSubview(popOverVC.view)
            popOverVC.didMove(toParentViewController: self)
            
            
            
        }
        
        
        
    }
    
    
    
    
    
    
//    @IBAction func rightDropDownClicked(sender: UIButton)
//    {
//        row = sender.tag
//
//        if sender.currentImage!.isEqual(UIImage(named: "calender")) {
//            self.openDatePicker()
//        }
//        else if sender.currentImage!.isEqual(UIImage(named: "barcode")) {
////            self.openBarcodeScanner()
    
//
//            barcodeScanner = self.storyboard!.instantiateViewController(withIdentifier: "BarcodeScannerViewController") as? BarcodeScannerViewController
//
//            
//            // Define the callback which is executed when the barcode has been scanned
//            barcodeScanner?.barcodeScanned = { (barcode:String) in
//                
//                // When the screen is tapped, return to first view (barcode is beeing passed as param)
//                print("Received following barcode: \(barcode)")
//                
//                DispatchQueue.main.async {
//                    
//                    let txtFld:UITextField = self.table?.viewWithTag(self.row - 50) as! UITextField
//                    txtFld.text = "\(barcode)"
//                }
//            }
//            
//            // Push the ViewController when you want to scan something
//            if let barcodeScanner = self.barcodeScanner {
//                self.navigationController?.pushViewController(barcodeScanner, animated: true)
//            }
//        }
//           
//    }
//    
    
    
 
    
    
    
    
//    
//    
//     func openBarcodeScanner() {
//        let viewController = self.storyboard!.instantiateViewController(withIdentifier: "BarcodeScannerViewController") as! BarcodeScannerViewController
//        self.navigationController!.pushViewController(viewController, animated: true)
//        
//
//    }
//    
    
     func openDatePicker() {
        
        currentTextField .resignFirstResponder()
        
        actionSheet()
        
        
        datePickerView = UIDatePicker(frame: CGRect(x: 0, y: 44, width: self.view.frame.size.width, height: 216))
        datePickerView.datePickerMode = UIDatePickerMode.date
//        datePickerView.minimumDate=NSDate() as Date
        
        
        
        let dateFormatter = DateFormatter()
        // this is imporant - we set our input date format to match our input string
        dateFormatter.dateFormat = "MM/dd/yy"
        // voila!
        
         let txtFld:UITextField = (self.table?.viewWithTag(row - 50) as! UITextField)

        if let dateFromString = dateFormatter.date(from: txtFld.text!){
               datePickerView.date=dateFromString
    }
    
        datePickerView.addTarget(self, action: #selector(self.handleDatePicker(sender:)), for: UIControlEvents.valueChanged)
        
        handleDatePicker(sender: datePickerView)
        
        actionView.addSubview(datePickerView)
        
        
    }
    
    func handleDatePicker(sender: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy"
        
        let txtFld:UITextField = self.table?.viewWithTag(row - 50) as! UITextField
         txtFld.text = dateFormatter.string(from: sender.date)
        rightArray.replaceObject(at: row-150, with: txtFld.text!)
        
        
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
    
    
    @IBAction func addRow()
    {
  
        
        table?.beginUpdates()
        var indexPath:IndexPath = IndexPath(row:(self.leftArray.count), section:0)
        leftArray.add("")
        rightArray.add("")
        dropDownArray.add("")

        
        table?.insertRows(at: [indexPath], with: .bottom)
        table?.endUpdates()

        indexPath = IndexPath(row:(self.leftArray.count - 1), section:0)
        table?.scrollToRow(at: indexPath, at: .bottom, animated: true)
        

    }
    
    
    
    
    
    @IBAction func saveButtonClicked()
    {
        if (titleString == NSLocalizedString("Create Data Collection Template", comment: "Create Data Collection Template")){
            self .addTemplateAPICall()
        }
        else
        {
            self .editTemplateAPICall()
        }
    }
    
    
    @IBAction func cancelButtonClicked(){
        let alert = UIAlertController(title: NSLocalizedString("Cancel Data Collection Template?", comment: "Cancel Data Collection Template?"), message: NSLocalizedString("Are you sure you want to cancel this Data Collection Template?", comment: "Are you sure you want to cancel this Data Collection Template?"), preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: "Ok"), style: .default, handler: { (action: UIAlertAction!) in
            self.navigationController?.popViewController(animated: true)
        }))
        
        alert.addAction(UIAlertAction(title:NSLocalizedString("Cancel", comment: "Cancel") , style: .cancel, handler: { (action: UIAlertAction!) in
        }))
        
        present(alert, animated: true, completion: nil)
        
    }

    
    
    
    func addTemplateAPICall()
    {
        
        
        var tempDetailsDictionary = [[String: Any]]()
        
        
        
        
        for i in 0 ..< leftArray.count {
            
            
            
            let  database = DatabaseHandler()
            
            let leftString:String = leftArray .object(at: i) as! String
            let rightString:String = rightArray .object(at: i) as! String
            
            
            let tempDetails:[String : Any]
            
            
            if leftString != "" {
                
                
                let lblArray:NSArray = database .getPredefinedLabel(LabelName: leftString)
                
                
                if  lblArray.count != 0 {
                   let labelId:String = database .getPredefinedLabel(LabelName: leftString) .object(at: 0) as! String
                    let descriptionId:String = database .getDescriptionId(DescriptionName: rightString)
                    if descriptionId == "" {
                        tempDetails = ["labelId": labelId,
                                       "label": leftString,
                                       "description": rightString] as [String : Any]
                    }
                    else
                    {
                        tempDetails = ["labelId": labelId,
                                       "label": leftString,
                                       "description": rightString,
                                       "descriptionId": descriptionId] as [String : Any]
                    }
                    
                }
                else
                {
                    tempDetails = ["label": leftString,
                                   "description": rightString] as [String : Any]
                }
                tempDetailsDictionary.append(tempDetails)
                
                
               
                
            }
            
        }
        
        
        print(tempDetailsDictionary)
        
        if (tempDetailsDictionary.count == 0){
            
            showAlert(kEmptyString, message: NSLocalizedString("Please add atleast 1 label", comment: "Please add atleast 1 label"))
        }
        else{
        
        let userProfileId:String = UserDefaults.standard.value(forKey: "userProfileId") as! String
        
        
        let params = [ "templateName": templateNameString,
                       "userProfileId": userProfileId,
                       "templateTypeId": 2,"templateDetails":tempDetailsDictionary] as [String : Any]
        print(params)
        
        showActivityIndicator(false)
        
        let session = URLSession.shared
        let url = String(format:"%@template",kUrlBase)
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
      

                                if let data = jsonData?["data"] as? [String : Any]{
                                    self.database .insertTemplateDetailsAfterAdd(data: data)
                                }
                                
                                
                                
                                
                                
                                
                                let alert = UIAlertController(title: "", message: NSLocalizedString("Template added successfully", comment: "Template added successfully"), preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title:NSLocalizedString( "Ok", comment:  "Ok"), style: .default, handler: { (action: UIAlertAction!) in
                                    self.navigationController?.popViewController(animated: true)
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
    
    
    
    
    
    
    
    func editTemplateAPICall()
    {
        
        
        var tempDetailsDictionary = [[String: Any]]()
        
        
        for i in 0 ..< leftArray.count {
            
            
            let  database = DatabaseHandler()
            
            let leftString:String = leftArray .object(at: i) as! String
            let rightString:String = rightArray .object(at: i) as! String
            
            var templateDetailId:String = ""
            if templateDetailIdArray.count > i {
                templateDetailId = templateDetailIdArray .object(at: i) as! String
            }
            
            
            
            let tempDetails:[String : Any]
            
            
            if leftString != "" {
                
                
                let lblArray:NSArray = database .getPredefinedLabel(LabelName: leftString)
                
                
                if  lblArray.count != 0 {
                    
                    let labelId:String = database .getPredefinedLabel(LabelName: leftString) .object(at: 0) as! String
                    let descriptionId:String = database .getDescriptionId(DescriptionName: rightString)
                    
                    
                    
                    
                    if descriptionId == "" {
                        tempDetails = ["templateDetailId": templateDetailId,
                                        "label": leftString,
                                       "labelId": labelId,
                                       "description": rightString] as [String : Any]
                    }
                    else
                    {
                        
                        tempDetails = ["templateDetailId": templateDetailId,
                                        "label": leftString,
                                       "labelId": labelId,
                                       "description": rightString,
                                       "descriptionId": descriptionId] as [String : Any]
                    }
              
                }
                else
                {
                    tempDetails = ["templateDetailId": templateDetailId,
                                  "label": leftString,
                                    "description": rightString] as [String : Any]
                }
                
                tempDetailsDictionary.append(tempDetails)
            }
            
        }
        
        if (tempDetailsDictionary.count == 0){
            
            showAlert(kEmptyString, message: NSLocalizedString("Please add atleast 1 label", comment: "Please add atleast 1 label"))
        }
        else{
        
        let userProfileId:String = UserDefaults.standard.value(forKey: "userProfileId") as! String
        
        
        let params = [ "templateId": templateId,
                       "templateName": templateNameString,
                       "userProfileId": userProfileId,
                       "templateTypeId": templateTypeId,"templateDetails":tempDetailsDictionary] as [String : Any]
        print(params)
        
        showActivityIndicator(false)
        
        let session = URLSession.shared
    
        let url = String(format:"%@template",kUrlBase)
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        
        
        request.httpMethod = "PUT"
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
                                
                                if let data = jsonData?["data"] as? [String : Any],
                                    let records = data["templateDetails"] as? NSArray
                                {
                                    self.database .deleteTemplateDetails(templateID: self.templateId)
                                    self.database .insertTemplateDetails(array: records)
                                    
                                }
                                
                               
                              
                                let alert = UIAlertController(title: "", message:NSLocalizedString("Template updated successfully", comment: "Template updated successfully") , preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: "Ok"), style: .default, handler: { (action: UIAlertAction!) in
                                    self.navigationController?.popViewController(animated: true)
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
    
    
    
    
    
}
