//
//  Utility.swift
//  3M L&M
//
//  Created by dcwaters on 03/07/17.
//  Copyright © 2017 3M L&M. All rights reserved.
//

import UIKit

var activityIndicator = CustomActivityIndicator()

func isNetworkAvailable() -> Bool {
    
    if isConnectedToNetwork() {
        
    } else {
        showNoNetworkAlert()
    }
    
    return isConnectedToNetwork()
}

/*
 Shows an alert for No Network
 */
func showNoNetworkAlert() {
    showAlert(kAlertTitleNoNetwork, message: kAlertMessageNoNetwork)
}

/*
 Shows alert over a the viewController
 */
func showAlert(_ title : String, message : String) {
    DispatchQueue.main.async(execute: { () -> Void in
        let topViewController = UIApplication.topViewController()
        if let _ = UIApplication.topViewController() {
            let alert:UIAlertController = UIAlertController(title: title, message: message, preferredStyle:.alert)
            alert.addAction(UIAlertAction(title: kAlertActionOK, style: .default) { (action) -> Void in
                //alert.presentingViewController?.dismissViewControllerAnimated(false, completion: nil)
                })
            topViewController!.present(alert, animated:true, completion:nil)
        }
    })
}

func showActivityIndicator(_ withCancelButton: Bool) {
    DispatchQueue.main.async(execute: { () -> Void in
        activityIndicator.hideActivityIndicator()
        activityIndicator.showActivityIndicator(nil, showCancelButton: withCancelButton)
    })
}

func hideActivityIndicator() {
    DispatchQueue.main.async(execute: { () -> Void in
        activityIndicator.hideActivityIndicator()
    })
}

func hideActivityIndicatorAndShowAlert(_ title : String, message : String) {
    hideActivityIndicator()
    DispatchQueue.main.async(execute: { () -> Void in
        if !message.isEmpty {
            showAlert(title, message: message)
        }
    })
}

func validateEmailWithString(_ emailStr : String?) -> Bool {
    guard let emailStr = emailStr else {
        return false
    }
    let emailRegex : NSString = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
    let emailTest : NSPredicate = NSPredicate(format:"SELF MATCHES %@",emailRegex)
    return emailTest.evaluate(with: emailStr);
}




func validatePhoneWithString(_ phoneStr : String) -> Bool {
        if (phoneStr.characters.count != 10) {
        return false
    }
    
    return true
}








func isPasswordValid(_ password : String) -> Bool{
    
  
     let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[A-Z])(?=.*[0-9])[A-Za-z\\d$@$#!%*?&]{8,}")
     return passwordTest.evaluate(with: password)
    
}











