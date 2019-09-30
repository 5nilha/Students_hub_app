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
    private var _isActive: Bool = true
    private var _isSharingLocation: Bool = false
    private var _lastSeenAt: Date = Date()
    private var _deviceID: String = ""
    private var _deviceType: String = ""
    
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
    
}

var CurrentUser: User!
