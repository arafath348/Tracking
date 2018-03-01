//
//  ChangePasswordViewController.swift
//  3M L&M
//
//  Created by dcwaters on 11/07/17.
//  Copyright © 2017 3M L&M. All rights reserved.
//

import UIKit

class ChangePasswordViewController: UIViewController {
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var showBtn2: UIButton!
    @IBOutlet weak var showBtn1: UIButton!
    @IBOutlet weak var showBtn3: UIButton!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var confirmPaswordLbl: UILabel!
    @IBOutlet weak var newPaswordLbl: UILabel!
    @IBOutlet weak var oldPaswordLbl: UILabel!
    @IBOutlet weak var changePasswordUserTextField: UITextField!
    @IBOutlet weak var changePasswordOldPasswordTextField: UITextField!
    @IBOutlet weak var changePasswordNewPasswordUserTextField: UITextField!
    @IBOutlet weak var changePasswordConfirmPasswordUserTextField: UITextField!
    var navBarHeight: CGFloat = 0
    
    override func viewDidAppear(_ animated: Bool) {
        //TealiumHelper.trackView(NSStringFromClass(self.classForCoder), dataSources: [:])
        
    }
    override func viewDidLoad() {

        let userName:String = UserDefaults.standard.value(forKey: "userName") as! String
        changePasswordUserTextField.text = userName
        self.changeLanguage()


        navBarHeight = UIApplication.shared.statusBarFrame.height + self.navigationController!.navigationBar.frame.height

    }
    
