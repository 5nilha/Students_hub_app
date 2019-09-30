//
//  GroupsViewController.swift
//  StudentHub
//
//  Created by Fabio Quintanilha on 9/28/19.
//  Copyright © 2019 StudentHub. All rights reserved.
//

import UIKit


class GroupsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    @IBOutlet weak var myGroupsCollectionView: UICollectionView!
    @IBOutlet weak var allGroupsCollectionView: UICollectionView!
    var sections = ["MY GROUPS", "ALL GROUPS"]
    
    var myActiveGroups = [GroupChat]()
    var allGroups = [GroupChat]()

    var selectedGroup: GroupChat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.allGroupsCollectionView.delegate = self
        self.allGroupsCollectionView.dataSource = self
        self.myGroupsCollectionView.delegate = self
        self.myGroupsCollectionView.dataSource = self

        updateGroups()
    }
    
    func updateGroups() {
        //Call database
    }
    
    @IBAction func createGroupTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToCreateGroupSegue", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToPopup" {
            let destination = segue.destination as! GroupSelectionPopupViewController
            destination.groupChat = self.selectedGroup
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.myGroupsCollectionView {
            return myActiveGroups.count
        }
        else {
            return allGroups.count
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
            cell.updateView(groupChat: allGroups[indexPath.row])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.myGroupsCollectionView {
            self.selectedGroup = myActiveGroups[indexPath.row]
            self.performSegue(withIdentifier: "goToGroupSegue", sender: self)
        }
        else {
            self.selectedGroup = myActiveGroups[indexPath.row]
            self.performSegue(withIdentifier: "segueToPopup", sender: self)
        }
    }
}


class MyGroupCell: UICollectionViewCell {
    
    @IBOutlet weak var groupView: UIView!
    @IBOutlet weak var badgeView: UIView!
    @IBOutlet weak var groupNameLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.groupView.roundCorner(radius: 16)
        self.badgeView.circle()
    }
    
    func updateView(groupChat: GroupChat) {
        self.groupNameLabel.text = groupChat.groupName
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
        self.groupView.setShadow(color: .black, opacity: 0.6, shadowRadius: 5, shadowOffset_x: 0, shadowOffset_y: 0)
    }
    
    func updateView(groupChat: GroupChat) {
        
        self.groupNameLabel.text = groupChat.groupName
        self.membersLabel.text = "\(groupChat.groupMembers.count)"
        self.imageLabel.image = groupChat.groupImage
    }
}
