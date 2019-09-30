//
//  GroupSelectionPopupViewController.swift
//  StudentHub
//
//  Created by Fabio Quintanilha on 9/29/19.
//  Copyright © 2019 StudentHub. All rights reserved.
//

import UIKit

class GroupSelectionPopupViewController: UIViewController {
    
    
    @IBOutlet weak var groupLabel: UILabel!
    @IBOutlet weak var identifierLabel: UILabel!
    @IBOutlet weak var createdByLabel: UILabel!
    
    @IBOutlet weak var enterGroupButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var membersLabel: UILabel!
    @IBOutlet weak var groupView: UIView!
    @IBOutlet weak var popupView: UIView!
    
    var groupChat: GroupChat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.popupView.roundCorner(radius: 20)
        self.groupView.roundCorner(radius: 16)
        self.popupView.setShadow(color: .lightGray, opacity: 0.5, shadowRadius: 20, shadowOffset_x: 0, shadowOffset_y: 0)
        self.enterGroupButton.round(radius: Float(enterGroupButton.frame.height / 2))
        self.enterGroupButton.border(width: 3, color: #colorLiteral(red: 1, green: 0.328096509, blue: 0.2194594443, alpha: 1))
        
        // Do any additional setup after loading the view.
        self.updateView()
    }
    

    func updateView() {
        self.groupLabel.text = groupChat.groupName
        self.identifierLabel.text = groupChat.publicIdentifier
        self.createdByLabel.text = groupChat.createdByName
        self.membersLabel.text = "\(groupChat.groupMembers.count)"
        self.descriptionLabel.text = groupChat.description
    }

    
    @IBAction func tapGesture(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
