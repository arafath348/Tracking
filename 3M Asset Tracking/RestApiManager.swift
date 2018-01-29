//
//  RestApiManager.swift
//  3M L&M
//
//  Created by dcwaters on 03/07/17.
//  Copyright © 2017 3M L&M. All rights reserved.
//

import Foundation
import UIKit


typealias ServiceResponse = (JSON, NSError?) -> Void



class RestApiManager: NSObject {
    static let sharedInstance = RestApiManager()
    
        
    func getRandomUser(_ paramText: String, onCompletion: @escaping (JSON) -> Void) {
        
        
        showActivityIndicator(false)

        
        let route = kUrlBase + paramText

        
        print(route);
        makeHTTPGetRequest(path: route, onCompletion: { json, err in
            onCompletion(json as JSON)
        })
    }
    
    
    
    
    func makeHTTPGetRequest(path: String, onCompletion: @escaping ServiceResponse) {
        
        
        
        
        let encodedString = path.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)

        
        
        
        let request = NSURLRequest(url:  NSURL(string: encodedString!)! as URL, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 60.0)
        
        let session = URLSession.shared
        
        
        
        
        
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            
         
            
                
                
                if (error != nil) {
                    
                    
                DispatchQueue.main.async {
                 hideActivityIndicatorAndShowAlert(NSLocalizedString("No Internet Connection", comment: "Make sure your device is connected to the internet."), message: NSLocalizedString("No Internet Connection", comment: "Make sure your device is connected to the internet."))
                }                    
                }
                    
                    else {
                    
                    let json:JSON = JSON(data: data!)
                    onCompletion(json, error as NSError?)
                    
                }
            
        })
        task.resume()
        
        
        
    }
    
    
    
    
}

