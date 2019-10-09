//
//  GroupChatRightMenuViewController.swift
//  StudentHub
//
//  Created by Fabio Quintanilha on 9/26/19.
//  Copyright © 2019 StudentHub. All rights reserved.
//

import UIKit
import SCLAlertView

class GroupChatRightMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var groupImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var publicIdentifierLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateView()
        Database.service.snapshotMemberOnline(groupID: CurrentUser.activeGroupChat.id) { [unowned self] (membersID) in
            CurrentUser.activeGroupChat.membersOnline = membersID
            self.tableView.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        Database.service.removesMembersOnlineListener()
    }
    
    func updateView() {
        self.groupNameLabel.text = CurrentUser.activeGroupChat.groupName
        self.publicIdentifierLabel.text = CurrentUser.activeGroupChat.publicIdentifier
        print("MEMBERS = \(CurrentUser.activeGroupChat.groupMembers.count)")
        self.groupImage.image = CurrentUser.activeGroupChat.groupImage
        self.groupImage.roundCorner(radius: 10)
    }
    
    @IBAction func leaveGroupTapped(_ sender: UIButton) {
        CurrentUser.activeGroupChat.deleteMember(id: CurrentUser.id, name: CurrentUser.fullName)
    }
    
    @IBAction func inviteUserTapped(_ sender: UIButton) {
        let appearance = SCLAlertView.SCLAppearance( showCloseButton: false)
        let alertView = SCLAlertView(appearance: appearance)
        let email = alertView.addTextField("Enter user email")
        
        alertView.addButton("Cancel") {
            alertView.dismiss(animated: true, completion: nil)
        }
        alertView.addButton("Send") {
            Database.service.inviteUserToGroup(email: email.text ?? "", groupID: CurrentUser.activeGroupChat.id, groupIdentifier: CurrentUser.activeGroupChat.publicIdentifier)
            alertView.dismiss(animated: true, completion: nil)
        }
        alertView.showInfo("Invite User", subTitle: "Enter User information")
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CurrentUser.activeGroupChat.groupMembers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupChatRightMenuCell", for: indexPath) as! GroupChatRightMenuCell
        
        cell.updateView(member: CurrentUser.activeGroupChat.groupMembers[indexPath.row], onlineMembers: CurrentUser.activeGroupChat.membersOnline)
        return cell
    }

}

class GroupChatRightMenuCell: UITableViewCell {
    @IBOutlet weak var connectionView: UIView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var connectionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.connectionView.circle()
    }
    
    func updateView(member: GroupChat.Member, onlineMembers: [String]) {
        self.nameLabel.text = member.memberName
        
        if onlineMembers.contains(member.memberID) {
            self.connectionView.backgroundColor = #colorLiteral(red: 0.0001139477238, green: 0.5926990799, blue: 0.1168548966, alpha: 1)
            self.connectionLabel.text = "Online"
        }
        else {
            self.connectionView.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            self.connectionLabel.text = "Offline"
        }
    }
    
}
