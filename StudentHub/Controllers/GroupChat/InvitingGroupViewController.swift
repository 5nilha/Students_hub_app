//
//  InvitingGroupViewController.swift
//  StudentHub
//
//  Created by Fabio Quintanilha on 10/4/19.
//  Copyright © 2019 StudentHub. All rights reserved.
//

import UIKit

protocol InvitingGroupDelegate {
    func inviteAnswer()
}

class InvitingGroupViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, InvitingGroupDelegate {
    
    
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.popUpView.roundCorner(radius: 20)

        // Do any additional setup after loading the view.
    }
    
    func inviteAnswer() {
        self.tableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CurrentUser.groupsInviting.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InvitingGroupCell", for: indexPath) as! InvitingGroupCell
        
        cell.delegate = self
        cell.updateCell(identifier: CurrentUser.groupsInviting[indexPath.row])
        return cell
    }
    
 
    @IBAction func closeButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

class InvitingGroupCell: UITableViewCell {
    
    @IBOutlet weak var inviteView: UIView!
    @IBOutlet weak var groupIdentifierLabel: UILabel!
    @IBOutlet weak var denyButton: UIButton!
    @IBOutlet weak var acceptButton: UIButton!
    private var groupIdentifier: String!
    
    var delegate: InvitingGroupDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.inviteView.circle()
        self.denyButton.round(radius: 10)
        self.acceptButton.round(radius: 10)
    }
    
    func updateCell(identifier: String) {
        self.groupIdentifierLabel.text = identifier
        groupIdentifier = identifier
    }
    
    
    @IBAction func acceptButtonTapped(_ sender: UIButton) {
        Database.service.acceptGroupInviting(userID: CurrentUser.id, userName: CurrentUser.fullName, groupIdentifier: groupIdentifier)
        CurrentUser.removeGroupInviting(identifier: groupIdentifier)
        if delegate != nil {
            delegate.inviteAnswer()
        }
        
    }
    
    @IBAction func denyButtonTapped(_ sender: UIButton) {
        Database.service.rejectGroupInviting(userID: CurrentUser.id, groupIdentifier: groupIdentifier)
        CurrentUser.removeGroupInviting(identifier: groupIdentifier)
        if delegate != nil {
            delegate.inviteAnswer()
        }
    }
    
    
}
