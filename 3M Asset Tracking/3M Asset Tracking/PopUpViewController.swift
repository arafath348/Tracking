//
//  PopUpViewController.swift
//  3M L&M
//
//  Created by IndianRenters on 24/07/17.
//  Copyright © 2017 3M L&M. All rights reserved.
//

import UIKit


protocol PopupDelegate: class {
    func selectedValue(_ selectedString: String)
}


class PopUpViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    weak var delegate: PopupDelegate?
    var popupArray: NSArray = []
    var titleString: String = ""
    var selectedString: String = ""

    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var popupView: UIView?
    @IBOutlet weak var heightConstraint: NSLayoutConstraint?
    @IBOutlet weak var table: UITableView?
    @IBOutlet weak var cancelBtn: UIButton!

    override func viewWillAppear(_ animated: Bool) {
       self.titleLabel?.text = String(format:NSLocalizedString("%@", comment: "text"),titleString)
        cancelBtn.setTitle(NSLocalizedString("CANCEL", comment: "cancel"), for: UIControlState.normal)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
        self.showAnimate()
        
        // Do any additional setup after loading the view.
        
        var  height:CGFloat = 0
        
        
        let height1:CGFloat = CGFloat((102) + (popupArray.count * 44))
        let height2:CGFloat = self.view.frame.height - 150
        
        
        if height1 > height2{
            height = height2
        }
        else
        {
            height = height1
        }

        self.heightConstraint?.constant = height
        titleLabel?.text = titleString
         popupView?.layer.cornerRadius = 8

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    @IBAction func closePopup()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
            }
        });
    }
    
    
    // MARK:  UITableView Data Source Methods
    private func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat    {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return popupArray.count
    }
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 44.0
//    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        
//        let headerView = UIView()
//           let headerCell = tableView.dequeueReusableCell(withIdentifier: "CustomPopupTitleCell") as! CustomTableViewCell
//        headerCell.titleLabel.text = titleString
//        headerView.addSubview(headerCell)
//
//        return headerView
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : CustomTableViewCell
        
     
        if ((tableView.contentSize.height) < (tableView.frame.size.height)) {
            table?.isScrollEnabled = false
        }
        else {
            table?.isScrollEnabled = true
        }
        
        

        
        
        
            cell = tableView.dequeueReusableCell(withIdentifier: "CustomPopupCell") as! CustomTableViewCell!
            cell.titleLabel.text = popupArray .object(at: indexPath.row) as? String
        
        
        titleLabel?.lineBreakMode = .byWordWrapping
        titleLabel?.numberOfLines = 2
            if selectedString == cell.titleLabel.text{
                cell.iconImageView.image = UIImage(named: "radio_btn_on" )
            }
            else
            {
                cell.iconImageView.image = UIImage(named: "radio_btn_off" )
            }
      
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
            let cell : CustomTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CustomPopupCell") as! CustomTableViewCell!
            
                cell.iconImageView.image = UIImage(named: "radio_btn_on" )
                self.closePopup()
            delegate?.selectedValue(popupArray .object(at: indexPath.row) as! String)

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
