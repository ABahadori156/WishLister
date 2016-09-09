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
        
        // If we leave generateTestData() uncommented, it'll keep adding the 3 test items over and over to our database
        // generateItemData()
        attemptFetch()
        
        
    }

    // When we are calling cellForRowAt, we're creating a cell, passing that into our configureCell method,
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // We'll be calling the configuredCell from two locations 
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemReuse", for: indexPath) as! ItemCell
        configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
        return cell
    }
    
    
    func configureCell(cell: ItemCell, indexPath: NSIndexPath) {
        
        let item = controller.object(at: indexPath as IndexPath)
        // The second configureCell method came from the ItemCell class method
        cell.configureCell(item: item)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Here we're grabbing the sections out of the controller. We take the info from the sections and put it in your number of rows
        if let sections = controller.sections {
            
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
            
        }
        
        return 0
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = controller.sections {
            return sections.count
        }
        return 0
    }
    
    //This method make sure our cells have a height of 150
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
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
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: appDelegate.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        //Without this, we didn't tell the NSFetchedResultsController methods what to listen to and so they weren't listening. 
        controller.delegate = self
        
        //Now we set our controller we created in this function to the fetchedResultsController up at the top of the page
        self.controller = controller
        
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
                
                //When we update a cell, when it comes back it will go through that configureCell method and update the results for us
                configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
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
    
    // the , after .fetchedObjects refers to the where syntax but in Swift 3 it's now a comma
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //If the objects in the controller's fetchedObject are MORE THAN 0, then ..
        if let objects = controller.fetchedObjects , objects.count > 0 {
            
            //PerformSegue by transferring the item's details that is currently selected
            let item = objects[indexPath.row]
            performSegue(withIdentifier: "ItemDetailsVC", sender: item)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ItemDetailsVC" {
            if let destination = segue.destination as? ItemDetailsVC {
            if let item = sender as? Item {
                destination.itemToEdit = item
            }
        }
    }
}
    
    
    
    

}











