//
//  FirstLoginViewController.swift
//  3M L&M
//
//  Created by dcwaters on 11/07/17.
//  Copyright © 2017 3M L&M. All rights reserved.
//

import UIKit

class FirstLoginViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,SearchBarDelegate {
    //For Localization
    @IBOutlet weak var yesBtn: UIButton!
    
    @IBOutlet weak var yesBtnView2: UIButton!
    @IBOutlet weak var noBtn: UIButton!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var firstName: UILabel!
    
    @IBOutlet weak var noBtnView2: UIButton!
    @IBOutlet weak var lastName: UILabel!
    
    @IBOutlet weak var newpswdLbl: UILabel!
    @IBOutlet weak var whatproductsLbl: UILabel!
    
    @IBOutlet weak var nxtBtn: UIButton!
    @IBOutlet weak var showBtn2: UIButton!
    @IBOutlet weak var showBtn1: UIButton!
    @IBOutlet weak var confirmpswdLbl: UILabel!
    @IBOutlet weak var primaryPhoneNumberLbl: UILabel!
    
    @IBOutlet weak var primaryEmailLbl: UILabel!
    
    @IBOutlet weak var utilityCoLbl: UILabel!
    
    @IBOutlet weak var doULbl: UILabel!//Do you work for an installer company
    
    
    @IBOutlet weak var installerCoLbl: UILabel!
    
    @IBOutlet weak var nxtBtn2: UIButton!
    
    @IBOutlet weak var primaryJobDesLbl: UILabel!
    @IBOutlet weak var primaryFuncAreaLbl: UILabel!
    
    
    @IBOutlet weak var nxtBtn3: UIButton!
    
    @IBOutlet weak var cableBtn: UIButton!
    @IBOutlet weak var bothBtn: UIButton!
    
    @IBOutlet weak var rfidBtn: UIButton!
    
    @IBOutlet weak var AreULbl: UILabel!//Are you a distributor?
    
    @IBOutlet weak var secQues1Lbl: UILabel!
    
    @IBOutlet weak var secQues2Lbl: UILabel!
    
    @IBOutlet weak var loginBtn: UIButton!
    
    //installerCompanyView
    @IBOutlet weak var companyNameLbl: UILabel!
    
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
    //---------

    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view4: UIView!
    @IBOutlet weak var companyView: UIView!
    @IBOutlet weak var companyInnerView: UIView!
    @IBOutlet weak var installerCompanyView: UIView!
    @IBOutlet weak var installerCompanyInnerView: UIView!
    
  
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    
    @IBOutlet weak var primaryPhoneTextField: UITextField!
    @IBOutlet weak var primaryEmailTextField: UITextField!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var installerCompanyLabel: UILabel!

    
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

    
    
    @IBOutlet weak var productsTextField: UITextField!
    @IBOutlet weak var rfidRadioButton: UIButton!
    @IBOutlet weak var mvRadioButton: UIButton!
    @IBOutlet weak var bothRadioButton: UIButton!
    
    
    @IBOutlet weak var distributorRadioButton1: UIButton!
    @IBOutlet weak var distributorRadioButton2: UIButton!
    @IBOutlet weak var contractorRadioButton1: UIButton!
    @IBOutlet weak var contractorRadioButton2: UIButton!
    @IBOutlet weak var securityQuestion1Label: UILabel!
    @IBOutlet weak var securityQuestion2Label: UILabel!

    
    @IBOutlet weak var securityAnswer1TextField: UITextField!
    @IBOutlet weak var securityAnswer2TextField: UITextField!
    @IBOutlet weak var distributorTextField: UITextField!
    
    var utilityCompanyTypeArray: NSArray = []
    var utilityCompanyTypeIdArray: NSArray = []
    
    var transView:UIView!
    var actionView:UIView!
    var selectedRow = 0;
    var picker = UIPickerView()
    var companyArray: NSArray = []
    
