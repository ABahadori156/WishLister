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
    
    func configureCell(item: Item) {
        //What are we updating? So from our list of items, we have our list of items, an image, a title, a price, and some details
        
        title.text = item.title
        price.text = "$\(item.price)"
        details.text = item.details
    }
    
    
}
