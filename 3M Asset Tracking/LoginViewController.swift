//
//  LoginViewController.swift
//  3M L&M

//  Created by dcwaters on 03/07/17.
//  Copyright © 2017 3M L&M. All rights reserved.
//

import UIKit
import AppCenterCrashes

class LoginViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource, UIImagePickerControllerDelegate,UINavigationControllerDelegate,UISearchBarDelegate {
    
    let device = UIDevice.current

    @IBOutlet weak var userGuideBtn: UIButton!
 
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var pswdTextField: UITextField!
    @IBOutlet weak var companyTextField: UITextField!
    @IBOutlet var signUpButton: UIButton!
    @IBOutlet var companyListLabel: UILabel!
    @IBOutlet weak var loginView: UIView?
    @IBOutlet weak var companyView: UIView?
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var termsView:UIView!

    //FOR Localization adding outlets here
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var alreadyReg: UILabel!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var forgotUsrpwrd: UIButton!
    @IBOutlet weak var agreeBtn: UIButton!
    @IBOutlet weak var versionLbl: UILabel!
    @IBOutlet weak var termsBtn: UIButton!
    @IBOutlet weak var continueBtn: UIButton!
    
    
    //---------------
    var companyArray = NSArray()
    var profilesArray = NSArray()
    
    var utilityCompanyNameArray:NSMutableArray = []
    var utilityCompanyIdArray:NSMutableArray = []
    
    var transView:UIView!
    var actionView:UIView!
    var selectedRow = 0;
    var picker = UIPickerView()
    
    var deviceInformation:NSString = ""
 
    @IBAction func userGuideBtnClicked(_ sender: Any) {
       
        let viewController = UIStoryboard(name: "Custom", bundle: nil).instantiateViewController(withIdentifier: "WebViewViewController") as! WebViewViewController
        viewController.urlString = "https://multimedia.3m.com/mws/media/1466836O/instructions-for-3m-asset-tracking-app.pdf"
        self.navigationController!.pushViewController(viewController, animated: true)
    }
    @IBAction func termsBtnClicked(_ sender: Any) {
       
        let viewController = UIStoryboard(name: "Custom", bundle: nil).instantiateViewController(withIdentifier: "WebViewViewController") as! WebViewViewController
        viewController.urlString = "https://multimedia.3m.com/mws/media/1461224O/terms-of-service-and-license-for-3m-asset-management-system.pdf"
        self.navigationController!.pushViewController(viewController, animated: true)
    }
    func changeLanguage(){
        //TODO: while releasing need to change number in all .strings file
        termsBtn.setAttributedTitle(nil, for: UIControlState.normal)
        userGuideBtn.setAttributedTitle(nil, for: UIControlState.normal)
        userGuideBtn.setTitle(NSLocalizedString("3M Asset Tracking User Guide", comment: "3M Asset Tracking User Guide"), for: UIControlState.normal)
        termsBtn.setTitle(NSLocalizedString("Terms and Conditions", comment: "terms"), for: UIControlState.normal)
        let version:String = NSLocalizedString("Version:", comment: "")
        versionLbl.text = String(format:"%@ 1.0.4",version)
        
        
        nameLbl.text = NSLocalizedString("3M Asset Tracking", comment: "3M Asset Tracking")
       
        
        alreadyReg.text = NSLocalizedString("Already Registered? Log in below", comment: "Already Registered? Log in below")
        loginBtn.setTitle(NSLocalizedString("Login", comment: "Login"), for: UIControlState.normal)
        forgotUsrpwrd.setTitle(NSLocalizedString("Forgot Username / Password", comment: "forgot"), for: UIControlState.normal)
  agreeBtn.setTitle(NSLocalizedString("I Agree", comment: "agree"), for: UIControlState.normal)
         continueBtn.setTitle(NSLocalizedString("Continue", comment: "continue"), for: UIControlState.normal)
        signUpButton.setTitle(NSLocalizedString("Logging in for the first time? Register here", comment: "Logging in for the first time? Register here"), for: UIControlState.normal)

    }
    

 
    func webViewDidFinishLoad(_ webView: UIWebView)
    {
        hideActivityIndicator()
        agreeBtn.isHidden = false
    }
    
