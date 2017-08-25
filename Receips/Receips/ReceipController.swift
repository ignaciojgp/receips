//
//  ReceipController.swift
//  Receips
//
//  Created by Ignacio Jacob on 10/08/17.
//  Copyright © 2017 Ignacio Jacob. All rights reserved.
//

import UIKit
import CoreData

class ReceipController: NSObject {
    
    static let Receip = "Receip"
    
    func addRepecip(concept:String, ammount:Double, date:Date, photo:Data?, kind:Int, isIncome:Bool){
        
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let context:NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        
        if let entity = NSEntityDescription.entity(forEntityName: ReceipController.Receip, in: context){
            
            let goal = NSManagedObject(entity: entity, insertInto: context)
            
            goal.setValue(concept, forKey: "concept")
            goal.setValue(ammount, forKey: "ammount")
            goal.setValue(date, forKey: "date")
            goal.setValue(photo, forKey: "photo")
            goal.setValue(kind, forKey: "kind")
            goal.setValue(isIncome, forKey: "isIncome")
            
        }
        
        do{
            try context.save()
        }catch let error as NSError{
            print(error.localizedDescription)
        }
        

    }
    
    func getReceipsList()->[Any]{
        
        let list:[Any]
        
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let context:NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        
        
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: ReceipController.Receip)
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        do {
            list = try context.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            list = []
        }
        
        return list
    }
    
    func deleteReceip(receip:MOReceip){
        
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let context:NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        
        context.delete(receip)
    }
    
    func imageNameForType(type:Int)->String?{
        
        if let bundle = Bundle.main.object(forInfoDictionaryKey: "imageForType") as? Array<String>{
            if bundle.count > type{
                return bundle[type]
            }
        }
        
        return nil
        
    }
}
