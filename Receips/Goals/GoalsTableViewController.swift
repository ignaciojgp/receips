//
//  GoalsTableViewController.swift
//  Receips
//
//  Created by Ignacio J Gonzalez Pérez on 26/07/17.
//  Copyright © 2017 Ignacio Jacob. All rights reserved.
//

import UIKit

class GoalsTableViewController: UITableViewController {

    let controller:GoalsController = GoalsController()
    
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return controller.getGoalsList().count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let title = cell.viewWithTag(3) as? UILabel
        let number = cell.viewWithTag(1) as? UILabel
        let ammount = cell.viewWithTag(2) as? UILabel
        
        if let goal:MOGoal = controller.getGoalsList()[indexPath.row] as? MOGoal{
            
            title?.text = goal.name
            number?.text = "\(goal.operations?.count ?? 0)/\(goal.numPays) | \(controller.getPaymentName(type: Int(goal.period)))"
            
            let numformat = NumberFormatter()
            numformat.numberStyle = .currency
            
            ammount?.text = numformat.string(from: NSNumber(value: goal.targetAmmount))
            
            
        }
        

        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            if let goal:MOGoal = controller.getGoalsList()[indexPath.row] as? MOGoal{
                
                controller.deleteGoal(goal: goal)
                self.tableView.beginUpdates()
                self.tableView.deleteRows(at: [indexPath], with: .fade)
                self.tableView.endUpdates()

                
            }
        }
    }
    

    
    //MARK:- NAVIGATION
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vcontroller = segue.destination as? NewGoalViewController{
            vcontroller.controller = self.controller
        }
        if let vcontroller = segue.destination as? GoalDetailTableViewController{
            
            
            let cell = (sender as! UITableViewCell)
            
            if let index = tableView.indexPath(for: cell){
            
                if let item = controller.getGoalsList()[index.row] as? MOGoal{
                    vcontroller.item = item
                }
            
            }
            vcontroller.controller = self.controller
        }
        
        
        
    }
    
    
    

}
