//
//  NewReceipViewController.swift
//  Receips
//
//  Created by Ignacio Jacob on 10/08/17.
//  Copyright © 2017 Ignacio Jacob. All rights reserved.
//

import UIKit
import AVFoundation
import TesseractOCR

class NewReceipViewController: UIViewController, UITextFieldDelegate , AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureMetadataOutputObjectsDelegate, G8TesseractDelegate{

    
    @IBOutlet weak var clear: UIButton!
    @IBOutlet weak var previewContainer: UIView!
    @IBOutlet weak var feedbackLabel: UILabel!
    @IBOutlet weak var qrcodeframe: UIView!
    
    @IBOutlet weak var conceptTF: UITextField!
    @IBOutlet weak var ammountTF: UITextField!
    @IBOutlet weak var dateTF: UITextField!
    
    @IBOutlet weak var kindSegmented: UISegmentedControl!
    @IBOutlet weak var isIncomeSegmented: UISegmentedControl!
    
    @IBOutlet weak var scanning: UIProgressView!
    
    @IBOutlet weak var addButton: UIButton!
    
    var picker: UIDatePicker!

    var controller = ReceipController()
    
    var previewLayer:AVCaptureVideoPreviewLayer?
    
    let stillImageOutput:AVCaptureStillImageOutput? = AVCaptureStillImageOutput()
    
//    MARK:
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        qrcodeframe.layer.borderColor = UIColor.green.cgColor
        qrcodeframe.layer.borderWidth = 2
        
        
        let doneToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 200, height: 46))
        let button = UIBarButtonItem(title: "OK", style: UIBarButtonItemStyle.done, target: self, action: #selector(doneDateEditing))
        doneToolbar.setItems([button], animated: true)
        

        
        picker = UIDatePicker()
        picker.datePickerMode = .dateAndTime
        picker.date = Date()
        picker.maximumDate = Date()
        
        dateTF.inputAccessoryView = doneToolbar
        dateTF.inputView = picker
        
        ammountTF.inputAccessoryView = doneToolbar
        
        scanning.progress = 0
        
        initCamera()
        doneDateEditing()
    }
    
    //MARK: - private methods
    
    func doneDateEditing(){
        
        let date = picker.date
        
        let formater = DateFormatter()
        formater.dateStyle = .long
        formater.timeStyle = .short
        
        dateTF.text = formater.string(from: date)
        
        self.view.endEditing(true)
        
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
                    captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
                }
                
                session.startRunning()
                previewContainer.bringSubview(toFront: qrcodeframe)
                
                
                
            } catch let error{
                print(error.localizedDescription)
            }
            
        }
        
        
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
                        
                        //self.captureText(image: uiimage)

                    }
                    
                }
                
            })
            
        }
        
        self.clear.isHidden = false
        
    }
    
    func addReceip(){
        
        let concept = conceptTF.text ?? "Untitled"
        
        let kind = kindSegmented.selectedSegmentIndex
        
        let isIncome = isIncomeSegmented.selectedSegmentIndex == 1 ? true:false
        
        
        if let ammountval = ammountTF.text{
            
            let numFormater = NumberFormatter()
            numFormater.numberStyle = .currency

            if let ammount = numFormater.number(from: ammountval)?.doubleValue{
                
                controller.addRepecip(concept: concept, ammount: ammount, date: picker.date, photo: nil, kind: kind, isIncome: isIncome)

            }
        }
        
        
    }
    
    func captureText(image:UIImage){
        
        if let tesseract = G8Tesseract(language: "spa_old"){
            tesseract.delegate = self
            tesseract.image = image
            tesseract.recognize()
            
            feedbackLabel.text = tesseract.recognizedText
        }
    }
    
    func checkFields(){
        
        var valid = false
        
        if conceptTF.text != nil{
           
            if let ammountval = ammountTF.text{
                
                let numFormater = NumberFormatter()
                numFormater.numberStyle = .currency
                
                if let ammount = numFormater.number(from: ammountval)?.doubleValue{
                    
                    if ammount > 0 {
                        
                        valid = true
                        
                    }
                    
                }
            }
        }
        
        addButton.isEnabled = valid
    
    }
    //MARK: - IBActions
    
    @IBAction func tapCapture(_ sender: Any) {
        takePhoto()
    }
    
    @IBAction func tapAdd(_ sender: Any) {
        addReceip()
    }
    
    @IBAction func tapClear(_ sender: Any) {
        cleanScreen()
    }
    
    @IBAction func ammountTFDidChange(_ sender: UITextField) {
        
        if let amountString = sender.text?.currencyInputFormatting() {
            sender.text = amountString
        }
    }
    
    //MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        UIView.animate(withDuration: 0.4) {
            var frame = self.view.frame
            
            
            frame.origin.y -= 250
            
            self.view.frame = frame
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.4) {
            var frame = self.view.frame
            
            
            frame.origin.y += 250
            
            self.view.frame = frame
        }
        
        checkFields()
    }
    
    
    
    // MARK: - AVCaptureVideoDataOutputSampleBufferDelegate
    
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
    
    // MARK: - G8TesseractDelegate
    
    func progressImageRecognition(for tesseract: G8Tesseract!) {
        print(tesseract.progress)
        scanning.progress = Float(tesseract.progress)
    }
}
//
//extension String {
//    
//    // formatting text for currency textField
//    func currencyInputFormatting() -> String {
//        
//        var number: NSNumber!
//        let formatter = NumberFormatter()
//        formatter.numberStyle = .currencyAccounting
//        formatter.currencySymbol = "$"
//        formatter.maximumFractionDigits = 2
//        formatter.minimumFractionDigits = 2
//        
//        var amountWithPrefix = self
//        
//        // remove from String: "$", ".", ","
//        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
//        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count), withTemplate: "")
//        
//        let double = (amountWithPrefix as NSString).doubleValue
//        number = NSNumber(value: (double / 100))
//        
//        // if first number is 0 or all numbers were deleted
//        guard number != 0 as NSNumber else {
//            return ""
//        }
//        
//        return formatter.string(from: number)!
//    }
//}