    override func viewWillAppear(_ animated: Bool) {
       // self.changeLanguage()
    }
    func changeLanguage(){
        
        
        
        DispatchQueue.main.async {
            
        
        let myString = NSLocalizedString("Username", comment: "Username")
//        let myAttribute = [ NSForegroundColorAttributeName: UIColor.blue ]
//        let myAttrString = NSAttributedString(string: myString, attributes: myAttribute)
//        self.usernameLbl.attributedText = myAttrString
         self.usernameLbl.text = myString
            self.confirmPaswordLbl.text = NSLocalizedString("Confirm Password", comment: "Confirm Password")
            self.newPaswordLbl.text = NSLocalizedString("New Password", comment: "New Password")
            self.oldPaswordLbl.text = NSLocalizedString("Old Password", comment: "Old Password")
        }
        self.title = NSLocalizedString("Change Password", comment: "Change Password")
        saveBtn.setAttributedTitle(nil, for:  UIControlState.normal)
       
        saveBtn.setTitle(NSLocalizedString("SAVE", comment: "SAVE"), for: UIControlState.normal)
        showBtn1.setTitle(NSLocalizedString("SHOW", comment: "Save"), for: UIControlState.normal)
        showBtn2.setTitle(NSLocalizedString("SHOW", comment: "Save"), for: UIControlState.normal)
        showBtn3.setTitle(NSLocalizedString("SHOW", comment: "Save"), for: UIControlState.normal)

        
       
            
       // }
    }
    func validateData() -> Bool {
        
        let userName = changePasswordUserTextField.text!.trimmingCharacters(in: NSCharacterSet.whitespaces)
        let oldPassword = changePasswordOldPasswordTextField.text!.trimmingCharacters(in: NSCharacterSet.whitespaces)
        let newPassword = changePasswordNewPasswordUserTextField.text!.trimmingCharacters(in: NSCharacterSet.whitespaces)
        let confirmPassword = changePasswordConfirmPasswordUserTextField.text!.trimmingCharacters(in: NSCharacterSet.whitespaces)
        
        
        var alertMessage = kEmptyString
        if userName .isEmpty {
            alertMessage.append(NSLocalizedString("Please enter username", comment: "Please enter username"))
        }
            
        else if oldPassword.isEmpty {
            alertMessage.append(NSLocalizedString("Please enter old password", comment: "Please enter old password"))
        }
        else if newPassword.isEmpty {
            alertMessage.append(NSLocalizedString("Please enter new password", comment: "Please enter new password"))
        }
        else if !(changePasswordNewPasswordUserTextField.text!.characters.count >= 8 && changePasswordNewPasswordUserTextField.text!.characters.count <= 15)
        {
            alertMessage.append(NSLocalizedString("Please enter a valid new password. Your new password length should be 8 to 15 characters", comment: "Please enter a valid new password. Your new password length should be 8 to 15 characters"))
        }
        else if !isPasswordValid(changePasswordNewPasswordUserTextField.text!)
        {
            alertMessage.append(NSLocalizedString("Please enter a valid new password. Your new password should contain atleast 1 uppercase and a numeric", comment: "Please enter a valid new password. Your new password should contain atleast 1 uppercase and a numeric"))
        }
        else if confirmPassword.isEmpty {
            alertMessage.append(NSLocalizedString("Please enter confirm password", comment: "Please enter confirm password"))
        }
        else if changePasswordNewPasswordUserTextField.text != changePasswordConfirmPasswordUserTextField.text {
            alertMessage.append(NSLocalizedString("New password and confirm password doesn't match", comment: "New password and confirm password doesn't match"))
        }
        
        else if changePasswordNewPasswordUserTextField.text == changePasswordOldPasswordTextField.text {
            alertMessage.append(NSLocalizedString("Old and new passwords are same. Please enter different new password ", comment: "Old and new passwords are same. Please enter different new password "))
        }
        
        
        
        if alertMessage.isEmpty {
            return true
        }
        
        showAlert(kEmptyString, message: alertMessage)
        
        
        return false
    }
    
    
    @IBAction func saveButtonClicked() {
        if validateData() {
            self .performChangePassword()
        }
    }
    
    
    
    
    
    
    
    
    func performChangePassword() {
        
        
        showActivityIndicator(false)
        let session = URLSession.shared
        let url = String(format:"%@user/reset-password",kUrlBase)
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        request.httpMethod = "PUT"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        let params:[String: String] = ["userName" : changePasswordUserTextField.text!,"password" : changePasswordOldPasswordTextField.text!,"newPassword":changePasswordNewPasswordUserTextField.text!]
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
                        
                
                        
                        let status =  jsonData?["status"] as! String
                        
                        DispatchQueue.main.async {
                            hideActivityIndicator()
                            
                            if(status == "InValid"){
                                let data: String = (jsonData as AnyObject).value(forKey: "data") as! String
                                showAlert(kEmptyString, message:data)
                            }
                            else
                            {
                                showAlert(kEmptyString, message:NSLocalizedString("Password Changed Successfully", comment: "Password Changed Successfully") )
                                self.navigationController?.popViewController(animated: true)
                            }
                        }
                        
                        
                        
                        
                        
                    }catch _ {
                    }
                }
            })
            task.resume()
        }catch _ {
            print ("Oops something happened buddy")
        }
   
    }
    

    //pragma mark - textField Delegate row lifecycle
    
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
        
        
        if textField == self.changePasswordUserTextField {
            self.changePasswordOldPasswordTextField.becomeFirstResponder()
        }
        else if textField == self.changePasswordOldPasswordTextField {
            self.changePasswordNewPasswordUserTextField.becomeFirstResponder()
        }
        else if textField == self.changePasswordNewPasswordUserTextField {
            self.changePasswordConfirmPasswordUserTextField.becomeFirstResponder()
        }
        else
        {
            textField .resignFirstResponder()
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        
        return true
    }
    
    
    
    
    
    @IBAction func oldPasswordBtnAction(sender: UIButton) {
        
        if(sender.tag == 0) {
            changePasswordOldPasswordTextField.isSecureTextEntry = false
            sender.tag = 1
            sender.setTitle(NSLocalizedString("HIDE", comment: "HIDE"),for: .normal)
            
        } else {
            changePasswordOldPasswordTextField.isSecureTextEntry = true
            sender.tag = 0
            sender.setTitle(NSLocalizedString("SHOW", comment: "SHOW"),for: .normal)
        }
    }
    
    @IBAction func newPasswordBtnAction(sender: UIButton) {
        
        if(sender.tag == 0) {
            changePasswordNewPasswordUserTextField.isSecureTextEntry = false
            sender.tag = 1
            sender.setTitle(NSLocalizedString("HIDE", comment: "HIDE"),for: .normal)

        } else {
            changePasswordNewPasswordUserTextField.isSecureTextEntry = true
            sender.tag = 0
            sender.setTitle(NSLocalizedString("SHOW", comment: "SHOW"),for: .normal)
        }
    }
    
    @IBAction func confirmPswrdBtnAction(sender: UIButton) {
        
        if(sender.tag == 0) {
            changePasswordConfirmPasswordUserTextField.isSecureTextEntry = false
            sender.tag = 1
            sender.setTitle(NSLocalizedString("HIDE", comment: "HIDE"),for: .normal)
        } else {
            changePasswordConfirmPasswordUserTextField.isSecureTextEntry = true
            sender.tag = 0
            sender.setTitle(NSLocalizedString("SHOW", comment: "SHOW"),for: .normal)
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
