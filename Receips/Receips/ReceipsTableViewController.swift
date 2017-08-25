//
//  ReceipsTableViewController.swift
//  Receips
//
//  Created by Ignacio Jacob on 14/08/17.
//  Copyright © 2017 Ignacio Jacob. All rights reserved.
//

import UIKit

class ReceipsTableViewController: UITableViewController {

    static let identifier = "cell"

    let controller = ReceipController()
    let moneyFormater = NumberFormatter()
    let dateFormater = DateFormatter()
    
    var list:[Any]! = []
    
    // MARK:
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        moneyFormater.numberStyle = .currency
        dateFormater.dateStyle = .short
        dateFormater.timeStyle = .short
    }
    
    override func viewWillAppear(_ animated: Bool) {
        load()
    }

    // MARK: - private methods
    
    func load(){
        list = controller.getReceipsList()
        tableView.reloadData()
    }

    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ReceipsTableViewController.identifier)
        
        if let item = list[indexPath.row] as? MOReceip{
            
            
            let textLabel = cell?.viewWithTag(1) as? UILabel
            let detailTextLabel = cell?.viewWithTag(2) as? UILabel
            let ammountLabel = cell?.viewWithTag(3) as? UILabel
            let imageView = cell?.viewWithTag(4) as? UIImageView
            
            
            textLabel?.text = item.concept
            ammountLabel?.text = moneyFormater.string(from: NSNumber(value: item.ammount))
            if item.date != nil {
                detailTextLabel?.text = dateFormater.string(from: item.date! as Date)
            }
            
            
            if let typename = controller.imageNameForType(type: Int(item.kind)){
                if let image = UIImage(named: typename){
                    imageView?.image = image
                }
            }
            
        }
        
    
        
        return cell!
        
    }

    

}
