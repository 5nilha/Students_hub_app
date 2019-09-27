//
//  GroupChatViewController.swift
//  StudentHub
//
//  Created by Fabio Quintanilha on 9/26/19.
//  Copyright © 2019 StudentHub. All rights reserved.
//

import UIKit
import MessageViewController

class GroupChatViewController: MessageViewController, UITableViewDataSource, UITableViewDelegate, MessageAutocompleteControllerDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var rightSideMenu: UIButton!
    
    var data = "Lorem ipsum dolor sit amet|consectetur adipiscing elit|sed do eiusmod|tempor incididunt|ut labore et dolore|magna aliqua| Ut enim ad minim|veniam, quis nostrud|exercitation ullamco|laboris nisi ut aliquip|ex ea commodo consequat|Duis aute|irure dolor in reprehenderit|in voluptate|velit esse cillum|dolore eu|fugiat nulla pariatur|Excepteur sint occaecat|cupidatat non proident|sunt in culpa|qui officia|deserunt|mollit anim id est laborum"
        .components(separatedBy: "|")
    let users = ["rnystrom", "BasThomas", "jessesquires", "Sherlouk", "omwomw"]
    var autocompleteUsers = [String]()
    
    
    
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
    }

    @objc func onLeftButton() {
        print("Did press left button")
    }
    
    @objc func onRightButton() {
        data.append(messageView.text)
        messageView.text = ""
        tableView.reloadData()
        tableView.scrollToRow(
            at: IndexPath(row: data.count - 1, section: 0),
            at: .bottom,
            animated: true
        )
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView === self.tableView
            ? data.count
            : autocompleteUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if tableView === self.tableView {
            cell.textLabel?.text = data[indexPath.row]
        } else {
            cell.textLabel?.text = autocompleteUsers[indexPath.row]
        }
        return cell
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
    
}
