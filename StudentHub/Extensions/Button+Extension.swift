//
//  Button+Extension.swift
//  StudentHub
//
//  Created by Fabio Quintanilha on 9/29/19.
//  Copyright © 2019 StudentHub. All rights reserved.
//

import UIKit

extension UIButton {
    func round(radius: Float){
        layer.cornerRadius = CGFloat(radius)
    }
    
    func border(width: Float, color: UIColor) {
        layer.borderWidth = CGFloat(width)
        layer.borderColor = color.cgColor
    }
    
}
