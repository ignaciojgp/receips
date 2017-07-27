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
    @IBOutlet weak var duedateTF: UITextField!
    @IBOutlet weak var notifySC: UISegmentedControl!
    @IBOutlet weak var periodSC: UISegmentedControl!
    @IBOutlet weak var numPeriodLabel: UILabel!
    @IBOutlet weak var periodAmmountLabel: UILabel!
    @IBOutlet weak var saveBtn: UIButton!
    
    var controller:GoalsController?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        let doneToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 200, height: 46))
        let button = UIBarButtonItem(title: "OK", style: UIBarButtonItemStyle.done, target: self, action: #selector(doneEditing))
        doneToolbar.setItems([button], animated: true)
        nameTF.inputAccessoryView = doneToolbar
        ammountTF.inputAccessoryView = doneToolbar
        balanceTF.inputAccessoryView = doneToolbar
        duedateTF.inputAccessoryView = doneToolbar
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func doneEditing(){
        self.view.endEditing(true)
    }
    
    @IBAction func changeAmmount(_ sender: Any) {
    }

    @IBAction func changeBalance(_ sender: Any) {
    }
    
    @IBAction func changeNotify(_ sender: Any) {
    }
    
    @IBAction func changePeriod(_ sender: Any) {
    }
    
    func calculate(){
        
        //let numperiods = controller?
        
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
