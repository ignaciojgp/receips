//
//  ViewController.swift
//  Receips
//
//  Created by Ignacio Jacob on 18/07/17.
//  Copyright © 2017 Ignacio Jacob. All rights reserved.
//

import UIKit
import AVFoundation


class ViewController: UIViewController, UITextFieldDelegate , AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureMetadataOutputObjectsDelegate{

    
    @IBOutlet weak var clear: UIButton!
    @IBOutlet weak var previewContainer: UIView!
    @IBOutlet weak var feedbackLabel: UILabel!
    @IBOutlet weak var qrcodeframe: UIView!
    
    var previewLayer:AVCaptureVideoPreviewLayer?
    
    let stillImageOutput:AVCaptureStillImageOutput? = AVCaptureStillImageOutput()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        qrcodeframe.layer.borderColor = UIColor.green.cgColor
        qrcodeframe.layer.borderWidth = 2
        
        
        
        initCamera()
    }
    
    func initCamera(){
        
        let session = AVCaptureSession()
        let videoDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        qrcodeframe?.frame = CGRect.zero

        if videoDevice != nil {
            
            do {
                
                let videoInput : AVCaptureDeviceInput? = try AVCaptureDeviceInput(device: videoDevice)
                
                if session.canAddInput(videoInput) {
                    session.addInput(videoInput)
                    previewLayer = AVCaptureVideoPreviewLayer(session: session)
                    previewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill;

                    previewLayer?.frame = self.previewContainer.bounds
                    self.previewContainer.layer.addSublayer(previewLayer!)
                }
                
                
                //capturador de fotos
                if session.canAddOutput(stillImageOutput){
                    session.addOutput(stillImageOutput)
                }
                
                
                //lector de qr
                let captureMetadataOutput = AVCaptureMetadataOutput()
                if session.canAddOutput(captureMetadataOutput){
                    session.addOutput(captureMetadataOutput)
                    
                    captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                    captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code]
                }
                
                session.startRunning()
                previewContainer.bringSubview(toFront: qrcodeframe)


                
            } catch let error{
                print(error.localizedDescription)
            }
            
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func cleanScreen(){
        for view in previewContainer.subviews{
            view.removeFromSuperview()
        }
        
        self.clear.isHidden = true
    }

    func takePhoto() {
        
        if let imageConnection = stillImageOutput?.connection(withMediaType: AVMediaTypeVideo){
            stillImageOutput?.captureStillImageAsynchronously(from: imageConnection, completionHandler: { (buffer, error) in
                
                if let image = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(buffer){

                    
                    if let uiimage = UIImage(data: image){
                        
                        
                        let imagev = UIImageView(image: uiimage)
                        
                        
                        
                        imagev.frame = CGRect(x: 0, y: 0, width: self.previewContainer.frame.width, height: self.previewContainer.frame.height)
                        
                        imagev.contentMode = .scaleAspectFit
                        
                        self.previewContainer.addSubview(imagev)
                        
                
                    }
            
                }
        
            })

        }
        
        self.clear.isHidden = false
        
    }

    
    @IBAction func tapCapture(_ sender: Any) {
        
        takePhoto()
        
        
    }
    
    @IBAction func tapAdd(_ sender: Any) {
    }
    @IBAction func tapClear(_ sender: Any) {
        cleanScreen()
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrcodeframe?.frame = CGRect.zero
            feedbackLabel.text = "No QR code is detected"
            return
        }

        if let metadataObj = metadataObjects[0] as? AVMetadataMachineReadableCodeObject{

            
            
            if metadataObj.type == AVMetadataObjectTypeQRCode {
                // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
                let barCodeObject = previewLayer?.transformedMetadataObject(for: metadataObj)
                qrcodeframe?.frame = barCodeObject!.bounds
                

                if metadataObj.stringValue != nil {
                    feedbackLabel.text = metadataObj.stringValue
                }
            }
            
            if metadataObj.type == AVMetadataObjectTypeEAN13Code {
                
                let barCodeObject = previewLayer?.transformedMetadataObject(for: metadataObj)
                qrcodeframe?.frame = barCodeObject!.bounds
                
                
                if metadataObj.stringValue != nil {
                    feedbackLabel.text = metadataObj.stringValue
                }

            }
        }
        
        

    }
}

