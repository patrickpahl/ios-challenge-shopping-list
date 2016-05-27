//
//  Item.swift
//  ShoppingList
//
//  Created by Patrick Pahl on 5/27/16.
//  Copyright © 2016 DevMountain. All rights reserved.
//

import Foundation
import CoreData


class Item: NSManagedObject {

    convenience init?(name: String, isComplete: Bool = false, context: NSManagedObjectContext = Stack.sharedStack.managedObjectContext){
        
        guard let entity = NSEntityDescription.entityForName("Item", inManagedObjectContext: context) else {return nil}
        
        self.init(entity: entity, insertIntoManagedObjectContext: context)
            
            self.name = name
            self.isComplete = isComplete
        }

}

