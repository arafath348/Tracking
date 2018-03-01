//
//  CustomActivityIndicator.swift
//  3M L&M
//
//  Created by dcwaters on 03/07/17.
//  Copyright © 2017 3M L&M. All rights reserved.
//


import UIKit

class CustomActivityIndicator {
    var containerView: UIView!
    var activityIndicator: UIActivityIndicatorView!
    var stopButton: UIButton!
    var showCancelButton: Bool = false
    var isVisible: Bool = false
    
    init() {
        containerView = UIView()
        activityIndicator = UIActivityIndicatorView()
        stopButton = UIButton(type: UIButtonType.custom)
    }
    

    
    func showActivityIndicator(_ aView: UIView?, showCancelButton: Bool) {
        isVisible = true
        let window = UIApplication.shared.delegate?.window!
        containerView.translatesAutoresizingMaskIntoConstraints = false
        window!.addSubview(containerView)
        
        
        var variableBindings = ["containerView": containerView!]
        var constraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[containerView]-0-|", options: [], metrics: nil, views: variableBindings)
        if let view = aView {
            view.addConstraints(constraints)
        } else {
            window?.addConstraints(constraints)
        }
        constraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[containerView]-0-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: variableBindings)
        if let view = aView {
            view.addConstraints(constraints)
        } else {
            window?.addConstraints(constraints)
        }
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        containerView.addSubview(activityIndicator)
        
        
        
        variableBindings = ["containerView":containerView, "activityIndicator":activityIndicator]
        constraints = NSLayoutConstraint.constraints(
            withVisualFormat: "V:[containerView]-(<=1)-[activityIndicator(==40)]",
            options: NSLayoutFormatOptions.alignAllCenterX,
            metrics: nil,
            views: variableBindings)
        containerView.addConstraints(constraints)
        constraints = NSLayoutConstraint.constraints(
            withVisualFormat: "H:[containerView]-(<=1)-[activityIndicator(==40)]",
            options: NSLayoutFormatOptions.alignAllCenterY,
            metrics: nil,
            views: variableBindings)
        containerView.addConstraints(constraints)
        containerView.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        
 
        
        activityIndicator.startAnimating()
    }
    
    func hideActivityIndicator() {
        isVisible = false
        if activityIndicator != nil {
            activityIndicator.stopAnimating()
            containerView.removeFromSuperview()
        }
    }
}
