//
//  AppConfig.swift
//  StudentHub
//
//  Created by Fabio Quintanilha on 10/1/19.
//  Copyright © 2019 StudentHub. All rights reserved.
//

import Foundation
import SCLAlertView

class AppConfig {
    
    func ErrorAlert(title: String, message: String) {
        let appearance = SCLAlertView.SCLAppearance( showCloseButton: false)
        let alertView = SCLAlertView(appearance: appearance)
        
        alertView.addButton("OK") {
            alertView.dismiss(animated: true, completion: nil)
        }
        
        alertView.showError(title, subTitle: message)
    }
    
}
