//
//  ViewControllerExtension.swift
//  StudentHub
//
//  Created by Fabio Quintanilha on 9/8/19.
//  Copyright © 2019 StudentHub. All rights reserved.
//

import Foundation
import UIKit

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
}
