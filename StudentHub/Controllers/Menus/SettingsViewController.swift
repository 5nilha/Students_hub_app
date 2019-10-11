//
//  SettingsViewController.swift
//  StudentHub
//
//  Created by Fabio Quintanilha on 10/11/19.
//  Copyright © 2019 StudentHub. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var menus = ["Change Password", "Logout"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menus.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsCell
        cell.menuLabel.text = menus[indexPath.row]
        return cell
    }
    


}

class SettingsCell: UITableViewCell {
    
    @IBOutlet weak var menuLabel: UILabel!
}
