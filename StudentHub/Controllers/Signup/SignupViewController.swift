//
//  SignupViewController.swift
//  StudentHub
//
//  Created by Fabio Quintanilha on 9/30/19.
//  Copyright © 2019 StudentHub. All rights reserved.
//

import UIKit
import Firebase
import SCLAlertView

class SignupViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logoView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.logoView.circle()
    }

    @IBAction func emailTextFieldChanged(_ sender: UITextField) {
    }
    
    @IBAction func passwordTextFieldChanged(_ sender: UITextField) {
    }
    
    func sigunupUser() {
        
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        if email.isEmpty {
            errorAlert(title: "Error!", message: "Email can't be empty")
            return
        }
        else if password.isEmpty {
            errorAlert(title: "Error!", message: "Password can't be empty")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                self.errorAlert(title: "Error!", message: "\(error.localizedDescription)")
                print("Error -> \(error.localizedDescription)")
                return
            }
            guard let user = result?.user else { return }
            
            var newUser = User()
            newUser.setNewUser(id: user.uid, email: email)
            Database.service.createUser(user_id: newUser.id, data: newUser.dataJson, completion: { (error) in
                if error != nil {
                    user.delete(completion: { (error) in
                        if error != nil {
                            print("Error deleting account")
                            return
                        } else {
                            print("Account Deleted")
                            return
                        }
                    })
                    
                }
                else {
                    self.performSegue(withIdentifier: "goToEditProfileSegue", sender: self)
                }
            })
        }
    }
    
    
    @IBAction func signupButtonTapped(_ sender: UIButton) {
        self.sigunupUser()
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
