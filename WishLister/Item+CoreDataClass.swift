//
//  Item+CoreDataClass.swift
//  WishLister
//
//  Created by Pasha Bahadori on 9/6/16.
//  Copyright © 2016 Pelican. All rights reserved.
//

import Foundation
import CoreData


public class Item: NSManagedObject {
    
    
    public override func awakeFromInsert() {
        
        
        super.awakeFromInsert()
        self.created = NSDate()
    }

}


func generateItemData() {
    
    
    let item = Item(context: context)
    let itemType = ItemType(context: context)
    
  
    
    item.title = "MacBook Pro"
    item.price = 1800.00
    item.details = "I can't wait until the September event, I hope they release new MPBs"
    itemType.type = "Electronics"
    
    let item2 = Item(context: context)
    let itemType2 = ItemType(context: context)
    item2.title = "Bose Heaphones"
    item2.price = 300.00
    item2.details = "Noise cancelling technology"
    itemType2.type = "Electronics"
    
    let item3 = Item(context: context)
    let itemType3 = ItemType(context: context)
    item3.title = "Tesla Model S"
    item3.price = 110000.00
    item3.details = "Dream car"
    itemType3.type = "Car"
    

    appDelegate.saveContext()
}
