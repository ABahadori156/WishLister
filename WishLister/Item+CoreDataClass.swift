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
