//
//  DeviceListViewController.swift
//  AirconsoleSwift
//
//  Created by Daniel Hope on 01/12/2015.
//  Copyright © 2015 Cloudstore. All rights reserved.
//

import UIKit


class DeviceListViewController: UITableViewController, AirconsoleMgrDelegate {
    
    var manager = AirconsoleMgr()
    var currentDevices: NSArray = []
    var currentSession:AirconsoleSession?
    var rfidBytesArray : [UInt8] = []
    var tblLogData: [String : Any] = [:]
    var dataLabelArray = NSArray()
    var dataDescriptionArray = NSArray()
    var fromScreen: String = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
        print(rfidBytesArray)

        // assign the delegate so we know when devices are added/removed/etc
        self.manager.delegate = self

        // Should we scan on WiFi?
        self.manager.scanWiFi = false
        
        
   //      Should web scan on Bluetooth
        self.manager.scanBluetooth = true
        
        
  //       If scanning on Bluetooth and radio is powered off, should we warn user?
        self.manager.disableBluetoothWarning = false
        
        
    //     start scanning for devices
        self.manager.scanForDevices()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //TealiumHelper.trackView(NSStringFromClass(self.classForCoder), dataSources: [:])
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (currentSession != nil) {
            currentSession!.delegate = nil
            if (currentSession!.connecting || currentSession!.connected) {
                currentSession!.disconnect()
            }
        }
        

    }
    
    func reloadDeviceList() {
        // update the device array with the airconsoles list
        self.currentDevices = self.manager.deviceList()! as NSArray
    
        self.tableView.reloadData()
    }
    
    // AirconsoleMgrDelegate
    func deviceAdded(_ device: AirconsoleDevice) {
        print("Device discovered \(device.name!), ip=\(device.ipAddress)")
        reloadDeviceList()
    }
    
    func deviceRemoved(_ device: AirconsoleDevice) {
        reloadDeviceList()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.currentDevices.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = indexPath.row;
        let CellID = "DeviceCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CellID)
        
            let device = self.currentDevices[row] as! AirconsoleDevice;
            
            var transport = ""
            if (device.transport == AC_TRANSPORT_BLE) {
                transport = "BLE"
            }
            cell?.textLabel?.text = "\(device.name!) (\(transport))"
                return cell!;
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            return NSLocalizedString("Detected Devices", comment: "Detected Devices")

    }

    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if (self.currentDevices.count == 0) {
            return NSLocalizedString("No devices detected", comment: "No devices detected");
        }
        return nil;
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let selectedPath:IndexPath = self.tableView.indexPath(for: (sender as? UITableViewCell)!)!
        var selectedDevice = self.manager.defaultDevice()
        if (selectedPath.section == 0) {
            selectedDevice = self.currentDevices[selectedPath.row] as? AirconsoleDevice
        }
        if (segue.identifier == "session_details") {
            
            let session:AirconsoleSession = AirconsoleSession(device: selectedDevice)
            currentSession = session
            let sdvc:SessionDetailsViewController = segue.destination as! SessionDetailsViewController
            sdvc.session = session
            sdvc.rfidBytesArray = rfidBytesArray
            sdvc.dataLabelArray = dataLabelArray
            sdvc.dataDescriptionArray = dataDescriptionArray
            sdvc.tblLogData = tblLogData
            sdvc.fromScreen = fromScreen


        }
    }
    

    
    
    
    
    
}
