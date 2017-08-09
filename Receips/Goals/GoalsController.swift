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
    private static let GoalOperation = "GoalOperation";
    
    func getGoalsList()->[Any]{
        
        let list:[Any]
        
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let context:NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        
        
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: GoalsController.Goal)
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        do {
            list = try context.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            list = []
        }
        
        return list
    }
    
    func addGoal(balance:Double, dueDate:Date, name:String, notify:Bool, period:Int16, targetAmmount:Double, numPays:Int){
        
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
            goal.setValue(numPays, forKey: "numPays")
            
        }
        
        do{
            try context.save()
        }catch let error as NSError{
            print(error.localizedDescription)
        }
        
    }
    
    func getPeriodsForGoal(duedate:Date, paymentsPerMont:Int )->Int{
        
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
    
    func getGoalWithId(id:NSManagedObjectID)->MOGoal?{
        
        
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let context:NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        
        
        
        if let item = context.object(with: id) as? MOGoal{
            return item
        }
            
        
        return nil
    }
    
    
    func addOperationForGoal(goal:MOGoal, ammount:Double){
        
        
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let context:NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        
        if let entity = NSEntityDescription.entity(forEntityName: GoalsController.GoalOperation, in: context){
            
            let goalOperation = NSManagedObject(entity: entity, insertInto: context)
            
            goal.setValue(goal.balance + ammount, forKey: "balance")
            
            
            goalOperation.setValue(goal.balance, forKey: "balance")
            goalOperation.setValue(1, forKey: "type")
            goalOperation.setValue(ammount, forKey: "ammount")
            goalOperation.setValue(Date(), forKey: "date")
            goalOperation.setValue(goal, forKey: "goal")

            let set = NSMutableSet(set: goal.operations!.set)
           
            set.add(goalOperation)
            
            
            
        }
        
        do{
            try context.save()
        }catch let error as NSError{
            print(error.localizedDescription)
        }

    }
    
    func removeOperationForGoal(goal:MOGoal, operation:MOGoalOperation){
        
        
        var set = goal.operations!.set
        
        set.remove(operation)
        
        goal.operations = NSOrderedSet(set: set)
        
        goal.setValue(goal.balance - operation.ammount, forKey: "balance")

        
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let context:NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        
        
        
        context.delete(operation)
        
    }

    
    func getRestingNumPayments(item:MOGoal)->Int{

        let numPayments = Int(item.numPays) - self.getNumPaymentsDone(item: item)
        
        return numPayments
    }
    
    func getNumPaymentsDone(item:MOGoal)->Int{
        

        if let ops = item.operations{
            return ops.count
        }else{
            return 0;
        }
    }
    
    func getPaymentAmmountFor(goal:MOGoal)->Double{
        
        let numperiods = self.getRestingNumPayments(item: goal)
        
        
        
        return ceil( (goal.targetAmmount - goal.balance) / Double(numperiods))
    }

    func getPaymentName(type:Int)->String{
        switch type {
        case 1:
            return "Meses"
        case 2:
            return "Quincenas"
        default:
            return "Semanas"
        }
    }
    
   
    
}
