//
//  SignupProfileEditViewController.swift
//  StudentHub
//
//  Created by Fabio Quintanilha on 9/30/19.
//  Copyright © 2019 StudentHub. All rights reserved.
//

import UIKit
protocol AvatarDelegate {
    func updateAvatar(avatarID: String)
}
class SignupProfileEditViewController: UIViewController, AvatarDelegate {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var majorTextField: UITextField!
    @IBOutlet weak var campusTextField: UITextField!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    var avatarID: String = "avatar_9"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.avatarImageView.image = UIImage(named: avatarID)
    }
    
    func updateAvatar(avatarID: String) {
        self.avatarID = avatarID
        self.avatarImageView.image = UIImage(named: avatarID)
    }
    
    func updateProfile() {
        let firstName = firstNameTextField.text ?? ""
        let lastName = lastNameTextField.text ?? ""
        let major = majorTextField.text ?? ""
        let campus = campusTextField.text ?? ""
        
        if firstName.isEmpty {
            errorAlert(title: "Error!", message: "First name can't be empty")
            return
        }
        if lastName.isEmpty {
            errorAlert(title: "Error!", message: "Last name can't be empty")
            return
        }
        
        if major.isEmpty {
            errorAlert(title: "Error!", message: "Major can't be empty")
            return
        }
        
        if campus.isEmpty {
            errorAlert(title: "Error!", message: "School Campus can't be empty")
            return
        }
        
        CurrentUser.updateUserProfile(firstName: firstName, lastName: lastName, avatarID: self.avatarID, major: major, campus: campus)
        
        Database.service.updateUser(user_id: CurrentUser.id, data: CurrentUser.dataJson)
        self.performSegue(withIdentifier: "goToMapSegue", sender: self)
    }
    
    
    @IBAction func updateProfileTapped(_ sender: UIButton) {
        self.updateProfile()
    }
    
    @IBAction func avatarButtonTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "editAvatarSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editAvatarSegue" {
            let destination = segue.destination as! EditAvatarViewController
            destination.delegate = self
        }
    }
    
}
