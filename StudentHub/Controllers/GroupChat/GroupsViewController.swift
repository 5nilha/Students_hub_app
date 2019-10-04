//
//  GroupsViewController.swift
//  StudentHub
//
//  Created by Fabio Quintanilha on 9/28/19.
//  Copyright © 2019 StudentHub. All rights reserved.
//

import UIKit


class GroupsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {
    
    
    @IBOutlet weak var sideMenu: UIButton!
    @IBOutlet weak var searchbar: UISearchBar!
    @IBOutlet weak var myGroupsCollectionView: UICollectionView!
    @IBOutlet weak var allGroupsCollectionView: UICollectionView!
    @IBOutlet weak var invitingButtonBadge: UIView!
    var sections = ["MY GROUPS", "ALL GROUPS"]
    
    var myActiveGroups = [GroupChat]()
    var allGroups = [GroupChat]()
    var allGroupsFiltered = [GroupChat]()

    var selectedGroup: GroupChat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSideMenuButton(menuButton: sideMenu)
        self.allGroupsCollectionView.delegate = self
        self.allGroupsCollectionView.dataSource = self
        self.myGroupsCollectionView.delegate = self
        self.myGroupsCollectionView.dataSource = self
        self.searchbar.delegate = self
        self.invitingButtonBadge.circle()
        self.invitingButtonBadge.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateGroups()
        
       
        
        Database.service.snapshotUserInvitings(userID: CurrentUser.id) { (invitings) in
            CurrentUser.groupsInviting = invitings
            if CurrentUser.groupsInviting.count > 0 {
                self.invitingButtonBadge.isHidden = false
            }
            else {
                self.invitingButtonBadge.isHidden = true
            }
        }
        
        Database.service.snapshotLastMessageSeenByUser(userID: CurrentUser.id) { (lastMessageSeenIndexes) in
            CurrentUser.lastMessageIndexSeenOnGroups = lastMessageSeenIndexes
            print("last index \(lastMessageSeenIndexes)")
            self.myGroupsCollectionView.reloadData()
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Database.service.removesnapshotGroupsListener()
        Database.service.removesUserInvitingsListener()
    }
    
    func updateGroups() {
        
        self.waitView(message: "Loading Groups ...") { (waitSpinner) in
            Database.service.snapshotGroups { (groups) in
                self.allGroups = groups
                self.allGroupsFiltered = self.allGroups
                self.allGroupsCollectionView.reloadData()
                
                self.myActiveGroups = groups.filter({ (group) -> Bool in
                    return group.groupMembersID.contains(CurrentUser.id)
                })
                self.myGroupsCollectionView.reloadData()
                if waitSpinner.isShowing() {
                    waitSpinner.hideView()
                }
            }
            
        }
       
    }
    
    @IBAction func createGroupTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToCreateGroupSegue", sender: self)
    }
    
    @IBAction func invitingsButtonTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToInvitings", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToPopup" {
            let destination = segue.destination as! GroupSelectionPopupViewController
            destination.groupChat = self.selectedGroup
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let search = searchbar.text {
            if search.isEmpty {
                self.allGroupsFiltered = allGroups
            } else {
                self.allGroupsFiltered = allGroups.filter({ (group) -> Bool in
                    return group.groupName.lowercased().contains(search) || group.publicIdentifier.contains(search)
                })
            }
        }
        else {
            self.allGroupsFiltered = allGroups
        }
        self.allGroupsCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.myGroupsCollectionView {
            return myActiveGroups.count
        }
        else {
            return allGroupsFiltered.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.myGroupsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyGroupCell", for: indexPath) as! MyGroupCell
            cell.updateView(groupChat: myActiveGroups[indexPath.row])
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AllGroupsCollectionCell", for: indexPath) as! AllGroupsCollectionCell
            cell.updateView(groupChat: allGroupsFiltered[indexPath.row])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.myGroupsCollectionView {
            self.selectedGroup = myActiveGroups[indexPath.row]
            CurrentUser.activeGroupChat = self.selectedGroup
            self.performSegue(withIdentifier: "goToGroupSegue", sender: self)
        }
        else {
            self.selectedGroup = allGroupsFiltered[indexPath.row]
            self.performSegue(withIdentifier: "segueToPopup", sender: self)
        }
    }
    
    
    
    @IBAction func unwindToGroupsVC(sender: UIStoryboardSegue) {
        
    }
}


class MyGroupCell: UICollectionViewCell {
    
    @IBOutlet weak var groupView: UIView!
    @IBOutlet weak var badgeView: UIView!
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var groupImage: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.groupView.roundCorner(radius: 16)
        self.groupImage.roundCorner(radius: 16)
        self.badgeView.circle()
        self.badgeView.isHidden = true
    }
    
    func updateView(groupChat: GroupChat) {
        self.groupNameLabel.text = groupChat.groupName
        self.groupImage.image = groupChat.groupImage
        
        for data in CurrentUser.lastMessageIndexSeenOnGroups {
            if data.key == groupChat.id {
                let lastIndex = data.value
                print("Index = \(lastIndex)")
                if groupChat.numberOfMessages > lastIndex {
                    badgeView.isHidden = false
                }
                else {
                    self.badgeView.isHidden = true
                }
            }
        }
    }
}



class AllGroupsCollectionCell: UICollectionViewCell {
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var membersLabel: UILabel!
    @IBOutlet weak var imageLabel: UIImageView!
    @IBOutlet weak var groupView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.groupView.roundCorner(radius: 10)
        self.imageLabel.roundCorner(radius: 10)
        self.groupView.setShadow(color: .black, opacity: 0.6, shadowRadius: 5, shadowOffset_x: 0, shadowOffset_y: 0)
    }
    
    func updateView(groupChat: GroupChat) {
        
        self.groupNameLabel.text = groupChat.groupName
        self.membersLabel.text = "\(groupChat.groupMembers.count)"
        self.imageLabel.image = groupChat.groupImage
    }
}
