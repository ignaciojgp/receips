//
//  NewGoalViewController.swift
//  Receips
//
//  Created by Ignacio J Gonzalez Pérez on 26/07/17.
//  Copyright © 2017 Ignacio Jacob. All rights reserved.
//

import UIKit

class NewGoalViewController: UIViewController {

    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var ammountTF: UITextField!
    @IBOutlet weak var balanceTF: UITextField!
    @IBOutlet weak var notifySC: UISegmentedControl!
    @IBOutlet weak var periodSC: UISegmentedControl!
    @IBOutlet weak var numPeriodLabel: UILabel!
    @IBOutlet weak var periodAmmountLabel: UILabel!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var duedatetf: UITextField!
    
    var controller:GoalsController?
    var picker: UIDatePicker!
    static let  dateformat = "dd MMMM yyyy"
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        let doneToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 200, height: 46))
        let button = UIBarButtonItem(title: "OK", style: UIBarButtonItemStyle.done, target: self, action: #selector(doneEditing))
        doneToolbar.setItems([button], animated: true)
        nameTF.inputAccessoryView = doneToolbar
        ammountTF.inputAccessoryView = doneToolbar
        balanceTF.inputAccessoryView = doneToolbar
        duedatetf.inputAccessoryView = doneToolbar
        
        picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.minimumDate = Date()
        picker.date = Date(timeIntervalSinceNow: 366*24*60*60)
    
        duedatetf.inputView = picker
        
        doneEditing()
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func doneEditing(){
        
        let date = picker.date
        
        let formater = DateFormatter()
        formater.dateFormat = NewGoalViewController.dateformat
        
        duedatetf.text = formater.string(from: date)
        
        self.view.endEditing(true)
        
        calculate()
    }
    
    @IBAction func changeAmmount(_ sender: Any) {
        calculate()
    }

    @IBAction func changeBalance(_ sender: Any) {
        calculate()
    }
    
    @IBAction func changeNotify(_ sender: Any) {
    }
    
    @IBAction func changePeriod(_ sender: Any) {
        calculate()
    }
    
    @IBAction func selectDate(_ sender: Any) {
        
        showDatePicker()
    }
    @IBAction func save(_ sender: Any) {
        
        
        let numFormater = NumberFormatter()
        
        let name = nameTF.text ?? "Sin título"
        
        let ammount = numFormater.number(from: (ammountTF.text ?? "0"))?.doubleValue ?? 0
        let balance = numFormater.number(from: (balanceTF.text ?? "0"))?.doubleValue ?? 0
        
        let formater = DateFormatter()
        let notify = notifySC.selectedSegmentIndex == 0 ? true:false
        
        formater.dateFormat = NewGoalViewController.dateformat
        
        let date = formater.date(from: duedatetf.text!)
        
        
        var paymentspermonth :Int
        
        switch periodSC.selectedSegmentIndex {
        case 0:
            paymentspermonth = 4
            break
        case 1:
            paymentspermonth = 2
            break
        default:
            paymentspermonth = 1
            break
        }
        
        if date != nil{
            
            if let numperiods = controller?.getPeriodsForGoal(duedate: date!, paymentsPerMont: paymentspermonth){
                
                let nump = numperiods > 0 ? numperiods:1
                
                controller?.addGoal(balance: balance, dueDate: date!, name: name, notify: notify, period: Int16(paymentspermonth), targetAmmount: ammount, numPays: nump)

            }
            
        }

        self.navigationController?.popToRootViewController(animated: true)
        
    }
    
    func showDatePicker(){
        
        let picker = UIDatePicker()
        picker.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(picker)
        
        
        
        view.addConstraint(NSLayoutConstraint(item: picker, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: -64))
        view.addConstraint(NSLayoutConstraint(item: picker, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1, constant: 1))
        
        
        let heightCons = NSLayoutConstraint(item: picker, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 300)
        
       
        picker.addConstraint(heightCons)

        picker.backgroundColor = UIColor.white
        picker.date = Date()
        
        let doneToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 200, height: 46))
        let button = UIBarButtonItem(title: "OK", style: UIBarButtonItemStyle.done, target: self, action: #selector(doneEditing))
        doneToolbar.setItems([button], animated: true)
        

    
    }
    
    func calculate(){
        
        
        let numFormater = NumberFormatter()
        
        
        
        let ammount = numFormater.number(from: (ammountTF.text ?? "0"))?.doubleValue ?? 0
        let balance = numFormater.number(from: (balanceTF.text ?? "0"))?.doubleValue ?? 0
        
        let formater = DateFormatter()
        
        formater.dateFormat = NewGoalViewController.dateformat
        
        let date = formater.date(from: duedatetf.text!)
        
        
        var paymentspermonth :Int
        
        switch periodSC.selectedSegmentIndex {
        case 0:
            paymentspermonth = 4
            break
        case 1:
            paymentspermonth = 2
            break
        default:
            paymentspermonth = 1
            break
        }
        
        if date != nil{
            
            if let numperiods = controller?.getPeriodsForGoal(duedate: date!, paymentsPerMont: paymentspermonth){
            
                let nump = numperiods > 0 ? numperiods:1
                
                let periodAmmount = (ammount - balance) / Double(nump)
            
                numPeriodLabel.text = nump.description
                
                
                let ammountFormater = NumberFormatter()
                
                ammountFormater.maximumFractionDigits = 2
                ammountFormater.minimumFractionDigits = 2
                ammountFormater.numberStyle = .currency
                
                periodAmmountLabel.text = ammountFormater.string(from: NSNumber(value: periodAmmount))
                
            }
            
        }
        
        
    }
    
    
    

}
