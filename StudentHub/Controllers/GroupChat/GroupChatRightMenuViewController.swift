//
//  GroupChatRightMenuViewController.swift
//  StudentHub
//
//  Created by Fabio Quintanilha on 9/26/19.
//  Copyright © 2019 StudentHub. All rights reserved.
//

import UIKit

class GroupChatRightMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupChatRightMenuCell", for: indexPath) as! GroupChatRightMenuCell
        
        return cell
    }

}

class GroupChatRightMenuCell: UITableViewCell {
    @IBOutlet weak var connectionView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.connectionView.circle()
    }
    
}
