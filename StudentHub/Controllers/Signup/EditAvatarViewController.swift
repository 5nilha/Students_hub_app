//
//  EditAvatarViewController.swift
//  StudentHub
//
//  Created by Fabio Quintanilha on 9/30/19.
//  Copyright © 2019 StudentHub. All rights reserved.
//

import UIKit

class EditAvatarViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
 
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var selectAvatarButton: UIButton!
    
    let female_avatars = ["avatar_4","avatar_5", "avatar_8", "avatar_10"]
    
    let male_avatar = ["avatar_1", "avatar_2", "avatar_3", "avatar_6", "avatar_7", "avatar_9", "avatar_11"]
    
    var avatars = [String]()
    
    var selectedAvatarID: String!
    var delegate : AvatarDelegate!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.popUpView.roundCorner(radius: 20)
        self.avatarImageView.circle()
        self.selectAvatarButton.round(radius: 6)
        self.selectAvatarButton.border(width: 3, color: #colorLiteral(red: 0.01250977442, green: 0.4810960293, blue: 0.8075000644, alpha: 1))
        self.avatars = male_avatar
        self.collectionView.reloadData()
    }
    @IBAction func genderSegmentedControlChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            self.avatars = male_avatar
        } else {
            self.avatars = female_avatars
        }
        self.collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return avatars.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EditAvatarCell", for: indexPath) as! EditAvatarCell
        
        cell.avatarImageView.image = UIImage(named: avatars[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedAvatarID = avatars[indexPath.row]
        avatarImageView.image = UIImage(named: selectedAvatarID)
        
    }
    
    @IBAction func selectAvatarTapped(_ sender: UIButton) {
        if selectedAvatarID != nil {
            delegate.updateAvatar(avatarID: selectedAvatarID)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
}

class EditAvatarCell: UICollectionViewCell {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
}
