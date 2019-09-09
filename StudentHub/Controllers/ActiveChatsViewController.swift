//
//  ActiveChatsViewController.swift
//  StudentHub
//
//  Created by Fabio Quintanilha on 9/9/19.
//  Copyright © 2019 StudentHub. All rights reserved.
//

import UIKit

class ActiveChatsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sideMenuButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.addSideMenuButton(menuButton: sideMenuButton)
        
    }
    
    @IBAction func startChartTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToContacts", sender: self)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActiveChatsCell", for: indexPath) as! ActiveChatsCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "goToMessage", sender: self)
    }

}


class ActiveChatsCell: UITableViewCell {
    
    @IBOutlet weak var avatarImgView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var majorLabel: UILabel!
    @IBOutlet weak var lastSeenOnlineLabel: UILabel!
}
