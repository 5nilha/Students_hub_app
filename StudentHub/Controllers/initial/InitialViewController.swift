//
//  InitialViewController.swift
//  StudentHub
//
//  Created by Fabio Quintanilha on 9/30/19.
//  Copyright © 2019 StudentHub. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController {

    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.signupButton.round(radius: 6)
        self.loginButton.round(radius: 6)
        self.loginButton.border(width: 3, color: #colorLiteral(red: 0.01250977442, green: 0.4810960293, blue: 0.8075000644, alpha: 1))

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func signupButtonTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToSignupSegue", sender: self)
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToLoginSegue", sender: self)
    }
    
}
