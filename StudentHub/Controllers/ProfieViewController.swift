//
//  ProfieViewController.swift
//  StudentHub
//
//  Created by Fabio Quintanilha on 9/8/19.
//  Copyright © 2019 StudentHub. All rights reserved.
//

import UIKit

class ProfieViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var selectedAvatarImageView: UIImageView!
    @IBOutlet weak var genderSegmentControl: UISegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView!
    let female_avatars = ["avatar_4","avatar_5", "avatar_8", "avatar_10"]
    
    let male_avatar = ["avatar_1", "avatar_2", "avatar_3", "avatar_6", "avatar_7", "avatar_9", "avatar_11"]
    
    var avatars = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.genderSegmentControl.selectedSegmentIndex = 0
        avatars = female_avatars

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func genderSegmentedControlChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            avatars = female_avatars
        }
        else {
            avatars = male_avatar
        }
        self.collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return avatars.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileAvatarCell", for: indexPath) as! ProfileAvatarCell
        let avatar = avatars[indexPath.row]
        cell.avatarImageView.image = UIImage(named: avatar)
        return cell
    }
    
   func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let avatar = avatars[indexPath.row]
        self.selectedAvatarImageView.image = UIImage(named: avatar)
//        let cell = collectionView.cellForItem(at: indexPath) as! ProfileAvatarCell
//        cell.checkedSelectedImage.image = #imageLiteral(resourceName: "checked-2")
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }


}

class ProfileAvatarCell: UICollectionViewCell {
    
    @IBOutlet weak var avatarImageView: UIImageView!

    
}
