//
//  GoogleMapViewController.swift
//  3M L&M
//
//  Created by IndianRenters on 28/08/17.
//  Copyright © 2017 3M L&M. All rights reserved.
//

import UIKit


protocol LocationDelegate: class {
    func selectedLocation(lattitude: Double, longitude:Double)
    
}


class GoogleMapViewController: UIViewController, CLLocationManagerDelegate,GMSMapViewDelegate
{
    var vwGMap = GMSMapView()
    
    var locationManager = CLLocationManager()
    let marker = GMSMarker()
    @IBOutlet weak var latLongLabel: UILabel!
    @IBOutlet weak var mapView: UIView!
    weak var delegate: LocationDelegate?

    @IBOutlet weak var saveBtn: UIButton!
    
    
    //    MARK: - View Life Cycle Methods
    
    
    override func viewDidAppear(_ animated: Bool) {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        saveBtn.setAttributedTitle(nil, for:  UIControlState.normal)
        
        saveBtn.setTitle(NSLocalizedString("SAVE", comment: "save"), for: UIControlState.normal)

        // A minimum distance a device must move before update event generated
        locationManager.distanceFilter = 500
        
        // Request permission to use location service
        locationManager.requestWhenInUseAuthorization()
        
        // Request permission to use location service when the app is run
        locationManager.requestWhenInUseAuthorization()
        
        // Start getting update of user's location
        locationManager.startUpdatingLocation()
        
        
        
        
        
        let camera: GMSCameraPosition = GMSCameraPosition.camera(withLatitude: 22.300000, longitude: 70.783300, zoom: 10.0)
        
        vwGMap = GMSMapView.map(withFrame:  CGRect(x: 0, y: 0, width: mapView.frame.width, height: mapView.frame.height), camera: camera)
        
        vwGMap.camera = camera
        
        // Add GMSMapView to current view
        self.mapView .addSubview(vwGMap)
        
        vwGMap.delegate = self
        vwGMap.settings.compassButton = true
        vwGMap.isMyLocationEnabled = true
        vwGMap.settings.myLocationButton = true
        vwGMap.mapType = kGMSTypeHybrid

        
        
        let iconSize = CGRect(origin: CGPoint.zero, size: CGSize(width: 21, height: 44))
        let backButton = UIButton(frame: iconSize)
        backButton.setImage(UIImage(named: "customBackArrow1.png"), for: .normal)

        backButton.addTarget(self, action: #selector(self.customBackButton), for: .touchUpInside)
        backButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        self.navigationItem.setHidesBackButton(true, animated:false)

        
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationItem.setHidesBackButton(false, animated:false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        saveBtn.setAttributedTitle(nil, for:  UIControlState.normal)
       self.title = NSLocalizedString("Verify GPS Location", comment: "")
        saveBtn.setTitle(NSLocalizedString("SAVE", comment: "save"), for: UIControlState.normal)
    }
    func customBackButton(){
        
        let alert = UIAlertController(title: NSLocalizedString("Cancel Verify GPS Location?", comment: "Cancel Verify GPS Location?"), message: NSLocalizedString("Are you sure you want to cancel this verify gps location screen?", comment: "Are you sure you want to cancel this verify gps location screen?"), preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: "Ok"), style: .default, handler: { (action: UIAlertAction!) in
            self.navigationController?.popViewController(animated: true)
        }))
        
        alert.addAction(UIAlertAction(title:NSLocalizedString("Cancel", comment: "Cancel") , style: .cancel, handler: { (action: UIAlertAction!) in
            
        }))
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print(coordinate.latitude)
        print(coordinate.longitude)
        
        
        latLongLabel.text = String(format:"%f, %f", coordinate.latitude, coordinate.longitude)

        let location = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        marker.position = location
        
        self.reverseGeocodeCoordinate(coordinate: coordinate, marker: marker)
        
        marker.map = mapView
    }
    
    func reverseGeocodeCoordinate(coordinate: CLLocationCoordinate2D, marker: GMSMarker) {
        
        // 1
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
          
        }
        
        // 2
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            if let address = response?.firstResult() {
                
                // 3
                let title = address.lines as! [String]?
                marker.title = title?.first
                
                UIView.animate(withDuration: 0.25) {
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    
    //    MARK: - CLLocationManagerDelegate Methods
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
    {
        if (status == CLAuthorizationStatus.authorizedWhenInUse)
        {
            vwGMap.isMyLocationEnabled = true
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        
        
        let newLocation = locations.last
        vwGMap.camera = GMSCameraPosition.camera(withTarget: newLocation!.coordinate, zoom: 15.0)
        vwGMap.settings.myLocationButton = true
        self.mapView .addSubview(vwGMap)

        latLongLabel.text = String(format:"%f, %f", newLocation!.coordinate.latitude, newLocation!.coordinate.longitude)
        marker.position = CLLocationCoordinate2DMake(newLocation!.coordinate.latitude, newLocation!.coordinate.longitude)
        marker.map = self.vwGMap
        marker.icon = GMSMarker.markerImage(with: UIColor(red: 133/255.0, green:185.0/255.0, blue: 51.0/255.0, alpha: 1.0))

        
        
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(newLocation!, completionHandler: { (placemarks, error) -> Void in
            let placeMark = placemarks![0]
            
            if let locationCity = placeMark.addressDictionary!["City"] as? NSString {
                self.marker.title = locationCity as String
            }
            
            if let locationName = placeMark.addressDictionary!["Name"] as? NSString {
                self.marker.snippet = locationName as String
            }
            
        })
    }
    
    
    func mapView(_ mapView: GMSMapView!, didTap marker: GMSMarker!) -> Bool {
        let point: CGPoint = self.vwGMap.projection.point(for: marker.position)
        //point.y -= 100
        self.vwGMap.animate(toLocation: self.vwGMap.projection.coordinate(for: point))
        self.vwGMap.selectedMarker = marker
        return true
    }
    
    
    
    @IBAction func saveButtonClicked(){
        delegate?.selectedLocation(lattitude: marker.position.latitude, longitude: marker.position.longitude)
        self.navigationController? .popViewController(animated: true)
    }
    
    

}

