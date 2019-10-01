//
//  LoginViewController.swift
//  StudentHub
//
//  Created by Fabio Quintanilha on 9/30/19.
//  Copyright © 2019 StudentHub. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func loginUser() {
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
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                self.errorAlert(title: "Error!", message: "\(error.localizedDescription)")
                print("Error -> \(error.localizedDescription)")
                return
            }
            
            guard let user = result?.user else { return }
            
            var newUser = User()
            newUser.setNewUser(id: user.uid, email: email)
            print("Getting User")
            Database.service.getUser(user_id: newUser.id, completion: { (userData) in
                CurrentUser = userData
                print("User read")
                if CurrentUser.firstName.isEmpty || CurrentUser.lastName.isEmpty {
                    self.performSegue(withIdentifier: "goToEditProfileSegue", sender: self)
                }
                else {
                    self.performSegue(withIdentifier: "goToMapSegue", sender: self)
                }
            })
        }
        
    }
    
    
    @IBAction func loginTapped(_ sender: UIButton) {
        self.loginUser()
    }
    
    @IBAction func cancelButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
