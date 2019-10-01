//
//  DateExtension.swift
//  StudentHub
//
//  Created by Fabio Quintanilha on 9/9/19.
//  Copyright © 2019 StudentHub. All rights reserved.
//

import Foundation

extension Date {
    
    //Creates a date from a string
    static func dateFromCustomString(customString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter.date(from: customString) ?? Date()
    }
    
}
