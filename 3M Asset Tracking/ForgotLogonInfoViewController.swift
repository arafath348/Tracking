//
//  ForgotLogonInfoViewController.swift
//  3M L&M
//
//  Created by dcwaters on 11/07/17.
//  Copyright © 2017 3M L&M. All rights reserved.
//

import UIKit

class ForgotLogonInfoViewController: UIViewController {
    
    var userName: NSString = ""
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var security1TextField: UITextField!
    @IBOutlet weak var security2TextField: UITextField!
    
    @IBOutlet weak var securityQuestion1Label: UILabel!
    @IBOutlet weak var securityQuestion2Label: UILabel!
    
    
    @IBOutlet weak var viewPassword1: UIView!
    @IBOutlet weak var viewPassword2: UIView!
    @IBOutlet weak var viewLogonInfo: UIView!
    @IBOutlet weak var viewUsername: UIView!
    

    
    var currentTextField: UITextField!
    
    
    var securityArray = NSArray()
    
   // @IBOutlet weak var validateBtn: UIButton!
    //FOR localition Outlets
    @IBOutlet weak var usrNameLbl: UILabel!
    
    @IBOutlet weak var secQues1: UILabel!
    
    @IBOutlet weak var secQues2: UILabel!
    @IBOutlet weak var validateBtn: UIButton!
    
    @IBOutlet weak var newPassword: UILabel!
    @IBOutlet weak var enterEmailLbl: UILabel!
    @IBOutlet weak var emailAddr: UILabel!
    @IBOutlet weak var forgotUserSubmitBtn: UIButton!
    
    @IBOutlet weak var newPasswordText: UITextField!
    @IBOutlet weak var confirmPasswordText: UITextField!
    @IBOutlet weak var newPaswrd: UILabel!
    @IBOutlet weak var confirmNewpaswordLbl: UILabel!
    @IBOutlet weak var showBtn: UIButton!
    @IBOutlet weak var showBtn2: UIButton!
    
    @IBOutlet weak var sumbitPasswordBtn: UIButton!
    //_____________
    class InsetButtonsNavigationBar: UINavigationBar {
        
        override func layoutSubviews() {
            super.layoutSubviews()
            
            for view in subviews {
                // Setting the layout margins to 0 lines the bar buttons items up at
                // the edges of the screen. You can set this to any number to change
                // the spacing.
                view.layoutMargins = .zero
            }
        }
        
    }
    
