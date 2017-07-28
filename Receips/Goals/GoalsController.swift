//
//  GoalsController.swift
//  Receips
//
//  Created by Ignacio J Gonzalez Pérez on 26/07/17.
//  Copyright © 2017 Ignacio Jacob. All rights reserved.
//

import UIKit
import CoreData

class GoalsController: NSObject {
    
    private static let Goal = "Goal";
    
    func getGoalsList()->[Any]{
        
        let list:[Any]
        
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let context:NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: GoalsController.Goal)
        
        
        do {
            list = try context.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            list = []
        }
        
        return list
    }
    
    func addGoal(balance:Double, dueDate:Date, name:String, notify:Bool, period:Int16, targetAmmount:Double){
        
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let context:NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        
        if let entity = NSEntityDescription.entity(forEntityName: GoalsController.Goal, in: context){
        
            let goal = NSManagedObject(entity: entity, insertInto: context)
            goal.setValue(balance, forKey: "balance")
            goal.setValue(dueDate, forKey: "dueDate")
            goal.setValue(name, forKey: "name")
            goal.setValue(notify, forKey: "notify")
            goal.setValue(period, forKey: "period")
            goal.setValue(targetAmmount, forKey: "targetAmmount")
            
        }
        
        do{
            try context.save()
        }catch let error as NSError{
            print(error.localizedDescription)
        }
        
    }
    
    func getPeriodsForGoal(ammound:Double, duedate:Date, paymentsPerMont:Int )->Int{
        
        let now = Date()
        
        
        let calendar = Calendar(identifier: .gregorian)
        
        let unit:Int?
        
        switch paymentsPerMont {
        case 4:
            let components = calendar.dateComponents([.day, .weekOfMonth], from: now, to: duedate)
            unit = components.weekOfMonth
            
            break
        case 2:
            let components = calendar.dateComponents([.day, .month], from: now, to: duedate)
            unit = components.month! * 2
            
            break
        default:
            let components = calendar.dateComponents([.day, .month], from: now, to: duedate)
            unit = components.month
            break
        }
        
        return unit!
    }
    
    func getPaymentAmmount(total:Double, periods:Int)->Double{
        return total / Double(periods)
    }
    
    
    
}
