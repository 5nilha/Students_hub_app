//
//  FeedsViewController.swift
//  StudentHub
//
//  Created by Fabio Quintanilha on 9/8/19.
//  Copyright © 2019 StudentHub. All rights reserved.
//

import UIKit

class FeedsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topMenu: UIButton!
    
    var feeds = [Feed]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.addSideMenuButton(menuButton: topMenu)
        self.readFeeds()
    }
    
    func readFeeds() {
        Database.service.snapshotFeeds { [unowned self] (feeds) in
            self.feeds = feeds
            self.tableView.reloadData()
        }
    }
    
    @IBAction func addFeedTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToWriteFeedSegue", sender: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feeds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedsCell", for: indexPath) as! FeedsCell
        
        return cell
    }
    
    


}

class FeedsCell: UITableViewCell {
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var majorLabel: UILabel!
    
}