    var insatallerCompanyArray: NSArray = []
    var securityQuestionsArray1: NSMutableArray = []
    var securityQuestionsArray2: NSMutableArray = []
    var securityQuestionIdArray1: NSMutableArray = []
    var securityQuestionIdArray2: NSMutableArray = []
    var securityQuestion1Id: Int = 0
    var securityQuestion2Id: Int = 0
    var utilityCompanyTypeId: Int = 0
    var functionTypeID: String = "1"
    var utilityCompanyIDString: String = ""
    var installerCompanyIDString: String = ""
    var currentTextField: UITextField!
    let backButton = UIButton(type: .custom)
    var companyInnerViewYposition:CGFloat!
    var installerCompanyInnerViewYposition:CGFloat!
    var isCancelScreen:Bool = false
    var navBarHeight: CGFloat = 0

    
    
    
    override func viewDidAppear(_ animated: Bool) {
      self.navigationItem.setHidesBackButton(true, animated:false)
        self.title = NSLocalizedString("First Login", comment: "First Login")
    //TealiumHelper.trackView(NSStringFromClass(self.classForCoder), dataSources: [:])

    }
   
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationItem.setHidesBackButton(false, animated:false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //self.changeLanguage()
    }
    func changeLanguage(){
        self.title = NSLocalizedString("First Login", comment: "Firstlogin")
        
        //For Localization
        
        DispatchQueue.main.async {
            
        
        
        self.nxtBtn.setTitle(NSLocalizedString("NEXT", comment: "Login"), for: UIControlState.normal)
          self.showBtn2.setTitle(NSLocalizedString("SHOW", comment: "Login"), for: UIControlState.normal)
          self.showBtn1.setTitle(NSLocalizedString("SHOW", comment: "Login"), for: UIControlState.normal)
          self.nxtBtn2.setTitle(NSLocalizedString("NEXT", comment: "Login"), for: UIControlState.normal)
          self.nxtBtn3.setTitle(NSLocalizedString("NEXT", comment: "Login"), for: UIControlState.normal)
          self.cableBtn.setTitle(NSLocalizedString("Cable Accesories", comment: "Login"), for: UIControlState.normal)
        self.bothBtn.setTitle(NSLocalizedString("Both", comment: "Login"), for: UIControlState.normal)
        self.rfidBtn.setTitle(NSLocalizedString("RFID Marker / EMS Passive Marker", comment: "Login"), for: UIControlState.normal)
        self.loginBtn.setTitle(NSLocalizedString("Login", comment: "Login"), for: UIControlState.normal)
        
        self.userName.text = NSLocalizedString("Username", comment: "")
        self.firstName.text = NSLocalizedString("First Name", comment: "")
        self.lastName.text = NSLocalizedString("Last Name", comment: "")
        self.newpswdLbl.text = NSLocalizedString("New Password", comment: "")
        self.confirmpswdLbl.text = NSLocalizedString("Confirm Password", comment: "")
        self.primaryPhoneNumberLbl.text = NSLocalizedString("Primary Phone Number", comment: "")
        self.primaryEmailLbl.text = NSLocalizedString("Primary Email", comment: "")
        self.whatproductsLbl.text = NSLocalizedString("What products do you normally buy from 3M?", comment: "")

        self.doULbl.text = NSLocalizedString("Do you work for an installer company?", comment: "")
        self.primaryJobDesLbl.text = NSLocalizedString("Primary Job Description", comment: "")
        self.primaryFuncAreaLbl.text = NSLocalizedString("Primary Functional Area", comment: "")
        self.AreULbl.text = NSLocalizedString("Are you a distributor?", comment: "")
       
        self.secQues1Lbl.text = NSLocalizedString("Security Question 1", comment: "")
        self.secQues2Lbl.text = NSLocalizedString("Security Question 2", comment: "")
        self.companyNameLbl.text = NSLocalizedString("Company Name", comment: "")
       
        self.installerCoLbl.text = NSLocalizedString("Installer Company", comment: "")
        self.utilityCoLbl.text = NSLocalizedString("Utility Company", comment: "")
        self.insFirstNameLbl.text = NSLocalizedString("First Name", comment: "")
        self.insLastNameLbl.text = NSLocalizedString("Last Name", comment: "")
        self.insprimaryContactNoLbl.text = NSLocalizedString("Primary Phone Number", comment: "")
        self.insEmailLbl.text = NSLocalizedString("Email", comment: "")
        self.utilcompanyNameLbl.text = NSLocalizedString("Company Name", comment: "")
        self.utilFirstNameLbl.text = NSLocalizedString("First Name", comment: "")
        self.utilLastNameLbl.text = NSLocalizedString("Last Name", comment: "")
        self.utilprimaryContactNoLbl.text = NSLocalizedString("Primary Phone Number", comment: "")
        self.utilEmailLbl.text = NSLocalizedString("Email", comment: "")
        self.utilCoTypeLbl.text = NSLocalizedString("Utility Company Type", comment: "")
        self.insaddBtn.setTitle(NSLocalizedString("ADD", comment: "Login"), for: UIControlState.normal)
        self.inscancelBtn.setTitle(NSLocalizedString("CANCEL", comment: "CANCEL"), for: UIControlState.normal)
        self.utiladdBtn.setTitle(NSLocalizedString("ADD", comment: "Login"), for: UIControlState.normal)
        self.utilcancelBtn.setTitle(NSLocalizedString("CANCEL", comment: "CANCEL"), for: UIControlState.normal)
        self.yesBtn.setTitle(NSLocalizedString("YES", comment: "CANCEL"), for: UIControlState.normal)
        self.noBtn.setTitle(NSLocalizedString("NO", comment: "CANCEL"), for: UIControlState.normal)
            self.yesBtnView2.setTitle(NSLocalizedString("YES", comment: "CANCEL"), for: UIControlState.normal)
            self.noBtnView2.setTitle(NSLocalizedString("NO", comment: "CANCEL"), for: UIControlState.normal)
            
        }

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
         self.changeLanguage()
                
        companyInnerView.layer.cornerRadius = 8
        installerCompanyInnerView.layer.cornerRadius = 8

        
        let iconSize = CGRect(origin: CGPoint.zero, size: CGSize(width: 21, height: 44))
        let backButton = UIButton(frame: iconSize)
        backButton.setImage(UIImage(named: "customBackArrow1.png"), for: .normal)
        backButton.addTarget(self, action: #selector(self.customBackButton(sender:)), for: .touchUpInside)
        backButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        backButton.tag = 0
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)

 
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(self.securityQuestion1Clicked))
        securityQuestion1Label.addGestureRecognizer(tap1)

        let tap2 = UITapGestureRecognizer(target: self, action: #selector(self.securityQuestion2Clicked))
        securityQuestion2Label.addGestureRecognizer(tap2)
        
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(self.companyClicked))
        companyLabel.addGestureRecognizer(tap3)
       
