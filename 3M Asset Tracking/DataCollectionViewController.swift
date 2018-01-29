//
//  DataCollectionViewController.swift
//  3M L&M
//
//  Created by IndianRenters on 23/08/17.
//  Copyright © 2017 3M L&M. All rights reserved.
//

import UIKit

protocol tblLogDataDetailsDelegate: class {
    func sendtblLogDataDetails(labelArray: NSArray, rightArray: NSArray, templateName: String)
}


class DataCollectionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PopupDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate
 {
    var labelArray: NSArray = []
    var descriptionArray: NSMutableArray = []
    var dropDownArray: NSArray = []
    var templateNameString: String = ""
    var datePickerView: UIDatePicker!
    var transView:UIView!
    var actionView:UIView!
    var row: Int = 0
    var currentTextField: UITextField!
    var rightArray: NSMutableArray = []
    @IBOutlet weak var templateNameLabel: UILabel!
    @IBOutlet weak var table: UITableView!

    let database = DatabaseHandler()
    weak var delegate: tblLogDataDetailsDelegate?

    
    let imagePicker = UIImagePickerController()
    

    @IBOutlet weak var saveBtn: UIButton!
    
    @IBOutlet weak var cancelBtn: UIButton!
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
self.title = NSLocalizedString("Data Collection Template", comment: "")
//        self.saveBtn.setTitle(NSLocalizedString("SAVE", comment: "save"), for: UIControlState.normal)
//        self.cancelBtn.setTitle(NSLocalizedString("CANCEl", comment: "save"), for: UIControlState.normal)
        }

        saveBtn.setAttributedTitle(nil, for:  UIControlState.normal)
        cancelBtn.setAttributedTitle(nil, for:  UIControlState.normal)

       saveBtn.setTitle(NSLocalizedString("SAVE", comment: "save"), for: UIControlState.normal)
     cancelBtn.setTitle(NSLocalizedString("CANCEL", comment: "save"), for: UIControlState.normal)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            self.title = NSLocalizedString("Data Collection Template", comment: "")
