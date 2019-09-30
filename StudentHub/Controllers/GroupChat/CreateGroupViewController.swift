//
//  CreateGroupViewController.swift
//  StudentHub
//
//  Created by Fabio Quintanilha on 9/30/19.
//  Copyright © 2019 StudentHub. All rights reserved.
//

import UIKit

class CreateGroupViewController: UIViewController {
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var groupView: UIView!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var switchPrivate: UISwitch!
    @IBOutlet weak var groupNameTextField: UITextField!
    @IBOutlet weak var groupDescriptionTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.popupView.roundCorner(radius: 20)
        self.groupView.roundCorner(radius: 16)
        createButton.roundCorner(radius: 6)
        cancelButton.border(width: 3, color: #colorLiteral(red: 0.01250977442, green: 0.4810960293, blue: 0.8075000644, alpha: 1))
        cancelButton.roundCorner(radius: 6)
        switchPrivate.isOn = false
    }
    
    
    func createGroup() {
        let groupName = self.groupNameTextField.text ?? ""
        let groupDescription = self.groupDescriptionTextView.text ?? ""
        let isPrivate = switchPrivate.isOn
        
        
        if !groupName.isEmpty && !groupDescription.isEmpty {
            let newGroup = GroupChat(group_name: groupName, adminEmail: CurrentUser.email, createdByID: CurrentUser.id, createdByName: CurrentUser.fullName, isPrivate: isPrivate, description: groupDescription, groupImage: #imageLiteral(resourceName: "studend_hub_logo"))
            
            //TODO: Save to database
            
            
            self.dismiss(animated: true, completion: nil)
        }
    }

    @IBAction func createdButtonTapped(_ sender: UIButton) {
        createGroup()
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
