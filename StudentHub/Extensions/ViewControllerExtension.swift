//
//  ViewControllerExtension.swift
//  StudentHub
//
//  Created by Fabio Quintanilha on 9/8/19.
//  Copyright © 2019 StudentHub. All rights reserved.
//

import Foundation
import UIKit
import SCLAlertView

extension UIViewController {
    
    func addSideMenuButton(menuButton: UIButton){
        if revealViewController() != nil {
            let target = self.revealViewController()
            let action = #selector(SWRevealViewController.revealToggle(_:))
            
            menuButton.addTarget(target, action: action, for: .touchUpInside)
            
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
            
            revealViewController().rearViewRevealWidth = self.view.frame.size.width - 120
        }
    }
    
    func addSideRightMenuButton(menuButton: UIButton){
        if revealViewController() != nil {
            let target = self.revealViewController()
            let action = #selector(SWRevealViewController.rightRevealToggle(_:))
            
            menuButton.addTarget(target, action: action, for: .touchUpInside)
            
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
            
            revealViewController()?.rightViewRevealWidth = self.view.frame.size.width - (self.view.frame.size.width / 2)
        }
    }
    
    
    func errorAlert(title: String, message: String) {
        let appearance = SCLAlertView.SCLAppearance( showCloseButton: false)
        let alertView = SCLAlertView(appearance: appearance)
        
        alertView.addButton("OK") {
            alertView.dismiss(animated: true, completion: nil)
        }
        
        alertView.showError(title, subTitle: message)
    }
    
    
    func waitView(message: String?, completion: @escaping (SCLAlertView) -> ()) {
        let appearance = SCLAlertView.SCLAppearance( showCloseButton: false)
        let alertView = SCLAlertView(appearance: appearance)
        alertView.showWait("Please Wait", subTitle: message ?? "")
        completion(alertView)
    }
    
}