        let tap4 = UITapGestureRecognizer(target: self, action: #selector(self.installerCompanyClicked))
        installerCompanyLabel.addGestureRecognizer(tap4)
        
        let tap5 = UITapGestureRecognizer(target: self, action: #selector(self.getUtilityCompanyType))
        addCompanyTypeLabel.addGestureRecognizer(tap5)
        

        
        companyInnerViewYposition = self.companyInnerView?.frame.origin.y
        installerCompanyInnerViewYposition = self.installerCompanyInnerView?.frame.origin.y

        
        currentTextField = userTextField
        
        self .addNextButton()
        
        navBarHeight = UIApplication.shared.statusBarFrame.height + self.navigationController!.navigationBar.frame.height
        


    }
    
 
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func addNextButton() {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                            target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(title: NSLocalizedString("Next", comment: "Next"), style: .plain, target:self, action: #selector(self.nextButtonAction))
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        primaryPhoneTextField.inputAccessoryView = keyboardToolbar
        addcontactNoTextField.inputAccessoryView = keyboardToolbar
        addInstallercontactNoTextField.inputAccessoryView = keyboardToolbar

        
    }
    
    
    func nextButtonAction()
    {
        
        if currentTextField == self.primaryPhoneTextField {
            
            if !validatePhoneWithString(primaryPhoneTextField.text!){
                showAlert(kEmptyString, message: NSLocalizedString("Please enter a 10 digit valid primary phone number", comment: "Please enter a 10 digit valid primary phone number"))
            }
            else
            {
                self.primaryEmailTextField.becomeFirstResponder()
            }
            
        }
   
        else if currentTextField == self.addcontactNoTextField {
            
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
    
    
    func validateData1() -> Bool {
        
        let userName = userTextField.text!.trimmingCharacters(in: NSCharacterSet.whitespaces)
        let firstName = firstNameTextField.text!.trimmingCharacters(in: NSCharacterSet.whitespaces)
        let password = passwordTextField.text!.trimmingCharacters(in: NSCharacterSet.whitespaces)
        let confirmPassword = confirmPasswordTextField.text!.trimmingCharacters(in: NSCharacterSet.whitespaces)
        
        
        var alertMessage = kEmptyString
        if userName .isEmpty {
            alertMessage.append(NSLocalizedString("Please enter username", comment: "Please enter username"))
        }
        else if !(userTextField.text!.characters.count >= 8 &&  userTextField.text!.characters.count <= 15)
        {
            alertMessage.append(NSLocalizedString("Please enter a valid username. Your username length should be 8 to 15 characters", comment: "Please enter a valid username. Your username length should be 8 to 15 characters"))
          
        }
        else if firstName.isEmpty {
              alertMessage.append(NSLocalizedString("Please enter first name", comment: "Please enter first name"))
        }
        else if password.isEmpty {
              alertMessage.append(NSLocalizedString("Please enter password", comment: "Please enter password"))
        }
        else if !(passwordTextField.text!.characters.count >= 8 &&  passwordTextField.text!.characters.count <= 15)
        {
              alertMessage.append(NSLocalizedString("Please enter a valid password. Your password length should be 8 to 15 characters", comment: "Please enter a valid password. Your password length should be 8 to 15 characters"))
        }
        else if !isPasswordValid(passwordTextField.text!)
        {
              alertMessage.append(NSLocalizedString("Please enter a valid new password. Your new password should contain atleast 1 uppercase and a numeric", comment: "Please enter a valid new password. Your new password should contain atleast 1 uppercase and a numeric"))
        }
        else if confirmPassword.isEmpty {
              alertMessage.append(NSLocalizedString("Please enter confirm password", comment: "Please enter confirm password"))
        }
        else if passwordTextField.text != confirmPasswordTextField.text {
              alertMessage.append(NSLocalizedString("New password and confirm password doesn't match", comment: "New password and confirm password doesn't match"))
        }
        


        
        if alertMessage.isEmpty {
            return true
        }
        
        showAlert(kEmptyString, message: alertMessage)
        return false
        
        
        
    }
    
    
    
    func validateData2() -> Bool {
        
        var alertMessage = kEmptyString
        
        let primaryEmail = primaryEmailTextField.text!.trimmingCharacters(in: NSCharacterSet.whitespaces)
        
        
        if (primaryPhoneTextField.text? .isEmpty)! {
              alertMessage.append(NSLocalizedString("Please enter primary phone number", comment: "Please enter primary phone number"))
        }
        else if !validatePhoneWithString(primaryPhoneTextField.text!){
              alertMessage.append(NSLocalizedString("Please enter a 10 digit valid primary phone number", comment: "Please enter a 10 digit valid primary phone number"))
        }
      
        else if (primaryEmail .isEmpty) {
              alertMessage.append(NSLocalizedString("Please enter primary email", comment: "Please enter primary email"))
        }
        else if !validateEmailWithString(primaryEmailTextField.text) {
              alertMessage.append(NSLocalizedString("Please enter a valid primary email address", comment: "Please enter a valid primary email address"))
        }
       
        else if (companyLabel.text? .isEmpty)! {
              alertMessage.append(NSLocalizedString("Please select company", comment: "Please select company"))
        }
        else  if(installerCompanyLabel.isUserInteractionEnabled == true && installerCompanyLabel.text! .isEmpty)
        {
              alertMessage.append(NSLocalizedString("Please select installer company name", comment: "Please select installer company name"))
        }
        
            
        
        if alertMessage.isEmpty {
            return true
        }
        
        showAlert(kEmptyString, message: alertMessage)
        return false
        
    }
    

    
    func validateData4() -> Bool {
        
        
        let distributor = distributorTextField.text!.trimmingCharacters(in: NSCharacterSet.whitespaces)
        let security1 = securityAnswer1TextField.text!.trimmingCharacters(in: NSCharacterSet.whitespaces)
        let security2 = securityAnswer2TextField.text!.trimmingCharacters(in: NSCharacterSet.whitespaces)
        
        var alertMessage = kEmptyString
        
        
        if(distributorTextField.isEnabled == true && distributor .isEmpty)
        {
              alertMessage.append(NSLocalizedString("Please enter distributor name", comment: "Please enter distributor name"))
        }
     
            
        else if(securityQuestion1Label.text! .isEmpty)
        {
              alertMessage.append(NSLocalizedString("Please select security question 1", comment: "Please select security question 1"))
        }
        else if(security1 .isEmpty)
        {
              alertMessage.append(NSLocalizedString("Please answer for security question 1", comment: "Please answer for security question 1"))
        }
        else if(securityQuestion2Label.text! .isEmpty)
        {
              alertMessage.append(NSLocalizedString("Please select security question 2", comment: "Please select security question 2"))
        }
        else if(security2 .isEmpty)
        {
              alertMessage.append(NSLocalizedString("Please answer for security question 2", comment: "Please answer for security question 2"))
        }
        
        if alertMessage.isEmpty {
            return true
        }
        
        showAlert(kEmptyString, message: alertMessage)
        return false
        
    }
    
    
    
    
    
    @IBAction func nextButtonClicked(sender: UIButton) {

        currentTextField .resignFirstResponder()

        

        
        if sender.tag == 1 {
            if validateData1(){
                view1.isHidden = true
                backButton.tag = sender.tag + 1
            }
        }
        else if sender.tag == 2 {
            if validateData2(){
                view2.isHidden = true
                backButton.tag = sender.tag + 1
            }
        }
        else if sender.tag == 3 {
            backButton.tag = sender.tag + 1
               getAllSecurityQuestionsList()
        }
        else
        {
            if validateData4(){
            self .registerApiCall()
        }
        
    }

        
        print(backButton.tag)
        
        
}
    
    
    func customBackButton(sender: UIButton){
        
        
        
        
        if backButton.tag == 0 {
            isCancelScreen = true

            let alert = UIAlertController(title: NSLocalizedString("Cancel First Login?", comment: "Cancel First Login?"), message: NSLocalizedString("Are you sure you want to cancel this first login?", comment: "Are you sure you want to cancel this first login?"), preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Ok"), style: .default, handler: { (action: UIAlertAction!) in
                self.navigationController?.popViewController(animated: true)
            }))
            
            alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .cancel, handler: { (action: UIAlertAction!) in
                self.isCancelScreen = false

            }))
            
            present(alert, animated: true, completion: nil)

            
            
        }
        else if backButton.tag == 2 {
            installerCompanyView.isHidden = true
            companyView.isHidden = true
            view1.isHidden = false
         
            
            backButton.tag = 0
        }
        else if backButton.tag == 3 {
            view2.isHidden = false
            backButton.tag = 2
            
        }
        else if backButton.tag == 4 {
            view3.isHidden = false
            backButton.tag = 3
            
        }
        
        currentTextField .resignFirstResponder()

        
    }
    
    
    
    
    //pragma mark - textField Delegate row lifecycle
    
