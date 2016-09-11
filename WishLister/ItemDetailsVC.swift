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
    @IBOutlet weak var itemTypeField: CustomTextField!
    
    @IBOutlet weak var thumbImg: UIImageView!
    var stores = [Store]()
    
    
    var itemToEdit: Item?
    
    var imagePicker: UIImagePickerController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        storePicker.delegate = self
        storePicker.dataSource = self
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
      
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        }
        
        generateStoreData()
        getStores()
        

        if itemToEdit != nil {
            
            loadItemData()
            print("**************HELLO****************")
        }
    }

    func getStores() {
        
        let fetchRequest: NSFetchRequest<Store> = Store.fetchRequest()
        
        do {

            self.stores = try context.fetch(fetchRequest)

            self.storePicker.reloadAllComponents()
            
        } catch {
            let error = error as NSError
            print("\(error)")
        }
        
    }
  
    @IBAction func savePressed(_ sender: AnyObject) {
        
        var item: Item!

        let picture = Image(context: context)
        let itemType = ItemType(context: context)
        
        itemType.type = itemTypeField.text

        picture.image = thumbImg.image
        
        if itemToEdit == nil {
            item = Item(context: context)
        } else {

            item = itemToEdit
        }

        item.toImage = picture
        
        item.toItemType = itemType
        
        if let title = titleField.text {
            item.title = title
        }
        
        if let price = priceField.text {
            item.price = (price as NSString).doubleValue

        }
        
        if let details = detailsField.text {
            item.details = details
        }

        item.toStore = stores[storePicker.selectedRow(inComponent: 0)]
        
        appDelegate.saveContext()

        _ = navigationController?.popViewController(animated: true)
    }

    func loadItemData() {
        
        if let item = itemToEdit {
            titleField.text = item.title
            priceField.text = "\(item.price)"
            detailsField.text = item.details
            itemTypeField.text = item.toItemType?.type
            thumbImg.image = item.toImage?.image as? UIImage

            if let store = item.toStore {
                var index = 0
                repeat {
                    let s = stores[index]
                    if s.name == store.name {

                        storePicker.selectRow(index, inComponent: 0, animated: false)
                        break
                    }
                    index += 1
                    
                } while (index < stores.count)
            }
        }
    }
    
    //DELETE AN ITEM IN COREDATA
    @IBAction func deletePressed(_ sender: UIBarButtonItem) {
 
        if itemToEdit != nil {
            context.delete(itemToEdit!)
            appDelegate.saveContext()
        }
        _ = navigationController?.popViewController(animated: true)
        
    }
    

    @IBAction func addImage(_ sender: UIButton) {
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let img = info[UIImagePickerControllerOriginalImage] as? UIImage {
            thumbImg.image = img
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    
    /* ************************************    PICKERVIEW METHODS   ************************************ */
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

        let store = stores[row]

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

}