    @IBAction func agreeButtonClicked(){
        termsView.isHidden = true
        UserDefaults.standard.set(true, forKey: "TermsAccepted")
        UserDefaults.standard.synchronize()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.changeLanguage()

        // Do any additional setup after loading the view.
        

        
        let isFirstLaunch = !UserDefaults.standard.bool(forKey: "TermsAccepted")
        if (isFirstLaunch) {
            if isConnectedToNetwork() {
                if let url = URL(string: "https://multimedia.3m.com/mws/media/1461224O/terms-of-service-and-license-for-3m-asset-management-system.pdf") {
                    let request = URLRequest(url: url)
                    webView.loadRequest(request)
                    showActivityIndicator(false)
                }
            } else{
                showNoNetworkAlert()
            }
            
            termsView.isHidden = false
            agreeBtn.isHidden = true
           
        }
        
        
       // let signupText = NSMutableAttributedString.init(string: NSLocalizedString("Logging in for the first time? Register here", comment: "Logging in for the first time? Register here"))
        
        //Hiding this font attribute since it is not working fine for multiple languages
      /*  signupText.setAttributes([NSFontAttributeName: UIFont(name: "3MCircularTT-Book", size: 14)!,
                                  NSForegroundColorAttributeName: UIColor(red: 115/255, green: 115/255, blue: 115/255, alpha: 1.0)],
                                 range: NSMakeRange(0, 30))
        
        
        signupText.setAttributes([NSFontAttributeName:  UIFont(name: "3MCircularTT-Bold", size: 14)!,
                                  NSForegroundColorAttributeName: UIColor.black],
                                 range: NSMakeRange(31, 13))*/
        signUpButton.setTitle(NSLocalizedString("Logging in for the first time? Register here", comment: "Logging in for the first time? Register here"), for: UIControlState.normal)
  
       // signUpButton?.setAttributedTitle(signupText, for: .normal)
        // Hide the navigation bar on the this view controller
        
       self.navigationController?.setNavigationBarHidden(true, animated: animated)
        self.loginView?.isHidden = false
        self.companyView?.isHidden = true
        
        userTextField.text = ""
        pswdTextField.text = ""
        
       
//        userTextField.text = "September23"
//        pswdTextField.text = "Test@1234"

//        userTextField.text = "ramaraju"
//        pswdTextField.text = "Password9"
        
    }
    
    
    
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
  override func viewDidAppear(_ animated: Bool) {
   //TealiumHelper.trackView(NSStringFromClass(self.classForCoder), dataSources: [:])

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.changeLanguage()

        let modelName = device.modelName
        let systemVersion = device.systemVersion
        deviceInformation = String(format:"Device Model:%@, iOS Version:%@",modelName,systemVersion) as NSString
    }
    
    
    
    
    
    //pragma mark - textField Delegate row lifecycle
    
