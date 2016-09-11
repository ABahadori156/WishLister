//
//  ItemCell.swift
//  WishLister
//
//  Created by Pasha Bahadori on 9/6/16.
//  Copyright © 2016 Pelican. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {
    @IBOutlet weak var thumb: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var details: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var type: UILabel!
    
    func configureCell(item: Item) {
        
        
        title.text = item.title
        price.text = "$\(item.price)"
        details.text = item.details
        thumb.image = item.toImage?.image as? UIImage
        type.text = item.toItemType?.type
        
    }
    
    func configureItemType(itemType: ItemType) {
        type.text = itemType.type
    }
    
    
    
}
