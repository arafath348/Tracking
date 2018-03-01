//
//  RfidDataDetailsViewController.swift
//  3M L&M
//
//  Created by IndianRenters on 06/09/17.
//  Copyright © 2017 3M L&M. All rights reserved.
//

import UIKit



//protocol tblRFIDLogDataDetailsDelegate: class {
//    func sendRFIDtblLogDataDetails(labelArray: NSArray, rightArray: NSArray, templateName: String)
//}


protocol tblRFIDLogDataDetailsDelegate: class {
    func sendRFIDtblLogDataDetails(bytesArray: [UInt8], templateName: String)
}

class RfidDataDetailsViewController: UIViewController,UITableViewDelegate, UITableViewDataSource,PopupDelegate {
    //For localization
    
    @IBOutlet weak var svaeBtn: UIButton!
    
    @IBOutlet weak var cancelBtn: UIButton!
    
    @IBOutlet weak var descriptnLbl: UILabel!
    
    @IBOutlet weak var lbl: UILabel!
    @IBOutlet weak var doLockLbl: UILabel!
    @IBOutlet weak var doOverwriteLbl: UILabel!
    //____
    var labelArray: NSArray = []
    var descriptionArray: NSArray = []
    var dropDownArray: NSMutableArray = []
    var templateNameString: String = ""
    var datePickerView: UIDatePicker!
    var transView:UIView!
    var actionView:UIView!
    var row: Int = 0
    var freq: String = ""
    
    
    var currentTextField: UITextField!
    var rightArray: NSMutableArray = []
    @IBOutlet weak var templateNameLabel: UILabel!
    @IBOutlet weak var table: UITableView!
    let database = DatabaseHandler()
    weak var delegate: tblRFIDLogDataDetailsDelegate?
    @IBOutlet weak var remainingMemoryLabel: UILabel?
    @IBOutlet weak var lockSegment: UISegmentedControl!
    @IBOutlet weak var overwriteSegment: UISegmentedControl!
    
    var rfidBytesArray : [UInt8] = []
    var language3Bytes = [UInt8]()

    
    
