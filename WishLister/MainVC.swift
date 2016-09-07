//
//  MainVC.swift
//  WishLister
//
//  Created by Pasha Bahadori on 9/6/16.
//  Copyright © 2016 Pelican. All rights reserved.
//

import UIKit
import CoreData


//Add the NSFetchedResultsControllerDelegate
class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segment: UISegmentedControl!
    
    //In the <> we tell the fetchedResultsController we want to retrieve the Item
    var controller: NSFetchedResultsController<Item>!
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }
    
    
    // Once we have data in our database, we need a way to fetch and display it
    func attemptFetch() {
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        
        //How to sort the data it's fetching so we'll create variable that will tell the database how to sort the retrieved data
        // We're going to sort the data by 'newest according to time stamp", "price", and "title"
        let dateSort = NSSortDescriptor(key: "created", ascending: false)
        
        //Here call the fetchRequest with the sort descriptors and we put in the dateSort descriptor to request our object's based on created property
        fetchRequest.sortDescriptors = [dateSort]
        
        //Here we instantiate our FetchResultsController (We use the shortcuts we created at the bottom of AppDelegate for the moc - We pass in nil for sectionNameKeyPath because we want all the results - cacheName we don't need so we put in nil
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        //Now we set our controller we created in this function to the fetchedResultsController up at the top of the page
        
        //A fetch request can fail so do set it up in a do-catch statement
        do {
            try controller.performFetch()
        } catch {
            let error = error as NSError
            print("\(error)")
        }
    }
    
    // Whenever the tableView is about to update, this will start to listen for changes and will handle the changes for you
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        //We use beginUpdates method if we want to insert, delete, or select rows or sections on a table view
        // WORKS WELL WITH CORE DATA
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        //Once the content has been changed, end the updates
        tableView.endUpdates()
    }
    
    // This function will be listening when we're going to be making a change - whether it's insertion, a deletion, move, and update
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch(type) {
            
        //There is where we create a new item. Example, we see our dream car and then we add it
        case.insert:
            // This takes a new index path and assigns it to the regular indexPath - insert the new item at this row at index path with fade animation
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        case.delete:
            // We're using the existing indexPath since we are deleting here
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
            
        //This is where you click on an existing item and want to update it
        case.update:
            if let indexPath = indexPath {
                let cell = tableView.cellForRow(at: indexPath) as! ItemCell
                // Update the cell data
            }
            break
            
        // This is like where you have touch moving implemented and you want to move your items around - so we're deleting it at the current place and dragging it around to insert at the new spot the user chose
        case.move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
            
            
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    

}