    func changeLanguage(){
        
     self.title = NSLocalizedString("Forgot Username / Password", comment: "Forgot Username / Password")
        segmentedControl.setTitle(NSLocalizedString("Password", comment: "Password"), forSegmentAt: 0)
        segmentedControl.setTitle(NSLocalizedString("Username", comment: "Username"), forSegmentAt: 1)
        DispatchQueue.main.async {

        

       self.usrNameLbl.text = NSLocalizedString("Username", comment: "")
         self.secQues1.text = NSLocalizedString("Security Question 1", comment: "")
          self.secQues2.text = NSLocalizedString("Security Question 2", comment: "")
          self.validateBtn.setTitle(NSLocalizedString("VALIDATE", comment: "validate"), for: UIControlState.normal)
          self.newPaswrd.text =  NSLocalizedString("New Password", comment: "pasword")
          self.enterEmailLbl.text =  NSLocalizedString("Enter the email address you registered with to receive your username.", comment: "email")
          self.emailAddr.text = NSLocalizedString("E-mail address", comment: "E-mail address")
          self.confirmNewpaswordLbl.text = NSLocalizedString("Confirm new Password", comment: "Confirm new Password")
          self.forgotUserSubmitBtn.setTitle(NSLocalizedString("SUBMIT", comment: "validate"), for: UIControlState.normal)
          self.sumbitPasswordBtn.setTitle(NSLocalizedString("SUBMIT", comment: "validate"), for: UIControlState.normal)
        }

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.viewLogonInfo.isHidden = false
        self.viewPassword1.isHidden = false
        self.viewPassword2.isHidden = true
        self.viewUsername.isHidden = true
        self.changeLanguage()
    }
    
   
    override func viewDidAppear(_ animated: Bool) {
        self.navigationItem.setHidesBackButton(true, animated:false)
    //TealiumHelper.trackView(NSStringFromClass(self.classForCoder), dataSources: [:])

    }
   
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationItem.setHidesBackButton(false, animated:false)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.changeLanguage()
        currentTextField = userNameTextField
        // Do any additional setup after loading the view.
        
        
        let iconSize = CGRect(origin: CGPoint.zero, size: CGSize(width: 21, height: 44))
        let backButton = UIButton(frame: iconSize)
        backButton.setImage(UIImage(named: "customBackArrow1.png"), for: .normal)
        backButton.addTarget(self, action: #selector(self.customBackButton(sender:)), for: .touchUpInside)
        backButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)

        
        userNameTextField.font = UIFont(name: "3MCircularTT-Book", size: 14)!
        
        
        
        
    }
    
   
    
    func customBackButton(sender: UIButton){
        
        
        if self.viewLogonInfo.isHidden == true {
            self.viewLogonInfo.isHidden = false
            self.viewPassword2.isHidden = true
        }
        else
        {
            self.navigationController?.popViewController(animated: true)
        }
            
    }
    
    
    
    
    
    func validateUsernameApi()
    {
        
        let Parameter:String = String(format:"user/check-avilable-username/%@",userNameTextField.text!)
        
        RestApiManager.sharedInstance.getRandomUser(Parameter as String)
        {
            json in
            //            let status = json["status"]
            let data = json["data"]
            
            print(json)
            
            print(data)
            
            hideActivityIndicator()
            
            DispatchQueue.main.async {
                
                if ((data.object as! NSDictionary).value(forKey: "userNameAvailable") as! Bool) == true{
                    showAlert(kEmptyString, message: NSLocalizedString("Please enter a valid username", comment: "Please enter a valid username"))
                    self.securityQuestion1Label.text = ""
                    self.securityQuestion2Label.text = ""
                    self.security1TextField.text = ""
                    self.security2TextField.text = ""

                }
                else{
                    self.getSecurityQuestionList()
                }
                
            }
            
        }
        
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        currentTextField .resignFirstResponder()
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            self.changeLanguage()
            viewLogonInfo.isHidden = false
            viewPassword1.isHidden = false
            viewPassword2.isHidden = true
            viewUsername.isHidden = true
        case 1:
            self.changeLanguage()
            viewLogonInfo.isHidden = false
            viewPassword1.isHidden = true
            viewPassword2.isHidden = true
            viewUsername.isHidden = false
        default:
            break;
        }
        
    }
    
    
    
    func validateData() -> Bool {
        
        let security1 = security1TextField.text!.trimmingCharacters(in: NSCharacterSet.whitespaces)
        let security2 = security2TextField.text!.trimmingCharacters(in: NSCharacterSet.whitespaces)
        
        
        
        
        var alertMessage = kEmptyString
        if security1 .isEmpty {
            alertMessage.append(NSLocalizedString("Please answer the security question 1", comment: "Please answer the security question 1"))
        }
            
        else if security2.isEmpty {
            alertMessage.append(NSLocalizedString("Please answer the security question 2", comment: "Please answer the security question 2"))
        }
        
        
        if alertMessage.isEmpty {
            return true
        }
        
        showAlert(kEmptyString, message: alertMessage)
        return false
    }
    
    
    func validatePasswordData() -> Bool {
        
        var alertMessage = kEmptyString
        let newPassword = newPasswordText.text!.trimmingCharacters(in: NSCharacterSet.whitespaces)
        let confirmPassword = confirmPasswordText.text!.trimmingCharacters(in: NSCharacterSet.whitespaces)
        newPasswordText.font = UIFont(name: "3MCircularTT-Book", size: 14)
        confirmPasswordText.font = UIFont(name: "3MCircularTT-Book", size: 14)
        
        
        if newPassword.isEmpty {
            alertMessage.append(NSLocalizedString("Please enter new password", comment: "Please enter new password"))
        }
        else if !(newPasswordText.text!.characters.count >= 8 && newPasswordText.text!.characters.count <= 15)
        {
            alertMessage.append(NSLocalizedString("Please enter a valid new password. Your new password length should be 8 to 15 characters", comment: "Please enter a valid new password. Your new password length should be 8 to 15 characters"))
        }
        else if !isPasswordValid(newPasswordText.text!)
        {
             alertMessage.append(NSLocalizedString("Please enter a valid new password. Your new password should contain atleast 1 uppercase and a numeric", comment: "Please enter a valid new password. Your new password should contain atleast 1 uppercase and a numeric"))
        }
            
        else if confirmPassword.isEmpty {
            alertMessage.append(NSLocalizedString("Please enter confirm password", comment: "Please enter confirm password"))
        }
        else if newPasswordText.text != confirmPasswordText.text {
            alertMessage.append(NSLocalizedString("New password and confirm password doesn't match", comment: "New password and confirm password doesn't match"))
        }
        if alertMessage.isEmpty {
            return true
        }
        
        showAlert(kEmptyString, message: alertMessage)
        return false
        
        
    }
    
    @IBAction func validateButtonClicked() {
        
        if validateData() {
            self.validateSecurityAnswers()
            //to be commented
           // self.viewLogonInfo.isHidden = true
            //self.viewPassword2.isHidden = false
        }
    }
    
    
    @IBAction func submitButtonClicked() {
        if validatePasswordData(){
            self.validatePassword()
        }
        
    }
    @IBAction func usernameSubmitButtonClicked() {
        if !validateEmailWithString(emailTextField.text) {
            showAlert(kEmptyString, message: NSLocalizedString("Enter a Valid Email Address", comment: "Enter a Valid Email Address"))
        }
        else{
        self.validateEmailData()
        }
    }
    
    func validateEmailData(){
        //call post method
        
        showActivityIndicator(false)
        
        let session = URLSession.shared
        
        let url = String(format:"%@user/forgot-user-name",kUrlBase)
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        
        request.httpMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        let params:[String: String] = ["email" :emailTextField.text!]
        
        
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
                        
                        hideActivityIndicator()
                        
                        let data =  jsonData?["data"] as! NSString
                        showAlert(kEmptyString, message: data as String)
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
    
    
    
    func validatePassword() {
        
        
        
        showActivityIndicator(false)
        
        let session = URLSession.shared
        
        let url = String(format:"%@user/reset-forgot-password",kUrlBase)
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        request.httpMethod = "PUT"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        let params:[String: String] = ["userName" : self.userNameTextField.text!,"securityAnswer1" : self.security1TextField.text!,"securityAnswer2":self.security2TextField.text!,"newPassword": self.newPasswordText.text!]
        
        
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
                else
                {
                    DispatchQueue.main.async {
                        showAlert(kEmptyString, message: NSLocalizedString("Password reset Successful", comment: "Password reset Successful"))
                        self.navigationController?.popViewController(animated: true)
                    }
                    
                }
            })
            task.resume()
        }catch _ {
            print ("Oops something went wrong")
        }
        
        
    }
    
    func validateSecurityAnswers() {
        
        
        showActivityIndicator(false)
        
        let session = URLSession.shared
        
        let url = String(format:"%@user/validate-security-answers",kUrlBase)
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        
        request.httpMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        let params:[String: String] = ["userName" : self.userNameTextField.text!,"securityAnswer1" : self.security1TextField.text!,"securityAnswer2":self.security2TextField.text!]
        
        
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
                    showAlert(kEmptyString, message:NSLocalizedString("Please check your network availability", comment: "Please check your network availability") )
                    hideActivityIndicator()
                }
                if let data = data {
                    do{
                        
                        
                        let jsonData =  try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary
                        
                        hideActivityIndicator()
                        
                        let data =  jsonData?["data"] as! NSDictionary
                        
                        
                        print(data)
                        
                        
                        
                        if (data.value(forKey: "answersValid") as! Bool) == false{
                            showAlert(kEmptyString, message: NSLocalizedString("Please check your answers", comment: "Please check your answers"))
                            
                        }
                        else
                        {
                            
                            DispatchQueue.main.async {
                                self.viewLogonInfo.isHidden = true
                                
                                self.viewPassword2.isHidden = false
                                
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
    
    
    
    
    
    
    
    func getSecurityQuestionList()
    {
        
        
        showActivityIndicator(false)
  
        let Parameter:String = String(format:"user/%@/security-questions",userNameTextField.text!)
        
        RestApiManager.sharedInstance.getRandomUser(Parameter as String)
        {
            json in

            let status =  json["status"]
            print(status)
            
            print(json)
            
            
            hideActivityIndicator()
            
            if(status == "Success")
            {
                let data =  json["data"].object as! NSDictionary

                DispatchQueue.main.async {
                    self.securityQuestion1Label.text = data.value(forKey: "securityQuestion1") as? String
                    self.securityQuestion2Label.text = data.value(forKey: "securityQuestion2") as? String
                }
            }
        }
        
    }
   
    
    
    //pragma mark - textField Delegate row lifecycle
    
    func textFieldDidBeginEditing(_ textField: UITextField) { // became first responder
        
        currentTextField = textField
        
        //move textfields up
        let myScreenRect: CGRect = UIScreen.main.bounds
        let keyboardHeight : CGFloat = 305
        
        UIView.beginAnimations( "animateView", context: nil)
        let movementDuration:TimeInterval = 0.35
        var needToMove: CGFloat = -64
        
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
       
        if(currentTextField == userNameTextField)
        {
            if (userNameTextField.text == ""){
                showAlert(kEmptyString, message:NSLocalizedString("Please enter a valid username. Username cannot be blank", comment: "Please enter a valid username. Username cannot be blank") )
                self.securityQuestion1Label.text = ""
                self.securityQuestion2Label.text = ""
                self.security1TextField.text = ""
                self.security2TextField.text = ""
            }
            else
            {
            self.validateUsernameApi()
            }
        }
        
        UIView.beginAnimations( "animateView", context: nil)
        let movementDuration:TimeInterval = 0.35
        
        var frame : CGRect = self.view.frame
        frame.origin.y = 64
        self.view.frame = frame
        UIView.setAnimationDuration(movementDuration)
        UIView.commitAnimations()
        
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        
        return true
    }
    
    
    
    
    @IBAction func newPasswordBtnAction(sender: UIButton) {
        
        if(sender.tag == 0) {
            newPasswordText.isSecureTextEntry = false
            sender.tag = 1
            sender.setTitle(NSLocalizedString("HIDE", comment: "HIDE"),for: .normal)

        } else {
            newPasswordText.isSecureTextEntry = true
            sender.tag = 0
            sender.setTitle(NSLocalizedString("SHOW", comment: "SHOW"),for: .normal)
        }
    }
    
    @IBAction func confirmPswrdBtnAction(sender: UIButton) {
        
        if(sender.tag == 0) {
            confirmPasswordText.isSecureTextEntry = false
            sender.tag = 1
            sender.setTitle(NSLocalizedString("HIDE", comment: "HIDE"),for: .normal)
        } else {
            confirmPasswordText.isSecureTextEntry = true
            sender.tag = 0
            sender.setTitle(NSLocalizedString("SHOW", comment: "SHOW"),for: .normal)
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
