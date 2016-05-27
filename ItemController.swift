//
//  ItemController.swift
//  ShoppingList
//
//  Created by Patrick Pahl on 5/27/16.
//  Copyright © 2016 DevMountain. All rights reserved.
//

import UIKit
import CoreData


class ItemController{
    
    static let sharedInstance = ItemController()
    
    var fetchedResultsController = NSFetchedResultsController()
    
    init(){
        let request = NSFetchRequest(entityName: "Item")
        let sortDescriptor = NSSortDescriptor(key: "isComplete", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: Stack.sharedStack.managedObjectContext, sectionNameKeyPath: "Item", cacheName: nil)
        
        _ = try? fetchedResultsController.performFetch()
    }
    
    //CRUD Methods
    
    func addItem(name: String){
        _ = Item(name: name)
        saveToPersistentStorage()
    }
    
    
    func removeItem(item: Item){
       let moc = Stack.sharedStack.managedObjectContext
        moc.deleteObject(item)
        saveToPersistentStorage()
    }
    
    
    
//    func updateItem(){                                //Not needed, labels on MSB, no detail view
//        Item.name = name
//        item.isComplete = isComplete
//        saveToPersistentStorage()
//    }
    
    
    func saveToPersistentStorage(){
        let moc = Stack.sharedStack.managedObjectContext
        do {
            try moc.save()
        } catch {
        print("error")
    }
}
}
