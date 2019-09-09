//
//  SideMenuViewController.swift
//  StudentHub
//
//  Created by Fabio Quintanilha on 9/8/19.
//  Copyright © 2019 StudentHub. All rights reserved.
//

import UIKit

class SideMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    let menus = ["Profile", "My Classes", "Settings", "Logout"]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self

        //Change the color of the selected cell
        let colorView = UIView()
        colorView.backgroundColor = #colorLiteral(red: 0.07843137255, green: 0.2705882353, blue: 0.4, alpha: 1)
        UITableViewCell.appearance().selectedBackgroundView = colorView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menus.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuCell", for: indexPath) as! SideMenuCell
        
        let menu = menus[indexPath.row]
        cell.menuLabel.text = menu
        cell.iconImageview.image = UIImage(named: menu)
        return cell
    }

}


class SideMenuCell: UITableViewCell {
    
    @IBOutlet weak var iconImageview: UIImageView!
    @IBOutlet weak var menuLabel: UILabel!
    
}