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


func getLanguageFromCode(languageCode:[UInt8]) -> String{
    
    var language:String = ""
    if(languageCode == [0, 0, 1]){
        language = "English"
    }
    else if(languageCode == [0, 7, 2]){
        language = "Polish"
    }
    else if(languageCode == [0, 17, 2]){
        language = "Czech"
    }
    else if(languageCode == [6, 2, 0]){
        language = "Korean"
    }
    else if(languageCode == [6, 1, 0]){
        language = "Japanese"
    }
    else if(languageCode == [0, 5, 1]){
        language = "Finnish"
    }
    else if(languageCode == [6, 3, 0]){
        language = "Taiwanese"
    }
    else if(languageCode == [0, 2, 1]){
        language = "German"
    }
    else if(languageCode == [0, 15, 1]){
        language = "Dutch"
    }
    else if(languageCode == [6, 0, 0]){
        language = "Chinese"
    }
    else if(languageCode == [0, 3, 1]){
        language = "French"
    }
    else if(languageCode == [0, 8, 1]){
        language = "Italian"
    }
    else if(languageCode == [0, 10, 3]){
        language = "Russian"
    }
    else if(languageCode == [0, 19, 5]){
        language = "Turkish"
    }
    else if(languageCode == [0, 11, 4]){
        language = "Estonian"
    }
    else if(languageCode == [0, 1, 1]){
        language = "Spanish"
    }
    else if(languageCode == [0, 4, 1]){
        language = "Romanian"
    }
    else if(languageCode == [0, 9, 1]){
        language = "Norway"
    }
    else if(languageCode == [0, 6, 1]){
        language = "Danish"
    }
    else if(languageCode == [0, 18, 1]){
        language = "French"
    }
    else if(languageCode == [0, 14, 1]){
        language = "Portuguese"
    }
    else if(languageCode == [0, 144, 1]){
        language = "BAA"
    }
    else if(languageCode == [0, 12, 4]){
        language = "Swedish"
    }
    else if(languageCode == [0, 13, 4]){
        language = "Lithuanian"
    }
    
    
    return language
}