//            self.saveBtn.setTitle(NSLocalizedString("SAVE", comment: "save"), for: UIControlState.normal)
//            self.cancelBtn.setTitle(NSLocalizedString("CANCEL", comment: "save"), for: UIControlState.normal)
        }

        // Do any additional setup after loading the view.
        templateNameLabel.text = templateNameString
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
        
        
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        //TealiumHelper.trackView(NSStringFromClass(self.classForCoder), dataSources: [:])
        
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
    
    
    
    
    // MARK:  UITableView Data Source Methods
    private func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat    {
        return 76
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return labelArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : CustomTableViewCell = (tableView.dequeueReusableCell(withIdentifier: "CustomDataCollectionCell") as! CustomTableViewCell!)
        cell.titleLabel.text = labelArray .object(at: indexPath.row) as? String
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
            cell.rightDropDownButton.setImage(UIImage(named: "calender"), for: .normal)
            cell.rightTextfield.isEnabled = false
            
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
            cell.rightDropDownButton.setImage(UIImage(named: "camera"), for: .normal)
            cell.rightTextfield.isEnabled = false
//            cell.rightTextfield.text = ""
        }
        else  if dropString == "Barcode" {
            cell.rightDropDownButton.isHidden = false
            cell.rightDropDownButton.setImage(UIImage(named: "barcode"), for: .normal)
            cell.rightTextfield.isEnabled = false
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
        
        
        
        print(sender.currentImage!)
     
        if sender.currentImage!.isEqual(UIImage(named: "calender")) {
            self.openDatePicker()
        }
        else if sender.currentImage!.isEqual(UIImage(named: "barcode")) {
            self.openBarcodeScanner()
        }
        else if sender.currentImage!.isEqual(UIImage(named: "camera")) {
            self.openCamera()
        }
        else
        {
        
            
            let labelId:String = database .getPredefinedLabel(LabelName: labelArray .object(at: row) as! String) .object(at: 0) as! String
            
            let decriptionIdArray = database .getDescriptionIdArray(LabelId: labelId)
            descriptionArray = database .getDescriptionArray(DescriptionIdArray: decriptionIdArray)
    
            
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
    
    
    
    
    
    func selectedValue(_ selectedString: String){
        rightArray.replaceObject(at: row, with: selectedString)
        table? .reloadData()
        
    }
    
    
    func openCamera() {
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    //uiimagepickercontroller delegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

        
       
        
        DispatchQueue.global(qos: .background).async {
            

            var pickedImage = UIImage()
            pickedImage = info[UIImagePickerControllerEditedImage] as! UIImage
            
            let newImage: UIImage = self.compressImage(pickedImage)
            
         
            
            let currentDateTime = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyyMMddHHmmss"
            let fileNameWithExtension = "~img~_\(formatter.string(from: currentDateTime)).jpg"
            //create path
            let imagePath = self.fileInDocumentsDirectory(filename: fileNameWithExtension)
            
            if self.saveImage(image: newImage, path: imagePath) {

                self.rightArray.replaceObject(at: self.row, with: fileNameWithExtension)
            }
            
          
            
            DispatchQueue.main.async(execute: {
                picker.dismiss(animated: true, completion: nil)
                let txtFld : UITextField = self.table.viewWithTag(self.row + 100) as! UITextField
                txtFld.text = fileNameWithExtension

            })
            
            
            
       
        }
        
        
       
        
    }
    
    
    func fileInDocumentsDirectory(filename: String)-> URL {
        return try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(filename)
        
    }
    
    func saveImage(image: UIImage, path: URL) -> Bool {
        guard let binaryImageData = UIImageJPEGRepresentation(image, 0.5) else {
            print("error")
            return false
        }
        
        
        let imageSize: Int = binaryImageData.count
        print("size of image in KB: %f ", Double(imageSize) / 1024.0)
        
        var resultValid = false
        do {
            try binaryImageData.write(to: path, options: [.atomic])
            resultValid = true
        }
        catch {
            resultValid = false
            print(error)
        }
        return resultValid
    }
    
    
    
    func compressImage (_ image: UIImage) -> UIImage {
        
        let actualHeight:CGFloat = image.size.height
        let actualWidth:CGFloat = image.size.width
        let imgRatio:CGFloat = actualWidth/actualHeight
        let maxWidth:CGFloat = 1024.0
        let resizedHeight:CGFloat = maxWidth/imgRatio
        let compressionQuality:CGFloat = 0.5
        
        let rect:CGRect = CGRect(x: 0, y: 0, width: maxWidth, height: resizedHeight)
        UIGraphicsBeginImageContext(rect.size)
        image.draw(in: rect)
        let img: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        let imageData:Data = UIImageJPEGRepresentation(img, compressionQuality)!
        UIGraphicsEndImageContext()
        
        return UIImage(data: imageData)!
        
    }

    
        func openBarcodeScanner() {

            let barcodeScanner = self.storyboard!.instantiateViewController(withIdentifier: "BarcodeScannerViewController") as! BarcodeScannerViewController
            
            
            // Define the callback which is executed when the barcode has been scanned
            barcodeScanner.barcodeScanned = { (barcode:String) in
                
                // When the screen is tapped, return to first view (barcode is beeing passed as param)
                print("Received following barcode: \(barcode)")
                
                DispatchQueue.main.async {
                    
                    let txtFld : UITextField = self.table.viewWithTag(self.row + 100) as! UITextField
                    txtFld.text = "\(barcode)"
                    self.rightArray.replaceObject(at: self.row, with:  txtFld.text!)

                    
                }
            }
            
            self.navigationController!.pushViewController(barcodeScanner, animated: true)

            
            
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
        
        let txtFld : UITextField = self.table.viewWithTag(row + 100) as! UITextField
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
    }


   @IBAction func saveButtonClicked()
    {
    
        delegate?.sendtblLogDataDetails(labelArray: labelArray, rightArray: rightArray, templateName: templateNameString)
         self.navigationController? .popViewController(animated: true)
    }
    
    @IBAction func cancelButtonClicked()
    {
        let alert = UIAlertController(title: NSLocalizedString("Cancel Data Collection Template?", comment: "Cancel Data Collection Template?"), message: NSLocalizedString("Are you sure you want to cancel data collection template?", comment: "Are you sure you want to cancel data collection template?"), preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: "Ok"), style: .default, handler: { (action: UIAlertAction!) in
            
            self.deleteImages()
            self.delegate?.sendtblLogDataDetails(labelArray:[], rightArray:[], templateName:"")
            self.navigationController?.popViewController(animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .cancel, handler: { (action: UIAlertAction!) in
            
        }))
        
        present(alert, animated: true, completion: nil)

    }
    
    

    
    func deleteImages() {
        let fileManager = FileManager.default
        let documentDirectoryURL =  try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let documentsPath:String = documentDirectoryURL.path
        
        
        
        do {
            for filePath in rightArray{
                

                
                if(String((filePath as! String).characters.prefix(6)) == "~img~_"){
                let deletePath:String = String(format:"%@/%@",documentsPath,filePath as! CVarArg)
                try fileManager.removeItem(atPath: deletePath)
                }
            }
        } catch let error as NSError {
            print("Could not clear temp folder: \(error.debugDescription)")
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
