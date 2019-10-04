//
//  GroupChatViewController.swift
//  StudentHub
//
//  Created by Fabio Quintanilha on 9/26/19.
//  Copyright © 2019 StudentHub. All rights reserved.
//

import UIKit
import MessageViewController
import UserNotifications

class GroupChatViewController: MessageViewController, UITableViewDataSource, UITableViewDelegate, MessageAutocompleteControllerDelegate {

    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var rightSideMenu: UIButton!
    
    let users = ["rnystrom", "BasThomas", "jessesquires", "Sherlouk", "omwomw"]
    var autocompleteUsers = [String]()
    
    var willStopUpdateMessagesIndexes = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addSideRightMenuButton(menuButton: rightSideMenu)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
        borderColor = .lightGray
        
        // Change the appearance of the text view and its content
        messageView.inset = UIEdgeInsets(top: 10, left: 10, bottom: 8, right: 10)
        messageView.backgroundColor = .groupTableViewBackground
//        messageView.textView.roundCorner(radius: 10)
//        messageView.textView.backgroundColor = .white
//        messageView.textView.contentInset = UIEdgeInsets(top: 20, left: 10, bottom: 8, right: 10)
        
        messageView.textView.placeholderText = "New message..."
        messageView.textView.placeholderTextColor = .lightGray
        messageView.font = .systemFont(ofSize: 16)

        messageView.setButton(inset: 15, position: .right)

        messageView.textView.placeholderText = "New message..."
        messageView.textView.placeholderTextColor = .lightGray

        messageView.setButton(icon: #imageLiteral(resourceName: "send-button-3"), for: .normal, position: .right)
        
        messageView.addButton(target: self, action: #selector(onRightButton), position: .right)
        
        messageAutocompleteController.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        messageAutocompleteController.tableView.dataSource = self
        messageAutocompleteController.tableView.delegate = self
        messageAutocompleteController.register(prefix: "@")
        
        // Set custom attributes for an autocompleted string
        let tintColor = UIColor(red: 0, green: 122/255, blue: 1, alpha: 1)
        messageAutocompleteController.registerAutocomplete(prefix: "@", attributes: [
            .font: UIFont.preferredFont(forTextStyle: .body),
            .foregroundColor: tintColor,
            .backgroundColor: tintColor.withAlphaComponent(0.1)
            ])
        
        messageAutocompleteController.delegate = self
        
        setup(scrollView: tableView)
        
        self.updateView()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationWillTerminate),
                                               name: UIApplication.willTerminateNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationWillTerminate),
                                               name: UIApplication.willResignActiveNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationWillEnterForeground),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        CurrentUser.activeGroupChat.isMemberOnline(online: false, memberID: CurrentUser.id)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func applicationWillTerminate()  {
        print("TERMINATING")
        CurrentUser.activeGroupChat.isMemberOnline(online: false, memberID: CurrentUser.id)
    }
    
    @objc func applicationWillEnterForeground()  {
        print("Opening")
        CurrentUser.activeGroupChat.isMemberOnline(online: true, memberID: CurrentUser.id)
    }
    
    
    
    
    @objc func onLeftButton() {
        print("Did press left button")
    }
    
    @objc func onRightButton() {
        let newMessage = GroupChatMessage(senderID: CurrentUser.id, senderName: CurrentUser.fullName, senderAvatarID: CurrentUser.avatarID, senderMajor: CurrentUser.major, messageString: messageView.text, groupId: CurrentUser.activeGroupChat.id)
        
        
        Database.service.createGroupChatMessage(groupID: newMessage.groupId, data: newMessage.jsonData) {
            self.messageView.text = ""
        }
    }
    
    
    func updateView() {
        self.groupNameLabel.text = CurrentUser.activeGroupChat.groupName
        CurrentUser.activeGroupChat.isMemberOnline(online: true, memberID: CurrentUser.id)
        readMessages()
    }
    
    func readMessages() {
        Database.service.snapshotChatMessages(groupID: CurrentUser.activeGroupChat.id) { (messages) in
            CurrentUser.activeGroupChat.messages = messages
            self.tableView.reloadData()
            let messageCount = CurrentUser.activeGroupChat.messages.count
            if messageCount > 1 {
                self.tableView.scrollToRow(
                    at: IndexPath(row: messageCount - 1, section: 0),
                    at: .bottom,
                    animated: false
                )
            }
            
            if self.willStopUpdateMessagesIndexes != true {

                AppConfig.setNotification(title: "New Message at \((CurrentUser.activeGroupChat.groupName)) Group", message: "" , identifier: "new_message")
                Database.service.updateLastMessageSeenByUser(userID: CurrentUser.id, groupID: CurrentUser.activeGroupChat.id, messageIndex: CurrentUser.activeGroupChat.numberOfMessages)
            }
        }
    }
    
    class DateHeaderLabel: UILabel {
        override var intrinsicContentSize: CGSize {
            let originalContentSize = super.intrinsicContentSize
            let height = originalContentSize.height + 12
            layer.cornerRadius = height / 2
            layer.masksToBounds = true
            return CGSize(width: originalContentSize.width + 16, height: height)
        }
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView === self.tableView
            ? CurrentUser.activeGroupChat.messages.count
            : autocompleteUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView === self.tableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "GroupMessageCell", for: indexPath) as! GroupMessageCell
            
            cell.updateView(message: CurrentUser.activeGroupChat.messages[indexPath.row])
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = autocompleteUsers[indexPath.row]
            return cell
        }
        
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if tableView === messageAutocompleteController.tableView {
            messageAutocompleteController.accept(autocomplete: autocompleteUsers[indexPath.row])
        }
    }
    
    // MARK: MessageAutocompleteControllerDelegate
    
    func didFind(controller: MessageAutocompleteController, prefix: String, word: String) {
        autocompleteUsers = users.filter { word.isEmpty || $0.lowercased().contains(word.lowercased()) }
        controller.show(true)
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.willStopUpdateMessagesIndexes = true
        self.performSegue(withIdentifier: "unwindToGroups", sender: self)
    }
    
    
}


class GroupMessageCell: UITableViewCell {
    
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var majorLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var bubbleView: UIView!
    @IBOutlet weak var bubbleViewLeading: NSLayoutConstraint!
    @IBOutlet weak var bubbleViewTrailing: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
        messageLabel.numberOfLines = 0
        bubbleView.layer.cornerRadius = 15
        bubbleView.backgroundColor = .groupTableViewBackground
        
    }
    
    func updateView(message: GroupChatMessage){
        let calendar = Calendar.current
        self.nameLabel.text = message.senderName
        self.messageLabel.text = message.messageString
        self.avatarImage.image = UIImage(named: message.senderAvatarID)
        self.timeLabel.text = calendar.getCurrentTimeHoursMins(date: message.date)
        self.majorLabel.roundCorner(radius: 5)
        self.majorLabel.text = "  \(message.senderMajor)  "
        
        
        if message.senderID == CurrentUser.id {
            self.bubbleViewLeading.constant = 100
            self.bubbleViewTrailing.constant = 10
        }
        else {
            self.bubbleViewLeading.constant = 10
            self.bubbleViewTrailing.constant = 100
        }
    }
    
}
