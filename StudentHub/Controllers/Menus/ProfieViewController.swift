//
//  ProfieViewController.swift
//  StudentHub
//
//  Created by Fabio Quintanilha on 9/8/19.
//  Copyright © 2019 StudentHub. All rights reserved.
//

import UIKit

class ProfieViewController: UIViewController, AvatarDelegate {
    
    @IBOutlet weak var sideMenu: UIButton!
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTExtField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var majorTextField: UITextField!
    @IBOutlet weak var SchoolTextField: UITextField!
    @IBOutlet weak var campusTextField: UITextField!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    var avatarID: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addSideMenuButton(menuButton: sideMenu)
        self.updateView()
    }
    
    func updateAvatar(avatarID: String) {
        self.avatarImageView.image = UIImage(named: avatarID)
        self.avatarID = avatarID
       }
       
    
    func updateView() {
        self.avatarImageView.image = UIImage(named: CurrentUser.avatarID)
        self.firstNameTextField.text = CurrentUser.firstName
        self.lastNameTExtField.text = CurrentUser.lastName
        self.emailTextField.text = CurrentUser.email
        self.majorTextField.text = CurrentUser.major
        self.SchoolTextField.text = CurrentUser.college
        self.campusTextField.text = CurrentUser.campus
        self.avatarID = CurrentUser.avatarID
    }
    
    func updateProfile() {
        
        let major = majorTextField.text ?? ""
        let campus = campusTextField.text ?? ""
        
        
        if major.isEmpty {
            errorAlert(title: "Error!", message: "Major can't be empty")
            return
        }
        
        if campus.isEmpty {
            errorAlert(title: "Error!", message: "School Campus can't be empty")
            return
        }
        
        CurrentUser.updateUserProfile(firstName: CurrentUser.firstName, lastName: CurrentUser.lastName, avatarID: self.avatarID, major: major, campus: campus)
        
        Database.service.updateUser(user_id: CurrentUser.id, data: CurrentUser.dataJson)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func updateProfileButtonTapped(_ sender: UIButton) {
        self.updateProfile()
    }
    
    @IBAction func editAvatarTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "editAvatarSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editAvatarSegue" {
            let destination = segue.destination as! EditAvatarViewController
            destination.delegate = self
        }
    }
    @IBAction func backMenuTapped(_ sender: UIButton) {
//        self.dismiss(animated: true, completion: nil)
    }
    
    
}

