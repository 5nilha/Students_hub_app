//
//  GroupChat.swift
//  StudentHub
//
//  Created by Fabio Quintanilha on 9/28/19.
//  Copyright © 2019 StudentHub. All rights reserved.
//

import Foundation

struct GroupChat {
    private var _id: String = ""
    private var _groupName: String = ""
    private var _groupImage: UIImage = #imageLiteral(resourceName: "studend_hub_logo")
    private var _groupMembers: [String] = [String]()
    private var _adminID: String = ""
    private var _adminName: String = ""
    private var _adminEmail: String = ""
    private var _moderators = [String]()
    private var _createdAt: Date = Date()
    private var _createdByID: String = ""
    private var _createdByName: String = ""
    private var _publicIdentifier: String = ""
    private var _code: String = ""
    private var _isPrivate: Bool = false
    private var _description: String = ""
    
    
    var id: String {
        get {
            return self._id
        }
    }
    
    var groupName: String {
        get {
            return self._groupName
        }
    }
    
    var groupImage: UIImage {
        get {
            return self._groupImage
        }
    }
    
    
    var groupMembers: [String] {
        get {
            return self._groupMembers
        }
    }
    
    var adminID: String {
        get {
            return self._adminID
        }
    }
    
    var adminName: String {
        get {
            return self._adminName
        }
    }
    
    var adminEmail: String {
        get {
            return self._adminEmail
        }
    }
    
    var moderators: [String] {
        get {
            return self._moderators
        }
    }
    
    var createdAt: Date {
        get {
            return self._createdAt
        }
    }
    
    var createdByID: String {
        get {
            return self._createdByID
        }
    }
    
    var createdByName: String {
        get {
            return self._createdByName
        }
    }
    
    var publicIdentifier: String {
        get {
            return self._publicIdentifier
        }
    }
    
    var code: String {
        get {
            return self._code
        }
    }
    
    var isPrivate: Bool {
        get {
            return self._isPrivate
        }
    }
    
    var description: String {
        get {
            return self._description
        }
    }
    
    
    init(group_name: String, adminEmail: String, createdByID: String, createdByName: String, isPrivate: Bool, description: String, groupImage: UIImage) {
        self._groupName = group_name
        self._groupImage = groupImage
        self._createdByID = createdByID
        self._createdByName = createdByName
        self._adminID = createdByID
        self._adminName = createdByName
        self._adminEmail = adminEmail
        self._isPrivate = isPrivate
        self._createdAt = Date()
        self._groupMembers.append(createdByID)
        self._description = description
        self._code = generateCode()
        self._publicIdentifier = "\(self._code)@\(group_name)"
    }
    
    private func generateCode() -> String {
        let calendar = Calendar.current
        var string = self._groupName.uppercased() + self._createdByName.uppercased()
        
        string.forEach { (c) in
            if c == " " {
                string.remove(at: string.firstIndex(of: c)!)
            }
        }
        
        var suffledString = string.shuffled()
        let count = suffledString.count
        let dateMinute = calendar.component(.minute, from: Date())
        let day = calendar.component(.day, from: Date())
        
        print(suffledString)
        let code = "\(suffledString[0])\(suffledString[2])\(day)\( suffledString[3])\(count)\(count % 2)\(suffledString[1])\(dateMinute)"
        
        return code
    }
    
    private func jsonData() -> [String: Any] {
        return ["id" : self._id,
                "group_name" : self._groupName,
                "group_members" : self._groupMembers,
                "created_at" : self._createdAt,
                "created_by_id" : self._createdByID,
                "created_by_name" : self._createdByName,
                "public_identifier" : self._publicIdentifier,
                "code" : self._code,
                "is_private" : self._isPrivate]
    }
    
}
