//
//  ItemDetailsVC.swift
//  WishLister
//
//  Created by Pasha Bahadori on 9/7/16.
//  Copyright © 2016 Pelican. All rights reserved.
//

import UIKit
import CoreData

class ItemDetailsVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var storePicker: UIPickerView!
    @IBOutlet weak var titleField: CustomTextField!
    @IBOutlet weak var priceField: CustomTextField!
    @IBOutlet weak var detailsField: CustomTextField!
    
    @IBOutlet weak var thumbImg: UIImageView!
    var stores = [Store]()
    
    //We create a variable to hold the item we want to update from the 1st VC
    var itemToEdit: Item?
    
    var imagePicker: UIImagePickerController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        storePicker.delegate = self
        storePicker.dataSource = self
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        //This code changes the the back button for the navigation controller on the 2nd VC to be just < without the text of the title of the 1st VC
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        }
        
        // generateStoreData()
        getStores()
        
        //If the item we want to update isn't nil, then we load that item's data
        if itemToEdit != nil {
            
            loadItemData()
            print("**************HELLO****************")
        }
    }

    func getStores() {
        
        let fetchRequest: NSFetchRequest<Store> = Store.fetchRequest()
        
        do {
            
            //Here we're saying set the stores array equal to the results that we get back from the fetchRequest
            self.stores = try context.fetch(fetchRequest)
            
            //The reload is like reloading all the components
            self.storePicker.reloadAllComponents()
            
        } catch {
            let error = error as NSError
            print("\(error)")
        }
        
    }
  
    @IBAction func savePressed(_ sender: AnyObject) {
        
        var item: Item!
        
        // Now we create the image entity since in our ManagedObjectModel we created it as an NSManagedObject
        //We insert a new image entity into the moc
        let picture = Image(context: context)
        
        //Now we assign the image attribute to the image we selected from our camera roll
        picture.image = thumbImg.image
        
        if itemToEdit == nil {
            item = Item(context: context)
        } else {
            //If we did pass an Item over, then item is equal to itemToEdit - CoreData behind the scenes handles the rest
            item = itemToEdit
        }
        
        //Associate that image to our Item - were assigning an entity to an entity
        item.toImage = picture
        
        // Now we assign the content inside each of the textfields to the attribute for the item
        if let title = titleField.text {
            item.title = title
        }
        
        if let price = priceField.text {
            item.price = (price as NSString).doubleValue
            //the price attribute is a double so we have to do some conversion
            //We're going to take the string and turn it into an NSString then we convert that to a double
        }
        
        if let details = detailsField.text {
            item.details = details
        }
        
        //Here we want to assign the store that we have selected (It grabs the relationship we defined)
        // title price and details are attributes of the item we created. what we're doing with store is it's already an entity itself
        //We're assigning the store via relationship to this specific item
        // We are selecting the store inside of the storesArray that corresponds to the storePicker which is selected in the column and since we only have 1 column, we put 0
        item.toStore = stores[storePicker.selectedRow(inComponent: 0)]
        
        appDelegate.saveContext()
        
        // This is the new syntax so when we tap the save button, it dismisses the itemDetails VC and goes back to our mainVC
        _ = navigationController?.popViewController(animated: true)
    }
    
    //Method to load previous entry from 1st vc to itemDetails vc
    func loadItemData() {
        
        if let item = itemToEdit {
            titleField.text = item.title
            priceField.text = "\(item.price)"
            detailsField.text = item.details
            thumbImg.image = item.toImage?.image as? UIImage
            
            //Set the picker to the correct store which is tricky because all we have coming back from the 1st VC is the Item with the store as a string with a name and here we have it stored in the array
            //So we have to loop through the array to match the string with the string of the store we chose for that item and assign that to the picker
            //First we check if there is a store
            if let store = item.toStore {
                var index = 0
                repeat {
                    let s = stores[index]
                    if s.name == store.name {
                        
                        //The row that it is going to select is the index because we're checking to see if the names compare and if they do match then we're going to set the row to that index
                        storePicker.selectRow(index, inComponent: 0, animated: false)
                        break
                    }
                    index += 1
                    
                } while (index < stores.count)
            }
        }
    }
    
    //HOW TO DELETE AN ITEM IN COREDATA
    @IBAction func deletePressed(_ sender: UIBarButtonItem) {
        // We only want to delete if we have passed oneof our existing objects over
        if itemToEdit != nil {
            context.delete(itemToEdit!)
            appDelegate.saveContext()
        }
        _ = navigationController?.popViewController(animated: true)
        
    }
    
    // HOW TO ADD IMAGE - When we click on our image button, have it present the images view controller so we can use our camera roll to select images
    @IBAction func addImage(_ sender: UIButton) {
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    // This is the new imagePicker in Swift 3.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let img = info[UIImagePickerControllerOriginalImage] as? UIImage {
            thumbImg.image = img
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    
    /* ************************************    PICKERVIEW METHODS   ************************************ */
    // 3 Required Delegate Methods for UIPickerView: How many rows are there, how many sections, what to do when one of the rows are selected, the one that sets the titles for the rows
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        // We're going to select the store out of the array of stores at that row, then we're going to return the name of that store
        let store = stores[row]
        
        // store is the managedObject we created in the beginning
        return store.name
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return stores.count
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // Update when selected
    }
   

    // We want to create some stores and set the names and save it to coredata then fetch it back and assign the fetched results to our empty stores array and those will be used in the titleForRow
}
