//
//  WebViewViewController.swift
//  3M L&M
//
//  Created by IndianRenters on 26/08/17.
//  Copyright © 2017 3M L&M. All rights reserved.
//

import UIKit

class WebViewViewController: UIViewController, UIWebViewDelegate {
    var urlString:String = ""
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var progressView: UIProgressView!

    

    var myTimer: Timer = Timer()
    var theBool: Bool = Bool()
    
    var didFinishTimer: Timer = Timer()
    var webViewLoads = 0
    var webViewDidStart:Int = 0
    var webViewDidFinish:Int = 0
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print(urlString)
        webView.delegate = self

        progressView.trackTintColor = UIColor.white
        
        if let url = URL(string: String(format:"%@",urlString)) {
        let request = URLRequest(url: url)
        webView.loadRequest(request)
        }
    }
    
    
    
    
    func startAnimatingProgressBar() {
        self.theBool = false
        progressView.isHidden = false
        progressView.alpha = 0
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            self.progressView.alpha = 0.6
        })
        self.progressView.progress = 0.0
        
        //Tweek this number to alter the main speed of the progress bar
        let number = drand48() / 80;
        
        self.myTimer = Timer.scheduledTimer(timeInterval: number, target: self, selector: #selector(self.timerCallback), userInfo: nil, repeats: true)
    }
    
    func finishAnimatingProgressBar() {
        self.theBool = true
    }
    
    func timerCallback() {
        if self.theBool {
            print(progressView.progress)
            if self.progressView.progress >= 1 {
                UIView.animate(withDuration: 0.2, animations: { () -> Void in
                    self.progressView.alpha = 0
                })
                self.myTimer.invalidate()
            } else {
                //Loaded and zoom to finish
                let number = drand48() / 40
                self.progressView.progress += Float(number)
            }
            
        } else {
            //Start slow
            if self.progressView.progress >= 0.00 && self.progressView.progress <= 0.10 {
                let number = drand48() / 8000;
                self.progressView.progress += Float(number)
                //Middle speed up a bit
            } else if self.progressView.progress >= 0.10 && self.progressView.progress <= 0.42 {
                let smallerNumber = drand48() / 2000;
                self.progressView.progress += Float(smallerNumber)
                //                println("Middle:\(smallerNumber)")
                
                //slow it down again
            } else if progressView.progress >= 0.42 && self.progressView.progress <= 0.80 {
                let superSmallNumber = drand48() / 8000;
                self.progressView.progress += Float(superSmallNumber)
                //                println("slow it down:\(superSmallNumber)")
                
                //Stop it
            } else if progressView.progress == 0.80 {
                print("Stop:\(progressView.progress)")
                self.progressView.progress = 0.80
            }
        }
    }
    
    
    
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        
        print("START WEBVIEW")
        
        if(theBool == false){
        webViewDidStart = webViewDidStart + 1
        webViewLoads = webViewLoads + 1
        if webViewLoads <= 1 {
            startAnimatingProgressBar()
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        webViewLoads = webViewLoads - 1
        webViewDidFinish = webViewDidFinish + 1
        
        print(webViewLoads)
        
        if webViewLoads == 0 {
            finishAnimatingProgressBar()
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        theBool = true
        webViewLoads = 0
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
        print("didFailLoadWithError")
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