    override func viewDidAppear(_ animated: Bool) {
        //TealiumHelper.trackView(NSStringFromClass(self.classForCoder), dataSources: [:])
        
    }
    func changeLanguage(){
        
lockSegment.setTitle(NSLocalizedString("No", comment: "yes"), forSegmentAt: 0)
        lockSegment.setTitle(NSLocalizedString("Yes", comment: "yes"), forSegmentAt: 1)
        overwriteSegment.setTitle(NSLocalizedString("No", comment: "yes"), forSegmentAt: 0)
        overwriteSegment.setTitle(NSLocalizedString("Yes", comment: "yes"), forSegmentAt: 1)

        self.title = NSLocalizedString("RFID Data Template", comment: "Data Capture")
        DispatchQueue.main.async {
self.svaeBtn.setAttributedTitle(nil, for: UIControlState.normal)
            self.cancelBtn.setAttributedTitle(nil, for: UIControlState.normal)

        self.svaeBtn.setTitle(NSLocalizedString("SAVE", comment: "CANCEL"), for: UIControlState.normal)
        self.cancelBtn.setTitle(NSLocalizedString("CANCEL", comment: "CANCEL"), for: UIControlState.normal)
        
        }
        descriptnLbl.text = NSLocalizedString("Description", comment: "Project Name")
        lbl.text = NSLocalizedString("Label", comment: "Project Name")
        
        doLockLbl.text = NSLocalizedString("Do you want to lock", comment: "Do you want to lock")
        
        doOverwriteLbl.text = NSLocalizedString("Do you want to overwrite", comment: "Do you want to overwrite")
    }
    override func viewWillAppear(_ animated: Bool) {
        
        self.changeLanguage()

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.changeLanguage()

        
        
        // Do any additional setup after loading the view.
        templateNameLabel.text = templateNameString
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
        
        self .remaingMemoryCalculation()
        
        
        lockSegment.selectedSegmentIndex = 0
        overwriteSegment.selectedSegmentIndex = 1
        

        
        
        
        let languageId:String = database.getGlossaryLanguageSettings() .object(at: 0) as! String
                
        if(languageId == "2"){
            language3Bytes = [0, 1, 1] // Spain
        }
        else if(languageId == "3"){
            language3Bytes = [0, 2, 1] // German
        }
        else if(languageId == "10"){
            language3Bytes = [0, 3, 1]  //France French
        }
        else if(languageId == "11"){
            language3Bytes = [0, 18, 1]   //French Canadian
        }
        else if(languageId == "17"){
            language3Bytes = [0, 7, 2]   //Polish
        }
        else if(languageId == "20"){
            language3Bytes = [0, 10, 3]   //Russia
        }
        else{
             language3Bytes = [0, 0, 1]  //English
        }
        
        print(language3Bytes)
        
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
        
        self .remaingMemoryCalculation()
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    
    
    
    //pragma mark - textField Delegate row lifecycle
    
    
    func descTextFieldDidChange(textField: UITextField) {
        
        rightArray.replaceObject(at: textField.tag-100, with: textField.text!)
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) { // became first responder
        
        currentTextField = textField
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
    {
        
        let maxLength = 14
        let currentString: NSString = textField.text! as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
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
        
        let cell : CustomTableViewCell = (tableView.dequeueReusableCell(withIdentifier: "CustomRFIDCell") as! CustomTableViewCell!)
        
        
        cell.leftTextfield.text = labelArray .object(at: indexPath.row) as? String
        cell.rightTextfield.text = rightArray .object(at: indexPath.row) as? String
        cell.rightTextfield.addTarget(self, action: #selector(descTextFieldDidChange(textField:)), for: .editingChanged)
        
        cell.rightDropDownButton.tag = indexPath.row
        
        cell.rightTextfield.tag = indexPath.row + 100
        currentTextField =  cell.rightTextfield
        let dropString:String = dropDownArray[indexPath.row]  as! String
        
        
        
        
        
        
        if dropString == "Textfield" {
            cell.rightDropDownButton.isHidden = true
            cell.rightTextfield.isEnabled = true
            
        }
        else  if dropString == "DropDown" {
            cell.rightDropDownButton.isHidden = false
            cell.rightTextfield.isEnabled = false
            cell.rightDropDownButton.setImage(UIImage(named: "drop down"), for: .normal)
            
            
            
        }
        else  if dropString == "Combo" {
            cell.rightDropDownButton.isHidden = false
            cell.rightTextfield.isEnabled = true
            cell.rightDropDownButton.setImage(UIImage(named: "drop down"), for: .normal)
            
        }
        else if dropString == "Date"{
            cell.rightDropDownButton.isHidden = false
            cell.rightTextfield.isEnabled = false
            cell.rightDropDownButton.setImage(UIImage(named: "calender"), for: .normal)
            
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
        else
        {
            cell.rightDropDownButton.isHidden = true
            cell.rightTextfield.isEnabled = true
        }
        
        
        return cell
    }
    
    
    
    
    
    
    
    
    
    
    
    func doneButtonAction() {
        currentTextField .resignFirstResponder()
    }
    
    
    @IBAction func rightDropDownClicked(sender: UIButton)
    {
        
        
        row = sender.tag
        self.currentTextField.resignFirstResponder()
        
        print(row)
        
        
        
        if sender.currentImage!.isEqual(UIImage(named: "calender")) {
            self.openDatePicker()
        }
            
        else
        {
            
            
            let labelId:String = database .getPredefinedLabel(LabelName: labelArray .object(at: row) as! String) .object(at: 0) as! String
            
            let decriptionIdArray = database .getDescriptionIdArray(LabelId: labelId)
            descriptionArray = database .getDescriptionArray(DescriptionIdArray: decriptionIdArray)
            
            print(descriptionArray)
            if descriptionArray.count == 0 {
                dropDownArray.replaceObject(at: row, with: "Textfield")
                let txtFld : UITextField = self.table!.viewWithTag(row + 100) as! UITextField
                txtFld.isEnabled = true
                sender.isHidden = true
                txtFld.becomeFirstResponder()
            }
            else
            {
                let popOverVC = UIStoryboard(name: "Custom", bundle: nil).instantiateViewController(withIdentifier: "sbPopUpID") as! PopUpViewController
                self.addChildViewController(popOverVC)
                popOverVC.delegate = self
                popOverVC.titleString = NSLocalizedString("Select Description", comment: "Select Description")
                popOverVC.popupArray = self.descriptionArray
                
                
                let string:String = self.rightArray[self.row]  as! String
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
        rightArray.replaceObject(at: row, with: selectedString)
        table? .reloadData()
        self .remaingMemoryCalculation()
        
    }
    
    
    
    
    
    func openDatePicker()
    {
        
        actionSheet()
        
        
        datePickerView = UIDatePicker(frame: CGRect(x: 0, y: 44, width: self.view.frame.size.width, height: 216))
        datePickerView.datePickerMode = UIDatePickerMode.date
        //        datePickerView.minimumDate=NSDate() as Date
        
        
        
        let dateFormatter = DateFormatter()
        // this is imporant - we set our input date format to match our input string
        dateFormatter.dateFormat = "MM/dd/yy"
        
        
        
        let txtFld : UITextField = self.table.viewWithTag(row + 100) as! UITextField
        
        
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
        
        let txtFld : UITextField = self.table!.viewWithTag(row + 100) as! UITextField
        txtFld.text = dateFormatter.string(from: sender.date)
        rightArray.replaceObject(at: row, with:  txtFld.text!)
        
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
        
        table .reloadData()
        self .remaingMemoryCalculation()
        
    }
    
    
    @IBAction func saveButtonClicked()
    {
        
        //        delegate?.sendRFIDtblLogDataDetails(labelArray: labelArray, rightArray: rightArray, templateName: templateNameString)
        //        self.navigationController? .popViewController(animated: true)
        
        
        
        
        var lblDescArray = [UInt8]()
        
        
        for i in 0 ..< labelArray.count {
            
            let leftString:String = labelArray .object(at: i) as! String
            var rightString:String = rightArray .object(at: i) as! String
            
            
            if dropDownArray .object(at: i) as! String == "Date" &&  rightString != "" {
                rightString = rightString.replacingOccurrences(of: "/", with: "")
                rightString = rightString.replacingOccurrences(of: "-", with: "")
            }
            
            
            if(leftString != "" || rightString != ""){
                if leftString != "" {
                    lblDescArray += Array(leftString.utf8)
                }
                lblDescArray += [31]
                
                
                if rightString != "" {
                    lblDescArray += Array(rightString.utf8)
                }
                lblDescArray += [30]
            }
        }
        
        
        var crcValues = [UInt8]()
        crcValues = language3Bytes
        crcValues += lblDescArray
        
        
        let data = Data(bytes: crcValues, count: crcValues.count)
        let crc = CRC16(data: data)
        
        let overWrite:String = String(overwriteSegment.selectedSegmentIndex)
        let lock:String = String(lockSegment.selectedSegmentIndex)
        let numberOfBytes:String = String(lblDescArray.count + 5) // 2 - crc, 3 - language
        
        let crccopy = UInt16(crc)
        let crcb1 = UInt8((crc >> 8) & 0x00FF)
        let crcb2 = UInt8(crccopy & 0x00FF)
        var rfidArray = [UInt8]()
        
        rfidArray = [36, 112, 114, 111, 103, 109, 107, 114, 115, 44]
        rfidArray += freq.utf8
        rfidArray += [44]
        rfidArray += overWrite.utf8
        rfidArray += [44]
        rfidArray += lock.utf8
        rfidArray += [44]
        rfidArray += numberOfBytes.utf8
        rfidArray += [44]
        rfidArray += language3Bytes
        rfidArray += lblDescArray
        rfidArray += [crcb1]
        rfidArray += [crcb2]
        rfidArray += [44, 13, 10]
        
        
        print(rfidArray)
        
        
        delegate?.sendRFIDtblLogDataDetails(bytesArray: rfidArray, templateName: templateNameString)
        self.navigationController? .popViewController(animated: true)
        
        
    }
    

    
    @IBAction func cancelButtonClicked(){
        let alert = UIAlertController(title: NSLocalizedString("Cancel RFID?", comment: "Cancel RFID Template?"), message: NSLocalizedString("Are you sure you want to cancel this RFID template?", comment: "Are you sure you want to cancel this RFID template?"), preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: "Ok"), style: .default, handler: { (action: UIAlertAction!) in
            
            self.delegate?.sendRFIDtblLogDataDetails(bytesArray: [], templateName: "")
            self.navigationController? .popViewController(animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .cancel, handler: { (action: UIAlertAction!) in
        }))
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    
    func CRC16(data : Data)->UInt16{
        let final: UInt32 = 0xffff
        var crc = final
        data.forEach { (byte) in
            crc ^= UInt32(byte) << 8
            (0..<8).forEach({ _ in
                crc = (crc & UInt32(0x8000)) != 0 ? (crc << 1) ^ 0x1021 : crc << 1
            })
        }
        let crcNew = UInt16(UInt32(crc & final))
        
        let str  = String(format:"%2X", crcNew) as NSString

        print(str)
        return crcNew
    }

    

    
    
    
    
    func remaingMemoryCalculation()
    {
        
        
        var bitUsed: Int = 0
        
        
        for i in 0 ..< labelArray.count {
            
            
            
            let  database = DatabaseHandler()
            
            let leftString:String = labelArray .object(at: i) as! String
            let rightString:String = rightArray .object(at: i) as! String
            
            
            if leftString != "" || rightString != ""{
                
                
                
                let lblArray:NSArray = database .getPredefinedLabel(LabelName: leftString)
                let descriptionId:String =  database .getDescriptionId(DescriptionName: rightString)
                
                
                if  lblArray.count != 0 {
                    bitUsed += 11
                }
                else if leftString.characters.count != 0
                {
                    bitUsed +=  10 + (8 * leftString.characters.count)
                }
                
                if descriptionId != "" {
                    bitUsed += 12
                }
                else if dropDownArray .object(at: i) as! String == "Date" && rightString.characters.count != 0
                {
                    bitUsed += 24
                }
                else if rightString.characters.count != 0
                {
                    bitUsed += (8 * rightString.characters.count)
                }
                
            }
        }
        
        
        if bitUsed != 0 {
            bitUsed += 10
        }
        
        
        
        
        let remaingMemory: Int =  ((960 - bitUsed) * 100) / 960
        print(remaingMemory)
        remainingMemoryLabel?.text = String(format:NSLocalizedString("Remaining Memory: %d%%", comment: "Remaining Memory: %d%%"),remaingMemory)
    }
    
    
    
    
    
    
    
    
}
