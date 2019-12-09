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
            self.feeds = feeds.sorted(by: { (a, b) -> Bool in
                return b.date > a.date
            })
            
            
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
        let feed = feeds[indexPath.row]
        if feed.isImage == true && feed.content != "" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FeedsWithImageAndContentCell", for: indexPath) as! FeedsWithImageAndContentCell
            
            cell.updateView(feed: feed)
            
            return cell
        }
        else if feed.isImage == true && feed.content == "" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FeedsWithImageCell", for: indexPath) as! FeedsWithImageCell
            
            cell.updateView(feed: feed)
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FeedsCell", for: indexPath) as! FeedsCell
            
            cell.updateView(feed: feed)
            
            return cell
        }
        
    }
    
}

class FeedsCell: UITableViewCell {
    
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var majorLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!

    
    override func awakeFromNib() {
        messageLabel.numberOfLines = 0
        backgroundColor = .clear
    }
    
    func updateView(feed: Feed) {
        self.avatarImage.image = UIImage(named: feed.senderAvatarID)
        self.userNameLabel.text = feed.senderName
        self.majorLabel.text = feed.senderMajor
        self.messageLabel.text = feed.content
       
    }
    
}

class FeedsWithImageAndContentCell: UITableViewCell {
    
 
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var majorLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var feedImageView: UIImageView!
    
    override func awakeFromNib() {
        messageLabel.numberOfLines = 0
        backgroundColor = .clear
    }
    
    func updateView(feed: Feed) {
        self.avatarImage.image = UIImage(named: feed.senderAvatarID)
        self.userNameLabel.text = feed.senderName
        self.majorLabel.text = feed.senderMajor
        self.messageLabel.text = feed.content
        if feed.images.count > 0 {
            feedImageView.image = feed.images[0]
            feedImageView.isHidden = false
        }
        else {
            feedImageView.isHidden = true
        }
    }
    
}

class FeedsWithImageCell: UITableViewCell {
    
 
    @IBOutlet weak var feedView: UIView!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var majorLabel: UILabel!
    @IBOutlet weak var feedImageView: UIImageView!
    
    override func awakeFromNib() {
        backgroundColor = .clear
        self.feedView.roundCorner(radius: 6.0)
        self.feedView.setShadow(color: .black, opacity: 0.5, shadowRadius: 1.0, shadowOffset_x: 0, shadowOffset_y: 0)
    }
    
    func updateView(feed: Feed) {
        self.avatarImage.image = UIImage(named: feed.senderAvatarID)
        self.userNameLabel.text = feed.senderName
        self.majorLabel.text = feed.senderMajor
        if feed.images.count > 0 {
            feedImageView.image = feed.images[0]
            feedImageView.isHidden = false
        }
        else {
            feedImageView.isHidden = true
        }
    }
    
}
