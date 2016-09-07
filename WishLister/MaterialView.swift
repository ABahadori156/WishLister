//
//  MaterialView.swift
//  WishLister
//
//  Created by Pasha Bahadori on 9/6/16.
//  Copyright © 2016 Pelican. All rights reserved.
//

import UIKit

//Extension means makes it anything that inherits from UIView will also have the ability to add the styling we're about to make right now

//By default this won't be selecting the materialDesign
private var materialKey = false
extension UIView {

    // IBInspectable is a toggling or option that we can select inside storyboard
    @IBInspectable var materialDesign: Bool {
        get {
            return materialKey
        } set {
            
            // We're going to set whateer the user sets for the new value - When the user goes in and adds a new view that has this as an extension, they can select whether they want the material select added to that view
            materialKey = newValue
            
            // If they select the material view, we're going to add some shadows
            if materialKey == true {
                self.layer.masksToBounds = false
                self.layer.cornerRadius = 3.0
                self.layer.shadowOpacity = 8.0
                self.layer.shadowRadius = 3.0
                self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
                self.layer.shadowColor = UIColor(red: 157/255, green: 157/255, blue: 157/255, alpha: 1.0).cgColor
            } else {
                self.layer.cornerRadius = 0
                self.layer.shadowOpacity = 0
                self.layer.shadowRadius = 0
                self.layer.shadowColor = nil
            }
        }
    }

}
