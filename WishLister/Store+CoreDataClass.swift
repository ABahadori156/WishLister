//
//  Store+CoreDataClass.swift
//  WishLister
//
//  Created by Pasha Bahadori on 9/6/16.
//  Copyright © 2016 Pelican. All rights reserved.
//

import Foundation
import CoreData


public class Store: NSManagedObject {

}


// TEST DATA FOR STORES
func generateStoreData() {
// This is how we initialize an managedObject from CoreData
        let store1 = Store(context: context)
        store1.name = "Best Buy"

        let store2 = Store(context: context)
        store2.name = "Amazon"

        let store3 = Store(context: context)
        store3.name = "Tesla Dealership"

        let store4 = Store(context: context)
        store4.name = "Target"

        let store5 = Store(context: context)
        store5.name = "Fry's Electronics"

        let store6 = Store(context: context)
        store6.name = "K Mart"

      appDelegate.saveContext()
}
