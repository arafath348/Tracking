//
//  DataCaptureViewController.swift
//  3M L&M
//
//  Created by IndianRenters on 22/08/17.
//  Copyright © 2017 3M L&M. All rights reserved.
//

import UIKit

class DataCaptureViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    var dataCaptureArray = NSMutableArray()

    
    override func viewDidAppear(_ animated: Bool) {
        //TealiumHelper.trackView(NSStringFromClass(self.classForCoder), dataSources: [:])
        
    }
    override func viewWillAppear(_ animated: Bool) {
        dataCaptureArray = NSMutableArray()
        
        self.changeLanguage()
    
        
    }
    func changeLanguage(){
        self.title = NSLocalizedString("Data Capture", comment: "Data Capture")
        let database = DatabaseHandler()

        let canUseRFID:String = database.getUserProfile(columnName: "canUseRFID")
        let canUseEMSMarker:String = database.getUserProfile(columnName: "canUseEMSMarker")
        let canUseCableAccessories:String = database.getUserProfile(columnName: "canUseCableAccessories")
        
        if(canUseRFID == "Y"){
            dataCaptureArray.add(NSLocalizedString("RFID Program", comment: "RFID Program"))
        }
        if(canUseEMSMarker == "Y"){
            dataCaptureArray.add(NSLocalizedString("EMS Passive / Path / Cable depth", comment: "EMS Passive / Path / Cable depth"))
        }
        if(canUseRFID == "Y" || canUseEMSMarker == "Y"){
            dataCaptureArray.add(NSLocalizedString("Locator Record Capture", comment: "Locator Record Capture"))
        }
        if(canUseCableAccessories == "Y"){
            dataCaptureArray.add(NSLocalizedString("Cable Accessories", comment: "Cable Accessories"))
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.changeLanguage()

        
        // Do any additional setup after loading the view.
        
        dataCaptureArray = NSMutableArray()

        let database = DatabaseHandler()
        
        
        let canUseRFID:String = database.getUserProfile(columnName: "canUseRFID")
        let canUseEMSMarker:String = database.getUserProfile(columnName: "canUseEMSMarker")
        let canUseCableAccessories:String = database.getUserProfile(columnName: "canUseCableAccessories")

        if(canUseRFID == "Y"){
            dataCaptureArray.add(NSLocalizedString("RFID Program", comment: "RFID Program"))
        }
        if(canUseEMSMarker == "Y"){
            dataCaptureArray.add(NSLocalizedString("EMS Passive / Path / Cable depth", comment: "EMS Passive / Path / Cable depth"))
        }
        if(canUseRFID == "Y" || canUseEMSMarker == "Y"){
            dataCaptureArray.add(NSLocalizedString("Locator Record Capture", comment: "Locator Record Capture"))
        }
         if(canUseCableAccessories == "Y"){
            dataCaptureArray.add(NSLocalizedString("Cable Accessories", comment: "Cable Accessories"))
        }
        
        

        
    }

    
    // MARK:  UITableView Data Source Methods
    private func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat    {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataCaptureArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : CustomTableViewCell = (tableView.dequeueReusableCell(withIdentifier: "CustomDataCaptureCell") as! CustomTableViewCell!)
        cell.titleLabel.text = dataCaptureArray .object(at: indexPath.row) as? String
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if(dataCaptureArray.object(at: indexPath.row) as! String == NSLocalizedString("RFID Program", comment: "RFID Program")){
            let viewController = self.storyboard!.instantiateViewController(withIdentifier: "RFIDViewController") as! RFIDViewController
            self.navigationController!.pushViewController(viewController, animated: true)
        }
        else if(dataCaptureArray.object(at: indexPath.row) as! String == NSLocalizedString("EMS Passive / Path / Cable depth", comment: "EMS Passive / Path / Cable depth")){
            let viewController = self.storyboard!.instantiateViewController(withIdentifier: "EmsPassiveViewController") as! EmsPassiveViewController
            self.navigationController!.pushViewController(viewController, animated: true)
        }
        else if(dataCaptureArray.object(at: indexPath.row) as! String == NSLocalizedString("Cable Accessories", comment: "Cable Accessories")){
            let viewController = self.storyboard!.instantiateViewController(withIdentifier: "CableAccesoriesViewController") as! CableAccesoriesViewController
            self.navigationController!.pushViewController(viewController, animated: true)
        }
        else if(dataCaptureArray.object(at: indexPath.row) as! String == NSLocalizedString("Locator Record Capture", comment: "Locator Record Capture")){
            let viewController = UIStoryboard(name: "Airconsole", bundle: nil).instantiateViewController(withIdentifier: "DeviceListViewController") as! DeviceListViewController
            viewController.fromScreen = "Locator Record Capture"
            self.navigationController!.pushViewController(viewController, animated: true)
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