    func textFieldDidBeginEditing(_ textField: UITextField) { // became first responder
        
        currentTextField = textField
        
        //move textfields up
        let myScreenRect: CGRect = UIScreen.main.bounds
        let keyboardHeight : CGFloat

        
        if companyView?.isHidden == false || installerCompanyView?.isHidden == false {
            keyboardHeight = 350 + navBarHeight
        }
        else{
            keyboardHeight = 305
        }
        
        
        UIView.beginAnimations( "animateView", context: nil)
        let movementDuration:TimeInterval = 0.35
        
        
        var needToMove: CGFloat = -navBarHeight
        
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
            frame.origin.y = navBarHeight
            self.view.frame = frame
        }
        
        
        
        UIView.setAnimationDuration(movementDuration)
        UIView.commitAnimations()
        
        
 
        
        
        if (textField == self.userTextField && isCancelScreen == false){
            if (userTextField.text!.characters.count >= 8 &&  userTextField.text!.characters.count <= 15){
                self.validateUsernameApi()
            }
            else if !(userTextField.text! .isEmpty) {
                         showAlert(kEmptyString, message: NSLocalizedString("Please enter a valid username. Your username length should be 8 to 15 characters", comment: "Please enter a valid username. Your username length should be 8 to 15 characters"))
            }

        }
        else if textField == self.firstNameTextField {
            self.lastNameTextField.becomeFirstResponder()
        }
        else if textField == self.lastNameTextField {
            self.passwordTextField.becomeFirstResponder()
        }
        else if textField == self.passwordTextField {
            self.confirmPasswordTextField.becomeFirstResponder()
        }
    
        
        else if textField == self.addCompanyTextField {
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
    
    

    
    @IBAction func selectPrimaryFunction(sender: UIButton) {
        let selectionTag: Int = sender.tag
        
        rfidRadioButton.setBackgroundImage(UIImage(named: "radio_btn_off.png"), for: .normal)
        mvRadioButton.setBackgroundImage(UIImage(named: "radio_btn_off.png"), for: .normal)
        bothRadioButton.setBackgroundImage(UIImage(named: "radio_btn_off.png"), for: .normal)
        
        
        
        if selectionTag == 1 {
            rfidRadioButton.setBackgroundImage(UIImage(named: "radio_btn_on.png"), for: .normal)
            functionTypeID = "1"
        }
        else if selectionTag == 2 {
            mvRadioButton.setBackgroundImage(UIImage(named: "radio_btn_on.png"), for: .normal)
            functionTypeID = "2"
        }
        else
        {
            bothRadioButton.setBackgroundImage(UIImage(named: "radio_btn_on.png"), for: .normal)
            functionTypeID = "3"
        }
        
        
    }
    
    
    
    @IBAction func selectDistributor(sender: UIButton) {
        let selectionTag: Int = sender.tag
        
        distributorRadioButton1.setBackgroundImage(UIImage(named: "radio_btn_off.png"), for: .normal)
        distributorRadioButton2.setBackgroundImage(UIImage(named: "radio_btn_off.png"), for: .normal)
        
        
        
        if selectionTag == 1 {
            distributorRadioButton1.setBackgroundImage(UIImage(named: "radio_btn_on.png"), for: .normal)
            distributorTextField.isEnabled = true
        }
        else
        {
            distributorRadioButton2.setBackgroundImage(UIImage(named: "radio_btn_on.png"), for: .normal)
            distributorTextField.isEnabled = false
            distributorTextField.text = ""
            
        }
    }
    
    
    
    @IBAction func selectContractor(sender: UIButton) {
        let selectionTag: Int = sender.tag
        
        contractorRadioButton1.setBackgroundImage(UIImage(named: "radio_btn_off.png"), for: .normal)
        contractorRadioButton2.setBackgroundImage(UIImage(named: "radio_btn_off.png"), for: .normal)
        
        
        if selectionTag == 1 {
            contractorRadioButton1.setBackgroundImage(UIImage(named: "radio_btn_on.png"), for: .normal)
            installerCompanyLabel.isUserInteractionEnabled = true
            installerCompanyLabel.text = ""
        }
        else
        {
            contractorRadioButton2.setBackgroundImage(UIImage(named: "radio_btn_on.png"), for: .normal)
            installerCompanyLabel.isUserInteractionEnabled = false
            installerCompanyLabel.text = ""

        }
    }
    
    
    
    
    public func numberOfComponents(in pickerView:  UIPickerView) -> Int  {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if (picker.tag == 101){
            return securityQuestionsArray1.count
        }
        else if (picker.tag == 102){
            return securityQuestionsArray2.count
        }
        else if (picker.tag == 103){
            return utilityCompanyTypeArray.count
        }
        return 0
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let pickerLabel = UILabel(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 30))
        pickerLabel.textAlignment = .center
        pickerLabel.backgroundColor = UIColor.clear
        pickerLabel.font = UIFont(name: "3MCircularTT-Book", size: 14)
        
        
       if (picker.tag == 101){
            pickerLabel.text =  securityQuestionsArray1.object(at: row) as? String
        }
        else if (picker.tag == 102){
            pickerLabel.text =  securityQuestionsArray2.object(at: row) as? String
        }
       else if (picker.tag == 103){
        pickerLabel.text =  utilityCompanyTypeArray.object(at: row) as? String
        }
        
        
        return pickerLabel
        
        
    }
    
    
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedRow = row;
        
