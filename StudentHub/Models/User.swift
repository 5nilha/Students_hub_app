//
//  User.swift
//  StudentHub
//
//  Created by Fabio Quintanilha on 9/30/19.
//  Copyright © 2019 StudentHub. All rights reserved.
//

import Foundation

struct User {
    private var _id: String = ""
    private var _firstName: String = ""
    private var _lastName: String = ""
    private var _avatarID: String = ""
    private var _major: String = ""
    private var _college: String = ""
    private var _campus: String = ""
    private var _created_at: Date = Date()
    private var _email: String = ""
    private var _isEmailVerified: Bool = false
    private var _isActive: Bool = true
    private var _isSharingLocation: Bool = false
    private var _lastSeenAt: Date = Date()
    private var _deviceID: String = ""
    private var _deviceType: String = ""
    private var _groupsInviting: [String] = [String]()
    private var _lastMessageIndexSeenOnGroups = [String: Int]()
    
    public var activeGroupChat: GroupChat!
    
    var id: String {
        get {
            return self._id
        }
    }
    
    var firstName: String {
        get {
            return self._firstName
        }
    }
    
    var lastName: String {
        get {
            return self._lastName
        }
    }
    
    var fullName: String {
        get {
            return "\(self._firstName) \(self._lastName)"
        }
    }
    
    var avatarID: String {
        get {
            return self._avatarID
        }
    }
    
    var major: String {
        get {
            return self._major
        }
    }
    
    var college: String {
        get {
            return self._college
        }
    }
    
    var campus: String {
        get {
            return self._campus
        }
    }
    
    var created_at: Date {
        get {
            return self._created_at
        }
    }
    
    var email: String {
        get {
            return self._email
        }
    }
    
    var isEmailVerified: Bool {
        get {
            return self._isEmailVerified
        }
    }
    
    var isActive: Bool {
        get {
            return self._isActive
        }
    }
    
    var isSharingLocation: Bool {
        get {
            return self._isSharingLocation
        }
    }
    
    var lastSeen: Date {
        get {
            return self._lastSeenAt
        }
    }
    
    var deviceID: String {
        get {
            return self._deviceID
        }
    }
    
    var deviceType: String {
        get {
            return self._deviceType
        }
    }
    
    var groupsInviting: [String] {
        get {
            return self._groupsInviting
        }
        set {
            self._groupsInviting = newValue
        }
    }
    
    var lastMessageIndexSeenOnGroups: [String: Int] {
        get {
            return _lastMessageIndexSeenOnGroups
        }
        set {
            self._lastMessageIndexSeenOnGroups = newValue
        }
    }
    
    
    init (){}
    
    mutating func initializeFromJson(json: [String: Any]) {
        self._id = json["id"] as? String ?? ""
        self._firstName = json["first_name"] as? String ?? ""
        self._lastName = json["last_name"] as? String ?? ""
        self._avatarID = json["avatar_id"] as? String ?? ""
        self._major = json["major"] as? String ?? ""
        self._college = json["college"] as? String ?? ""
        self._campus = json["campus"] as? String ?? ""
        self._created_at = json["created_at"] as? Date ?? Date()
        self._email = json["email"] as? String ?? ""
        self._isEmailVerified = json["is_email_verified"] as? Bool ?? false
        self._isActive = json["is_active"] as? Bool ?? false
        self._isSharingLocation = json["is_sharing_location"] as? Bool ?? false
        self._lastSeenAt = json["last_seen_at"] as? Date ?? Date()
        self._deviceID = json["device_id"] as? String ?? ""
        self._deviceType = json["device_type"] as? String ?? ""
        self._groupsInviting = json["groups_inviting"] as? [String] ?? [String]()
        self._lastMessageIndexSeenOnGroups = json["last_message_index_seen_on_group"] as? [String : Int] ?? [String : Int]()
    }
    
    mutating func setNewUser(id: String, email: String) {
        self._id = id
        self._email = email
        self._isEmailVerified = false
        self._created_at = Date()
        self._isActive = true
        
    }
    
    mutating func updateUserProfile(firstName: String, lastName: String, avatarID: String, major: String, campus: String) {
        self._college = "Valencia College"
        self._major = major
        self._campus = campus
        self._firstName = firstName
        self._lastName = lastName
        self._avatarID = avatarID
    }
    
    var dataJson : [String: Any]{
        return ["id" : self._id,
                "first_name" : self._firstName,
                "last_name" : self._lastName,
                "avatar_id" : self._avatarID,
                "major" : self._major,
                "college" : self._college,
                "campus" : self._campus,
                "created_at" : self._created_at,
                "email": self._email,
                "is_email_verified" : self._isEmailVerified,
                "is_active" : self._isActive,
                "is_sharing_location" : self._isSharingLocation,
                "last_seen_at" : self._lastSeenAt,
                "device_id" : self._deviceID,
                "device_type" : self._deviceType,
                "groups_inviting" : self._groupsInviting,
                "last_message_index_seen_on_group" : self._lastMessageIndexSeenOnGroups]
    }
    
}

var CurrentUser: User!