    func textFieldDidBeginEditing(_ textField: UITextField) { // became first responder
        
        //move textfields up
        let myScreenRect: CGRect = UIScreen.main.bounds
        let keyboardHeight : CGFloat = 250
        
        UIView.beginAnimations( "animateView", context: nil)
        let movementDuration:TimeInterval = 0.35
        var needToMove: CGFloat = 0
        
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
        frame.origin.y = 0
        self.view.frame = frame
        UIView.setAnimationDuration(movementDuration)
        UIView.commitAnimations()
        
        
        
        if textField == self.userTextField {
            self.pswdTextField.becomeFirstResponder()
        }
        
        
        
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        
        return true
    }
    
    
    
    
    func validateData() -> Bool {
        
        let userString: String = userTextField.text!.trimmingCharacters(in: NSCharacterSet.whitespaces)
        let pswdString = pswdTextField.text!.trimmingCharacters(in: NSCharacterSet.whitespaces)
        
        
        
        
        var alertMessage = kEmptyString
        if userString .isEmpty {
            alertMessage.append(NSLocalizedString("Please enter username", comment: "Please enter username"))
        }
        else if pswdString.isEmpty {
            alertMessage.append(NSLocalizedString("Please enter password", comment: "Please enter password"))
        }
        
        if alertMessage.isEmpty {
            return true
        }
        
        showAlert(kEmptyString, message: alertMessage)
        return false
    }
    
    
    @IBAction func loginButtonClicked()
    {
        


        userTextField.resignFirstResponder()
        pswdTextField.resignFirstResponder()
        
        if isNetworkAvailable() {
            if validateData() {
                self.performSignIn()
                
            }
        }
        
        
        
    }
    
    
    
    
    
    
    func performSignIn()
    {
        
        
        showActivityIndicator(false)
        
        let parameter = String(format:"username=%@&password=%@",userTextField.text!,pswdTextField.text!)
    
        let loginURL = String(format:"%@user/login",kUrlBase)
        let url = NSURL(string: loginURL)
        
        
        
        let request = NSMutableURLRequest(url: url! as URL)
        
        // Set the method to POST
        request.httpMethod = "POST"
        
        
        // Set the POST body for the request
        request.httpBody = parameter.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue));
        request.addValue(NSString(format:"%@",deviceInformation) as String, forHTTPHeaderField:"device-os")
       // [request addValue:[NSString stringWithFormat:@"%@",deviceInformation] forHTTPHeaderField:@"device-os"];

        //request.allHTTPHeaderFields = headers
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            
            if error != nil {
                print("error=\(String(describing: error))")
                showAlert(kEmptyString, message: NSLocalizedString("Please check your network availability", comment: "Please check your network availability"))
                hideActivityIndicator()
                return
            }
            
            // You can print out response object
            print("******* response = \(String(describing: response))")
            
            
            hideActivityIndicator()
            
            let httpResponse = response as? HTTPURLResponse
            print("statusCode: \(String(describing: httpResponse?.statusCode))")
            
            
            
            
            
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("****** response data = \(responseString!)")
            
            
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary {
                    
                    
                    
                    
                    self.utilityCompanyNameArray = NSMutableArray()
                    self.utilityCompanyIdArray = NSMutableArray()
                    
                    
                    
                    let status: String = jsonResult.value(forKey: "status") as! String
                    
                    if(status == "Success")
                    {
                        let dic1:NSDictionary = jsonResult.value(forKey: "data") as! NSDictionary
                        self.profilesArray = dic1.value(forKey: "profiles") as! NSArray
                        self.companyArray = self.profilesArray.value(forKey: "utilityCompany")  as! NSArray
                        
                        
                        
                        let userProfileId:Int = (self.profilesArray.value(forKey: "userProfileId") as AnyObject) .object(at: 0) as! Int
                       
                        
                        
                        
                        
                        if let oldUserProfileId:String = UserDefaults.standard.value(forKey: "userProfileId") as? String{
                            if (oldUserProfileId != String(userProfileId)) {
                                let  database = DatabaseHandler()
                                database.updateLastSyncTimeSetting(lastSyncTime: "")
                            }
                        }
                        
                        
                        
                        UserDefaults.standard.set(String(userProfileId), forKey:"userProfileId")
                        
                        let userName:String = (self.profilesArray.value(forKey: "userName") as AnyObject) .object(at: 0) as! String
                        UserDefaults.standard.set(userName, forKey:"userName")
                        
                        
                        
                        
                        
                        
                        DispatchQueue.main.async {
                            if (self.companyArray.count > 1)
                            {
                                

                                
                         
                                
                                
                                
                                for i in 0 ..< self.companyArray.count {
                                    self.utilityCompanyNameArray.add((self.companyArray.value(forKey: "utilityCompanyName") as AnyObject) .object(at: i) as! String)
                                    self.utilityCompanyIdArray.add(String(describing: (self.companyArray.value(forKey: "utilityCompanyId") as AnyObject) .object(at: i) as! NSNumber))
                                }
                                
                               let myString = NSString(format: NSLocalizedString("Hi %@, Please select a company", comment: "str") as NSString, self.userTextField.text!)
                                self.companyListLabel?.text = NSLocalizedString(myString as String, comment: myString as String)  as String
                                self.loginView?.isHidden = true
                                self.companyView?.isHidden = false
                                self.companyTextField.text = ""
                                
                                
                                
                            }
                            else
                            {
                                
                                
                                
                                
                                
                                
                                
                                
                                let utilityCompanyId:Int = (self.profilesArray.value(forKey: "utilityCompanyId") as AnyObject) .object(at: 0) as! Int
                                
                                if let oldUtilityCompanyId:String = UserDefaults.standard.value(forKey: "utilityCompanyId") as? String{
                                    if (oldUtilityCompanyId != String(utilityCompanyId)) {
                                        let  database = DatabaseHandler()
                                        database.updateLastSyncTimeSetting(lastSyncTime: "")
                                    }
                                }
                                
                                UserDefaults.standard.set(String(utilityCompanyId), forKey:"utilityCompanyId")
                                
                                
                                
                                let viewController = self.storyboard!.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
                                self.navigationController!.pushViewController(viewController, animated: true)
                            }
                        }
                        
                    }
                    else
                    {
                        
                        showAlert(kEmptyString, message: NSLocalizedString("Username or password is incorrect", comment: "Username or password is incorrect"))
                    }
                    
                    
                    
                }
            }
            catch {
                print(error)
            }
            
            
            
        }
        
        task.resume()
        
        
    }
    
    
    
    
    
    func getCompanyList()
    {
        showActivityIndicator(false)
        let Parameter:String = "utility-companies"
        
        RestApiManager.sharedInstance.getRandomUser(Parameter as String)
        {
            json in
            let status = json["status"]
            let data = json["data"]
            
            hideActivityIndicator()
            
            if(status == "Success")
            {
                self.companyArray =  data.object as! NSArray
                
                
                DispatchQueue.main.async {
                    let viewController = self.storyboard!.instantiateViewController(withIdentifier: "FirstLoginViewController") as! FirstLoginViewController
                    viewController.companyArray = self.companyArray
                    self.navigationController!.pushViewController(viewController, animated: true)
                }
                
            }
            
        }
    }
    
    
    
    
    @IBAction func firstLoginButtonClicked(){
        
        self.getCompanyList()
        
    }
    
    
    @IBAction func forgotButtonClicked(){
        
        userTextField.resignFirstResponder()
        pswdTextField.resignFirstResponder()

        let viewController = self.storyboard!.instantiateViewController(withIdentifier: "ForgotLogonInfoViewController") as! ForgotLogonInfoViewController
        self.navigationController!.pushViewController(viewController, animated: true)

        
    }
    
    
    
    
    
    
    
    @IBAction func continueButtonClicked(){
        
        let companyListString: String = companyTextField.text!.trimmingCharacters(in: NSCharacterSet.whitespaces)
        
        
        if companyListString .isEmpty {
            showAlert(kEmptyString, message: NSLocalizedString("Please select a company", comment: "Please select a company"))
        }
        else
        {
            let viewController = self.storyboard!.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
            self.navigationController!.pushViewController(viewController, animated: true)
            
        }
        
        
    }
    
    
    
    
    
    @IBAction func selectCompanyButtonClicked() {
        
        actionSheet()
        
        picker = UIPickerView(frame: CGRect(x: 0, y: 44, width: self.view.frame.size.width, height: 216))
        picker.showsSelectionIndicator = true
        picker.delegate = self
        picker.reloadAllComponents()
        
        
        
        let isTheObjectThere: Bool = self.utilityCompanyNameArray.contains(self.companyTextField.text!)
        if isTheObjectThere == true {
            let indexValue: Int = self.utilityCompanyNameArray.index(of: self.companyTextField.text!)
            picker.selectRow(indexValue, inComponent: 0, animated: true)
            selectedRow = indexValue
        }
        else {
            picker.selectRow(0, inComponent: 0, animated: true)
            self.companyTextField.text = self.utilityCompanyNameArray[0] as? String
            selectedRow = 0
        }
        self.actionView.addSubview(picker)
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
        
        
        
        self.companyTextField.text = utilityCompanyNameArray .object(at: selectedRow) as? String
        
        
        
        let utilityCompanyId:Int = (self.profilesArray.value(forKey: "utilityCompanyId") as AnyObject) .object(at: selectedRow) as! Int
        
        if let oldUtilityCompanyId:String = UserDefaults.standard.value(forKey: "utilityCompanyId") as? String{
            if (oldUtilityCompanyId != String(utilityCompanyId)) {
                let  database = DatabaseHandler()
                database.updateLastSyncTimeSetting(lastSyncTime: "")
            }
        }
        
        UserDefaults.standard.set(String(utilityCompanyId), forKey:"utilityCompanyId")
        
        
        
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
    
    
    
    
    
    
    
    
    public func numberOfComponents(in pickerView:  UIPickerView) -> Int  {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return utilityCompanyNameArray.count
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let pickerLabel = UILabel(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 30))
        pickerLabel.textAlignment = .center
        pickerLabel.backgroundColor = UIColor.clear
        pickerLabel.font = UIFont(name: "3MCircularTT-Book", size: 14)
        pickerLabel.text =  utilityCompanyNameArray.object(at: row) as? String
        
        
        return pickerLabel
        
    }
    
    
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedRow = row;
        
        companyTextField.text = utilityCompanyNameArray .object(at: row) as? String
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

//Adding the extension to get the curent connected device model name and OS version
extension UIDevice {
    
  
        var modelName: String {
            var systemInfo = utsname()
            uname(&systemInfo)
            let machineMirror = Mirror(reflecting: systemInfo.machine)
            let identifier = machineMirror.children.reduce("") { identifier, element in
                guard let value = element.value as? Int8, value != 0 else { return identifier }
                return identifier + String(UnicodeScalar(UInt8(value)))
            }

        switch identifier {
            
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
        case "iPhone8,4":                               return "iPhone SE"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad6,11", "iPad6,12":                    return "iPad 5"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,3", "iPad6,4":                      return "iPad Pro 9.7 Inch"
        case "iPad6,7", "iPad6,8":                      return "iPad Pro 12.9 Inch"
        case "iPad7,1", "iPad7,2":                      return "iPad Pro 12.9 Inch 2. Generation"
        case "iPad7,3", "iPad7,4":                      return "iPad Pro 10.5 Inch"
        case "AppleTV5,3":                              return "Apple TV"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
}