        print(selectedRow)
        
        
       if (picker.tag == 101){
            securityQuestion1Label.text = securityQuestionsArray1.object(at: row) as? String
            securityQuestion1Id = securityQuestionIdArray1.object(at: row) as! Int
            
        }
        else if (picker.tag == 102){
            securityQuestion2Label.text = securityQuestionsArray2.object(at: row) as? String
            securityQuestion2Id = securityQuestionIdArray2.object(at: row) as! Int
            
        }
       else if (picker.tag == 103){
        addCompanyTypeLabel.text = utilityCompanyTypeArray.object(at: row) as? String
        utilityCompanyTypeId = utilityCompanyTypeIdArray.object(at: row) as! Int

        }
        
     
        
        
        
}
    
    
    func validateUsernameApi()
    {
        
        let Parameter:String = String(format:"user/check-avilable-username/%@",userTextField.text!)
        
        RestApiManager.sharedInstance.getRandomUser(Parameter as String)
        {
            json in
            let status = json["status"]
            let data = json["data"]
          
            print(data)
            
        DispatchQueue.main.async {
                hideActivityIndicator()
            
            
            if(status == "Success")
            {
                
                if ((data.object as! NSDictionary).value(forKey: "userNameAvailable") as! Bool) == false{
                    showAlert(kEmptyString, message: NSLocalizedString("Username already exists", comment: "Username already exists"))
                    self.userTextField.text = ""
                    self.userTextField.becomeFirstResponder()
              }
              else
                {
                    self.firstNameTextField.becomeFirstResponder()
                }
                
                
            }
         }
            
        }
        
    }
    

    
    
    
    
    
    

    
    

    func registerApiCall()
    {
        showActivityIndicator(false)
        
        let session = URLSession.shared
        
        
        let url = String(format:"%@user/register",kUrlBase)
        
        
        
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        request.httpMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        


        let newCompany = ["utilityCompanyId": "",
                          "utilityCompanyTypeId": utilityCompanyTypeId,
                          "utilityCompanyName": self.addCompanyTextField.text!,
                          "primaryContactFirstName":self.addFirstNameTextField.text!,
                          "primaryContactLastName":self.addLastNameTextField.text!,
                          "primaryContactPhone1":self.addcontactNoTextField.text!,
                          "primaryContactEmail1":self.addemailTextField.text!] as [String : Any]
        

        
        
        
        let oldCompany = ["utilityCompanyId": utilityCompanyIDString] as [String : Any]
        
        
        let companyString : [String : Any]
        if utilityCompanyIDString == "" {
            companyString = newCompany
        }
        else
        {
           companyString = oldCompany
        }
        
        
        
        
        let newInsatallerCompany = ["installerCompanyId": "",
                          "installerCompanyName": addInstallerCompanyTextField.text!,
                          "primaryContactFirstName":addcontactNoTextField.text!,
                          "primaryContactLastName":addLastNameTextField.text!,
                          "primaryContactPhone1":addcontactNoTextField.text!,
                          "primaryContactEmail1":addemailTextField.text!] as [String : Any]
        
        
        
        
        let oldInsatallerCompany = ["installerCompanyId": installerCompanyIDString] as [String : Any]
        
         var params = [String : Any]()
        
        
        if (installerCompanyLabel.isUserInteractionEnabled == true){
            let installerCompany : [String : Any]

        if installerCompanyIDString == "" {
            installerCompany = newInsatallerCompany
        }
        else
        {
            installerCompany = oldInsatallerCompany
        }
            
            
            params = ["userName" : self.userTextField.text!,
                          "password" : self.passwordTextField.text!,
                          "firstName":self.firstNameTextField.text!,
                          "lastName" : self.lastNameTextField.text!,
                          "primaryPhoneNo" : self.primaryPhoneTextField.text!,
                          "secondaryPhoneNo":"",
                          "primaryEmail" : self.primaryEmailTextField.text!,
                          "secondaryEmail" : "",
                          "securityQuestion1Id":securityQuestion1Id,
                          "securityAnswer1" : self.securityAnswer1TextField.text!,
                          "securityQuestion2Id" : securityQuestion2Id,
                          "securityAnswer2":self.securityAnswer2TextField.text!,
                          "profiles": [["productsBought": self.productsTextField.text!,
                                        "functionTypeId": functionTypeID,
                                        "distributorName": self.distributorTextField.text!,
                                        "utilityCompany":companyString,
                                        "installerCompany": installerCompany]]] as [String : Any]
            
        }
        else
        {
            
            params = ["userName" : self.userTextField.text!,
                      "password" : self.passwordTextField.text!,
                      "firstName":self.firstNameTextField.text!,
                      "lastName" : self.lastNameTextField.text!,
                      "primaryPhoneNo" : self.primaryPhoneTextField.text!,
                      "secondaryPhoneNo":"",
                      "primaryEmail" : self.primaryEmailTextField.text!,
                      "secondaryEmail" : "",
                      "securityQuestion1Id":securityQuestion1Id,
                      "securityAnswer1" : self.securityAnswer1TextField.text!,
                      "securityQuestion2Id" : securityQuestion2Id,
                      "securityAnswer2":self.securityAnswer2TextField.text!,
                      "profiles": [["productsBought": self.productsTextField.text!,
                                    "functionTypeId": functionTypeID,
                                    "distributorName": self.distributorTextField.text!,
                                    "utilityCompany":companyString]]] as [String : Any]
        }
        
        
        
       
        print(params)
       
        
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions())
            let task = session.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) in
                if let response = response {
                    let nsHTTPResponse = response as! HTTPURLResponse
                    let statusCode = nsHTTPResponse.statusCode
                    print ("status code = \(statusCode)")
                }
                
                
                
                
                
                hideActivityIndicator()
                
                
                if let error = error {
                    print ("\(error)")
                    showAlert(kEmptyString, message: NSLocalizedString("Please check your network availability", comment: "Please check your network availability"))
                    hideActivityIndicator()
                }
                
                
                
                
                
                if let data = data {
                    do{
                        
                        let jsonData = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions())
                        
                        
                        
                        let status: String = (jsonData as AnyObject).value(forKey: "status") as! String
                        
                        print(jsonData)
                        print(status)


                        
                        DispatchQueue.main.async {
                            
                            if(status == "InValid"){
                            let data: String = (jsonData as AnyObject).value(forKey: "data") as! String
                            showAlert(kEmptyString, message:data)
                            }
                            else
                            {
                                
                                let alert = UIAlertController(title: "", message: NSLocalizedString("User data registered successfully", comment: "User data registered successfully"), preferredStyle: UIAlertControllerStyle.alert)
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

    
    func getAllSecurityQuestionsList()
    {
        
        showActivityIndicator(false)
        
        
        let url = String(format:"%@security-questions",kUrlBase)
        
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL)

        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            
            if error != nil {
                

                print("error=\(String(describing: error))")
                showAlert(kEmptyString, message: NSLocalizedString("Please check your network availability", comment: "Please check your network availability"))
                hideActivityIndicator()
                
                return
            }
            
            
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary {
                    
                    
                    hideActivityIndicator()
                    
                    
                    let data =  jsonResult["data"] as! NSDictionary
                    
                    
                    let questionArray1 = data.value(forKey: "questionCategory1") as! NSArray
                    let questionArray2 = data.value(forKey: "questionCategory2") as! NSArray
                    
                    
                    self.securityQuestionsArray1 = NSMutableArray()
                    self.securityQuestionsArray2 = NSMutableArray()
                    self.securityQuestionIdArray1 = NSMutableArray()
                    self.securityQuestionIdArray2 = NSMutableArray()

                    
                    
                    for i in 0 ..< questionArray1.count {
                        
                        
                        let question = (questionArray1.value(forKey: "question") as AnyObject) .object(at: i)
                        let securityQuestionId = (questionArray1.value(forKey: "securityQuestionId") as AnyObject) .object(at: i)
                        
                        
                        self.securityQuestionsArray1.add(question)
                        self.securityQuestionIdArray1.add(securityQuestionId)
                        
                    }
                    
                    
                    for i in 0 ..< questionArray2.count {
                        
                        let question = (questionArray2.value(forKey: "question") as AnyObject) .object(at: i)
                        let securityQuestionId = (questionArray2.value(forKey: "securityQuestionId") as AnyObject) .object(at: i)
                        
                        self.securityQuestionsArray2.add(question)
                        self.securityQuestionIdArray2.add(securityQuestionId)
                        
                    }
                    
                    
                    
                        DispatchQueue.main.async {
                        self.securityQuestion1Label.text = self.securityQuestionsArray1[0] as? String
                        self.securityQuestion2Label.text = self.securityQuestionsArray2[0] as? String
                            
                            self.securityQuestion1Id = self.securityQuestionIdArray1.object(at: 0) as! Int
                            self.securityQuestion2Id = self.securityQuestionIdArray2.object(at: 0) as! Int

                            
                        self.view3.isHidden = true
                            
                        }

                    
                    
                    
                }
            }
            catch {
                print(error)
            }
            
        }
        
        task.resume()
        
    }
    
    
    
    @IBAction func passwordBtnAction(sender: UIButton) {
    
        if(sender.tag == 0) {
            passwordTextField.isSecureTextEntry = false
            sender.tag = 1
            sender.setTitle(NSLocalizedString("HIDE", comment: "HIDE"),for: .normal)

        } else {
            passwordTextField.isSecureTextEntry = true
            sender.tag = 0
            sender.setTitle(NSLocalizedString("SHOW", comment: "SHOW"),for: .normal)
        }
    }
    
    @IBAction func confirmPswrdBtnAction(sender: UIButton) {
        
        if(sender.tag == 0) {
            confirmPasswordTextField.isSecureTextEntry = false
            sender.tag = 1
            sender.setTitle(NSLocalizedString("HIDE", comment: "HIDE"),for: .normal)
        } else {
            confirmPasswordTextField.isSecureTextEntry = true
            sender.tag = 0
            sender.setTitle(NSLocalizedString("SHOW", comment: "SHOW"),for: .normal)
        }
    }
    
    
    
    
    
    func securityQuestion1Clicked(sender:UITapGestureRecognizer) {
        
        currentTextField .resignFirstResponder()
        
        
        if (securityQuestionsArray1.count == 0) {
            showAlert(kEmptyString, message: NSLocalizedString("No values in dropdown", comment: "No values in dropdown"))
            

        }
        else
        {
        actionSheet()

        picker = UIPickerView(frame: CGRect(x: 0, y: 44, width: self.view.frame.size.width, height: 216))
        picker.showsSelectionIndicator = true
        picker.delegate = self
        picker.tag = 101
        picker.reloadAllComponents()
            
        
        
        let isTheObjectThere: Bool = self.securityQuestionsArray1.contains(self.securityQuestion1Label.text!)
        if isTheObjectThere == true {
            let indexValue: Int = self.securityQuestionsArray1.index(of: self.securityQuestion1Label.text!)
            picker.selectRow(indexValue, inComponent: 0, animated: true)
            selectedRow = indexValue
        }
        else {
            picker.selectRow(0, inComponent: 0, animated: true)
            self.securityQuestion1Label.text = self.securityQuestionsArray1[0] as? String
            selectedRow = 0
        }
        self.actionView.addSubview(picker)
    }
}
    
    
    func securityQuestion2Clicked(sender:UITapGestureRecognizer) {
        
        currentTextField .resignFirstResponder()

        if (securityQuestionsArray2.count == 0) {
            showAlert(kEmptyString, message: NSLocalizedString("No values in dropdown", comment: "No values in dropdown"))
        }
        else
        {
        actionSheet()
        
        picker = UIPickerView(frame: CGRect(x: 0, y: 44, width: self.view.frame.size.width, height: 216))
        picker.showsSelectionIndicator = true
        picker.delegate = self
        picker.reloadAllComponents()
        
        picker.tag = 102


        
        let isTheObjectThere: Bool = self.securityQuestionsArray2.contains(self.securityQuestion2Label.text!)
        if isTheObjectThere == true {
            let indexValue: Int = self.securityQuestionsArray2.index(of: self.securityQuestion2Label.text!)
            picker.selectRow(indexValue, inComponent: 0, animated: true)
            selectedRow = indexValue

        }
        else {
            picker.selectRow(0, inComponent: 0, animated: true)
            self.securityQuestion2Label.text = self.securityQuestionsArray2[0] as? String
            selectedRow = 0

        }
        self.actionView.addSubview(picker)
    }
}
    
  
   
    
    func companyClicked(sender:UITapGestureRecognizer) {
        
        currentTextField .resignFirstResponder()
        
        let viewController = UIStoryboard(name: "Custom", bundle: nil).instantiateViewController(withIdentifier: "SearchBarViewController") as! SearchBarViewController
        
        
        let companyNameArray = NSMutableArray()
        let utilityCompanyIdArray = NSMutableArray()
         self.title = ""
        
        
        
        
        for i in 0 ..< companyArray.count {
           companyNameArray.add((companyArray.value(forKey: "utilityCompanyName") as AnyObject) .object(at: i) as! String)
            utilityCompanyIdArray.add(String(describing: (companyArray.value(forKey: "utilityCompanyId") as AnyObject) .object(at: i) as! NSNumber))
        }
        
        viewController.delegate = self
        viewController.companyArray = companyNameArray
        viewController.utilityCompanyIdArray = utilityCompanyIdArray
        viewController.titleString = NSLocalizedString("Select Company", comment: "Select Company")
        viewController.needAddButton = true

        self.navigationController!.pushViewController(viewController, animated: true)
        
        
        
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
        
        print(selectedRow)
        
        
        if (picker.tag == 101 && securityQuestionsArray1.count != 0){
            securityQuestion1Label.text = securityQuestionsArray1.object(at: selectedRow) as? String
            securityQuestion1Id = securityQuestionIdArray1.object(at: selectedRow) as! Int
        }
        else if (picker.tag == 102  && securityQuestionsArray2.count != 0){
            securityQuestion2Label.text = securityQuestionsArray2.object(at: selectedRow) as? String
            securityQuestion2Id = securityQuestionIdArray2.object(at: selectedRow) as! Int
        }
        else if (picker.tag == 103  && utilityCompanyTypeArray.count != 0){
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
            alertMessage.append(NSLocalizedString("Please enter a valid primary email address", comment: "Please enter a valid primary email address"))
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
    if(validateDataAddCompany()){
        
        companyView.isHidden = true
         companyLabel.text = addCompanyTextField.text
         utilityCompanyIDString = ""
        }
    }
    
    @IBAction func installerCompanyAddBtnClicked() {
        if(validateDataAddInstallerCompany()){
            installerCompanyView.isHidden = true
            installerCompanyLabel.text = addInstallerCompanyTextField.text
            installerCompanyIDString = ""
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
            alertMessage.append(NSLocalizedString("Please enter a valid primary email address", comment: "Please enter a valid primary email address"))
        }
      
        
      
        
        if alertMessage.isEmpty {
            return true
        }
        
        showAlert(kEmptyString, message: alertMessage)
        return false
        
    }
    
    
    
    
    
    @IBAction func companyCancelBtnClicked() {
        
        currentTextField.resignFirstResponder()
        companyView.isHidden = true
        installerCompanyView.isHidden = true
    }

    
   
    
    
    
    func selectedValue(company: String,utilityCompanyId: String,titleString: String){
    
        
        if(titleString == NSLocalizedString("Select Company", comment: "Select Company")){
            utilityCompanyIDString = utilityCompanyId
            if company != "" {
                companyLabel.text = company
                installerCompanyLabel.text = ""
                installerCompanyIDString = ""
            }
            else
            {
                companyView.isHidden = false
            }
        }
        else
        {
        

            installerCompanyIDString = utilityCompanyId
            if company != "" {
                installerCompanyLabel.text = company
            }
            else
            {
                installerCompanyView.isHidden = false
            }

        }
    
    }


    
    func installerCompanyClicked(sender:UITapGestureRecognizer) {
        
        currentTextField .resignFirstResponder()
        
        if (companyLabel.text? .isEmpty)! {
            showAlert(kEmptyString, message:NSLocalizedString("Please select a utility company", comment: "Please select a utility company") )

        }
        else
        {
            self .getInstallerCompanies()
        }
        
        
        

        
    }

    
    
    
    
    
    func getInstallerCompanies()
    
    {
   
        
        showActivityIndicator(false)
        
        
        
        let session = URLSession.shared
        
        
        
        
        let url = String(format:"%@installer-companies",kUrlBase)

        
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        
        request.httpMethod = "POST"
        
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        
        print(utilityCompanyIDString)
        
        var params = [String:Any]()
    
        if(utilityCompanyIDString==""){
            params = ["utilityCompanyId":NSNull()]
        }
        else
        {
             params = ["utilityCompanyId":Int(utilityCompanyIDString)!]

        }
        
        
        
        do{
            
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions())
            
            let task = session.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) in
                
                if let response = response {
                    
                    let nsHTTPResponse = response as! HTTPURLResponse
                    
                    let statusCode = nsHTTPResponse.statusCode
                    
                    print ("status code = \(statusCode)")
                    
                }
                
                hideActivityIndicator()
                
                
                
                
                
                if let error = error {
                    
                    print ("\(error)")
                    
                    showAlert(kEmptyString, message: "\(error)")
                    
                    hideActivityIndicator()
                    
                }
                
                if let data = data {
                    
                    do{
                        
                        
                        
                        
                        let jsonData =  try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary
                        
                        
                        
                        
                        
                        

                        
                        
                        DispatchQueue.main.async {
                            hideActivityIndicator()
                            
                            
                            
                            self.insatallerCompanyArray =  jsonData?["data"] as! NSArray

                            
                            
                            print(self.insatallerCompanyArray)
                            
                            
                                    let viewController = UIStoryboard(name: "Custom", bundle: nil).instantiateViewController(withIdentifier: "SearchBarViewController") as! SearchBarViewController
                            
                            
                                    let installerCompanyNameArray = NSMutableArray()
                                    let installerCompanyIdArray = NSMutableArray()
                                    self.title = ""
                            
                            
                            
                            
                                    for i in 0 ..< self.insatallerCompanyArray.count {
                                        
                                        
                    
                                            installerCompanyNameArray.add((self.insatallerCompanyArray.value(forKey: "installerCompanyName") as AnyObject) .object(at: i) as! String)
                                            installerCompanyIdArray.add(String(describing: (self.insatallerCompanyArray.value(forKey: "installerCompanyId") as AnyObject) .object(at: i) as! NSNumber))
                                            
                                            
                                        
                                        
                                    }
                                    
                                    viewController.delegate = self
                                    viewController.companyArray = installerCompanyNameArray
                                    viewController.utilityCompanyIdArray = installerCompanyIdArray
                                    viewController.titleString = NSLocalizedString("Select Installer Company", comment: "Select Installer Company")
                                     viewController.needAddButton = true

                                    self.navigationController!.pushViewController(viewController, animated: true)
                                    
                            
                            
                            
                            
                            
                            
                            
                        }
                        
                        print(data)
                        
                        
                        
                        
                    }catch _ {
                        
                    }
                    
                }
                
            })
            
            task.resume()
            
        }catch _ {
            
            print ("Oops something went wrong")
            
        }
        
        
        
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
                    
                    self.currentTextField .resignFirstResponder()
                    
                    
                    if (self.utilityCompanyTypeArray.count == 0) {
                        showAlert(kEmptyString, message: NSLocalizedString("No values in dropdown", comment: "No values in dropdown"))
                        
                        
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
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
