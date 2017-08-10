//
//  GoalDetailTableViewController.swift
//  Receips
//
//  Created by Ignacio Jacob on 31/07/17.
//  Copyright © 2017 Ignacio Jacob. All rights reserved.
//

import UIKit

struct cells {
    static let HEADER = "Header"
    static let VALUE = "ValueCell"
    static let PAYMENT = "payments"
    static let OP_MOV = "Mov"
    static let OP_CALC = "Calc"
    
}




class GoalDetailTableViewController: UITableViewController {
    
    var controller:GoalsController?
    var item:MOGoal?
    var dateformater:DateFormatter = DateFormatter()
    var moneyformater:NumberFormatter = NumberFormatter()
    var numPayments:Int = 0

    
//    MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        moneyformater.numberStyle = .currency

        dateformater.dateFormat = "dd MMM yyyy"
        
        title = item?.name
        
        

    }

    
    
    //MARK: - IBActions
    
    @IBAction func addPayment(_ sender: Any) {
        
        let alertview = UIAlertController(title: "Abonar", message: "Cuanto desea abonar ", preferredStyle: .alert)
        
        alertview.addTextField { (fiel) in
            fiel.placeholder = "cantidad"
            fiel.keyboardType = .decimalPad
            
            
            let payment = self.controller?.getPaymentAmmountFor(goal: self.item!)
            
            fiel.text = payment?.description
            
        }
        
        
        
        alertview.addAction(UIAlertAction(title: "Cancelar", style: .destructive, handler: { (UIAlertAction) in
            alertview.dismiss(animated: true, completion: nil)
        }))
        
        alertview.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
            alertview.dismiss(animated: true, completion: nil)
            
            let textf:UITextField = alertview.textFields![0]
            
            
            if let text = textf.text{
                
                if let val = Double(text){
                    
                    self.controller?.addOperationForGoal(goal:self.item!,  ammount: val);
                    
                    self.tableView.beginUpdates()
                    self.tableView.insertRows(at: [IndexPath(row: self.item!.operations!.count - 1, section: 1)], with: .automatic)
                    self.tableView.endUpdates()
                    self.tableView.reloadData()
                    
                }
            }
            
            
        }))
        
        
        
        self.present(alertview, animated: true, completion: nil)
        
        
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 5
        }else{
            return item?.operations?.count ?? 0
        }
    }

    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell
            
            
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                
                cell = tableView.dequeueReusableCell(withIdentifier: cells.HEADER, for: indexPath)
                
                
                cell.textLabel?.text = moneyformater.string(from: NSNumber(value: item!.balance))
                break
            case 1:
                cell = tableView.dequeueReusableCell(withIdentifier: cells.VALUE, for: indexPath)
                cell.textLabel?.text = "Total"
                cell.detailTextLabel?.text = moneyformater.string(from: NSNumber(value: item!.targetAmmount))
                
                break
            case 2:
                cell = tableView.dequeueReusableCell(withIdentifier: cells.VALUE, for: indexPath)
                cell.textLabel?.text = "Vence"
                dateformater.dateFormat = "dd MMM yyyy"
                if let d = item!.dueDate as Date?{
                    cell.detailTextLabel?.text = dateformater.string(from: d)
                }
                break
            case 3:
                cell = tableView.dequeueReusableCell(withIdentifier: cells.VALUE, for: indexPath)
                cell.textLabel?.text = "Faltan"
                
                
                cell.detailTextLabel?.text = "\(controller!.getPeriodsForGoal( duedate: item!.dueDate! as Date, paymentsPerMont: Int(item!.period))) \(controller!.getPaymentName(type: Int(item!.period)))"
                
                break
            default:
                cell = tableView.dequeueReusableCell(withIdentifier: cells.PAYMENT, for: indexPath)
                
                cell.textLabel?.text = " \(controller!.getRestingNumPayments(item: self.item!)) / \(item!.numPays)"
                
                break
            }
            
            return cell
        }else{
            
            if let ops = item?.operations{
                
                
                
            
                if let op = ops[indexPath.row] as? MOGoalOperation {
                    
                    cell = tableView.dequeueReusableCell(withIdentifier: cells.OP_MOV, for: indexPath)
                    
                    if let dateLabel = cell.viewWithTag(1) as? UILabel{
                        
                        dateformater.dateFormat = "dd MMM yyyy HH:mm"
                        dateLabel.text = dateformater.string(from: op.date! as Date)
                    }
                    
                    if let numPayLabel = cell.viewWithTag(2) as? UILabel{
                        numPayLabel.text = "Pago " + (indexPath.row + 1).description

                    }
                    
                    if let ammountLabel = cell.viewWithTag(3) as? UILabel{
                        ammountLabel.text = moneyformater.string(from: NSNumber(value:op.ammount)) 
                    }
                    
                    
                    
                    return cell

                    
                }
            }
            
            cell = tableView.dequeueReusableCell(withIdentifier: cells.OP_CALC, for: indexPath)
            
            
            return cell
        }

        
    }
    

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 && (indexPath.row > 0 && indexPath.row < 4) {
            return 32
        }else{
            return 74
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 0
        }else{
            return 30
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 1{
            let title = UILabel()
            
            title.text = "  Operaciones"
            
            return title
        }
        
        return nil
        
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
   

    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return indexPath.section == 1 ? true:false;
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            if let ops = item?.operations{
                if let op = ops[indexPath.row] as? MOGoalOperation {
                    
                    controller?.removeOperationForGoal(goal:item!, operation:op)

                    
                    self.tableView.beginUpdates()
                    self.tableView.deleteRows(at: [indexPath], with: .fade)
                    self.tableView.endUpdates()
                    
                    self.tableView.reloadData()

                }
            }
        }
    }
    

}
