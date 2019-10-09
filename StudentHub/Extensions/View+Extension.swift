//
//  View+Extension.swift
//  StudentHub
//
//  Created by Fabio Quintanilha on 9/26/19.
//  Copyright © 2019 StudentHub. All rights reserved.
//

import UIKit

extension UIView {
    
    func circle() {
        layer.cornerRadius = self.frame.width / 2
    }
    
    func roundCorner(radius: Float){
        layer.cornerRadius = CGFloat(radius)
    }
    
    func setShadow(color: UIColor, opacity: Float, shadowRadius: Float, shadowOffset_x: Double, shadowOffset_y: Double) {
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = CGSize(width: shadowOffset_x, height: shadowOffset_y)
        layer.shadowRadius = CGFloat(shadowRadius)
    }
    
    func setBorder(width: Float, color: UIColor) {
        layer.borderColor = color.cgColor
        layer.borderWidth = CGFloat(width)
    }
}
