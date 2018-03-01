//
//  BarcodeScannerViewController.swift
//  3M L&M
//
//  Created by Arafath on 30/07/17.
//  Copyright © 2017 3M L&M. All rights reserved.
//

import UIKit
import AVFoundation

class BarcodeScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    @IBOutlet weak var messageLabel:UILabel!
    @IBOutlet weak var videoView:UIView!
    
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    var captureDevice:AVCaptureDevice?
    
    var lastCapturedCode:String?
    
    public var barcodeScanned:((String) -> ())?
    
    private var allowedTypes = [AVMetadataObjectTypeDataMatrixCode,
                                AVMetadataObjectTypeInterleaved2of5Code,
                                AVMetadataObjectTypeITF14Code,
                                AVMetadataObjectTypeUPCECode,
                                AVMetadataObjectTypeCode39Code,
                                AVMetadataObjectTypeCode39Mod43Code,
                                AVMetadataObjectTypeEAN13Code,
                                AVMetadataObjectTypeEAN8Code,
                                AVMetadataObjectTypeCode93Code,
                                AVMetadataObjectTypeCode128Code,
                                AVMetadataObjectTypePDF417Code,
                                AVMetadataObjectTypeQRCode,
                                AVMetadataObjectTypeAztecCode]
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        messageLabel.text = NSLocalizedString("No Barcode or QR code is detected", comment: " ")
        // Retrieve the default capturing device for using the camera
        self.captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        // Get an instance of the AVCaptureDeviceInput class using the previous device object.
        var error:NSError?
        let input: AnyObject!
        do {
            input = try AVCaptureDeviceInput(device:captureDevice)
        } catch let error1 as NSError {
            error = error1
            input = nil
        }
        
        if (error != nil) {
            // If any error occurs, simply log the description of it and don't continue any more.
            print("\(String(describing: error?.localizedDescription))")
            return
        }
        
        // Initialize the captureSession object and set the input device on the capture session.
        captureSession = AVCaptureSession()
        captureSession?.addInput(input as! AVCaptureInput)
        
        // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureSession?.addOutput(captureMetadataOutput)
        
        // Set delegate and use the default dispatch queue to execute the call back
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        captureMetadataOutput.metadataObjectTypes = self.allowedTypes
        
        // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravityResize
        videoPreviewLayer?.frame = videoView.layer.bounds
        videoView.layer.addSublayer(videoPreviewLayer!)
        
        // Start video capture.
        captureSession?.startRunning()
        
        // Move the message label to the top view
        view.bringSubview(toFront: messageLabel)
        
        // Initialize QR Code Frame to highlight the QR code
        qrCodeFrameView = UIView()
        qrCodeFrameView?.layer.borderColor = UIColor.red.cgColor
        qrCodeFrameView?.layer.borderWidth = 2
        qrCodeFrameView?.autoresizingMask = [UIViewAutoresizing.flexibleTopMargin, UIViewAutoresizing.flexibleBottomMargin, UIViewAutoresizing.flexibleLeftMargin, UIViewAutoresizing.flexibleRightMargin]
        
        view.addSubview(qrCodeFrameView!)
        view.bringSubview(toFront:qrCodeFrameView!)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //TealiumHelper.trackView(NSStringFromClass(self.classForCoder), dataSources: [:])
        
    }
    
    
    public override func viewWillLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
        
        
        
        let orientation = UIApplication.shared.statusBarOrientation
        
        switch(orientation) {
        case UIInterfaceOrientation.landscapeLeft:
            videoPreviewLayer?.connection.videoOrientation = AVCaptureVideoOrientation.landscapeLeft
            
        case UIInterfaceOrientation.landscapeRight:
            videoPreviewLayer?.connection.videoOrientation = AVCaptureVideoOrientation.landscapeRight
            
        case UIInterfaceOrientation.portrait:
            videoPreviewLayer?.connection.videoOrientation = AVCaptureVideoOrientation.portrait
            
        case UIInterfaceOrientation.portraitUpsideDown:
            videoPreviewLayer?.connection.videoOrientation = AVCaptureVideoOrientation.portraitUpsideDown
            
        default:
            print("Unknown orientation state")
        }
    }
    
    public override func viewDidLayoutSubviews() {
        videoPreviewLayer?.frame = self.videoView.layer.bounds

    }
    
    public override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        videoPreviewLayer?.frame = videoView.layer.bounds
    }
    
    public func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            messageLabel.text = NSLocalizedString("No Barcode is detected", comment: "No Barcode is detected") 
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if self.allowedTypes.contains(metadataObj.type) {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj as AVMetadataMachineReadableCodeObject) as! AVMetadataMachineReadableCodeObject
            
            qrCodeFrameView?.frame = barCodeObject.bounds;
            
            if metadataObj.stringValue != nil {
                messageLabel.text = metadataObj.stringValue
                lastCapturedCode = metadataObj.stringValue
                
                print("Scanned barcode: \(metadataObj.stringValue)")
                
                
                _ = self.navigationController?.popViewController(animated: true)
                
                if let barcodeScannedTemp = barcodeScanned, let lastCapturedCodeTemp = lastCapturedCode  {
                    // Notify via callback
                    barcodeScannedTemp(lastCapturedCodeTemp)
                }
            }
        }
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        _ = self.navigationController?.popViewController(animated: true)
        
        if let barcodeScannedTemp = barcodeScanned, let lastCapturedCodeTemp = lastCapturedCode  {
            // Notify via callback
            barcodeScannedTemp(lastCapturedCodeTemp)
        }
    }
    
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
