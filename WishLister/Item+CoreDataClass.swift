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
    
    //Anytime this managedObject is inserted into the moc, this function will be called
    public override func awakeFromInsert() {
        
        // All we're doing here is when the managedObject is inserted into the moc, go ahead and assign the current date to the attribute created
        super.awakeFromInsert()
        self.created = NSDate()
    }

}


func generateItemData() {
    
    //We created an item of entity Item inside of the NSManagedObjectContext
    let item = Item(context: context)
    item.title = "MacBook Pro"
    item.price = 1800.00
    item.details = "I can't wait until the September event, I hope they release new MPBs"
    
    let item2 = Item(context: context)
    item2.title = "Bose Heaphones"
    item2.price = 300.00
    item2.details = "Noise cancelling technology"
    
    let item3 = Item(context: context)
    item3.title = "Tesla Model S"
    item3.price = 110000.00
    item3.details = "Dream car"
    
    //Now our data is residing in the moc, it's residing in memory.
    // The saveContext saves our test data into the CoreData database
    appDelegate.saveContext()
}
