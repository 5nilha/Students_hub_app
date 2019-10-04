//
//  CreateGroupViewController.swift
//  StudentHub
//
//  Created by Fabio Quintanilha on 9/30/19.
//  Copyright © 2019 StudentHub. All rights reserved.
//

import UIKit

class CreateGroupViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var switchPrivate: UISwitch!
    @IBOutlet weak var groupNameTextField: UITextField!
    @IBOutlet weak var groupDescriptionTextView: UITextView!
    @IBOutlet weak var groupImage: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let groupImages : [String] = ["101", "102", "103", "104", "105", "106", "107", "108", "109", "110", "111", "112", "113", "114"]
    var selectedImage : UIImage!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.allowsSelection = true
        self.popupView.roundCorner(radius: 20)
        createButton.roundCorner(radius: 6)
        cancelButton.border(width: 3, color: #colorLiteral(red: 0.01250977442, green: 0.4810960293, blue: 0.8075000644, alpha: 1))
        cancelButton.roundCorner(radius: 6)
        groupImage.roundCorner(radius: 10)
        switchPrivate.isOn = false
        selectedImage = UIImage(named: groupImages[0])!
        self.groupImage.image = selectedImage
    }
    
    
    func createGroup() {
        let groupName = self.groupNameTextField.text ?? ""
        let groupDescription = self.groupDescriptionTextView.text ?? ""
        let isPrivate = switchPrivate.isOn
        
        
        if !groupName.isEmpty && !groupDescription.isEmpty {
            let newGroup = GroupChat(group_name: groupName, adminEmail: CurrentUser.email, createdByID: CurrentUser.id, createdByName: CurrentUser.fullName, isPrivate: isPrivate, description: groupDescription, groupImage: selectedImage)
            
            self.waitView(message: "Creating Group...") { (waitSpinner) in
                Database.service.createGroup(image: newGroup.groupImage, data: newGroup.jsonData, completion: {
                    self.dismiss(animated: true, completion: nil)
                    if waitSpinner.isShowing() {
                        waitSpinner.hideView()
                    }
                })
            }
            
            
        }
    }

    @IBAction func createdButtonTapped(_ sender: UIButton) {
        createGroup()
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return groupImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GroupImagesCell", for: indexPath) as! GroupImagesCell
        
        cell.updateView(image: UIImage(named: groupImages[indexPath.row])!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedImage = UIImage(named: groupImages[indexPath.row])!
        self.groupImage.image = self.selectedImage
        print("selecting")
    }
    
}

class GroupImagesCell: UICollectionViewCell {
    @IBOutlet weak var groupView: UIView!
    @IBOutlet weak var groupImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.groupView.roundCorner(radius: 16)
        groupImage.roundCorner(radius: 16)
    }
    
    func updateView(image: UIImage) {
        self.groupImage.image = image
    }
    
}
