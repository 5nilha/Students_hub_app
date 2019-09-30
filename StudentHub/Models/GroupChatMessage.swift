//
//  GroupChatMessage.swift
//  StudentHub
//
//  Created by Fabio Quintanilha on 9/28/19.
//  Copyright © 2019 StudentHub. All rights reserved.
//

import Foundation

enum AttachmentTypes: String {
    case none = "none"
    case file = "file"
    case image = "image"
    case link = "link"
}


struct GroupChatMessage {
    private var _id: String = ""
    private var _messageString: String = ""
    private var _attachmentURL: String = ""
    private var _attachmentType: AttachmentTypes = .none
    private var _hasAttachment: Bool = false
    private var _groupId: String = ""
    private var _isIncoming: Bool = true
    private var _date: Date = Date()
    private var _senderID: String = ""
    private var _senderName: String = ""
    private var _senderAvatarID: String = ""

    //GETTERS
    
    var id: String {
        get {
            return self._id
        }
    }
    
    var messageString: String {
        get {
            return self._messageString
        }
    }
    
    var attachmentURL: String {
        get {
            return self._attachmentURL
        }
    }
    
    var attachmentType: AttachmentTypes {
        get {
            return self._attachmentType
        }
    }
    
    var hasAttachment: Bool {
        get {
            return self._hasAttachment
        }
    }
    
    var groupId: String {
        get {
            return self._groupId
        }
    }
    
    var isIncoming: Bool {
        get {
            return self._isIncoming
        }
    }
    
    var date: Date {
        get {
            return self._date
        }
    }
    
    var senderID: String {
        get {
            return _senderID
        }
    }
    
    var senderName: String {
        get {
            return _senderName
        }
    }
    
    
    var senderAvatarID: String {
        get {
            return _senderAvatarID
        }
    }
    
    
    init(senderID: String, senderName: String, senderAvatarID: String, messageString: String, groupId: String) {
        self._senderID = senderID
        self._senderName = senderName
        self._senderAvatarID = senderAvatarID
        self._messageString = messageString
        self._groupId = groupId
        self._date = Date()
        self._isIncoming = false
    }
    
    init(id: String, date: Date, isIncoming: Bool,  senderID: String, senderName: String, senderAvatarID: String, messageString: String, groupId: String, hasAttachment: Bool, attachmentURL: String, attachmentType: AttachmentTypes) {
        self._id = id
        self._date = date
        self._isIncoming = isIncoming
        self._senderID = senderID
        self._senderName = senderName
        self._senderAvatarID = senderAvatarID
        self._messageString = messageString
        self._groupId = groupId
        self._hasAttachment = hasAttachment
        self._attachmentURL = attachmentURL
        self._attachmentType = attachmentType 
    }
    
    mutating func attachLink(linkURL: String) {
        self._hasAttachment = true
        self._attachmentURL = linkURL
        self._attachmentType = .link
    }
    
    mutating func attachImage(image: UIImage) {
        
        //TODO: Should save the image to storage
        let imageURL = ""
        self._hasAttachment = true
        self._attachmentURL = imageURL
        self._attachmentType = .image
    }
    
    
    
    private func jsonData() -> [String : Any] {
        return ["id" : self._id,
                "message_string" : self._messageString,
                "attachment_url" : self._attachmentURL,
                "attachment_type" : self._attachmentType,
                "has_attachment" : self._hasAttachment,
                "sender_id" : self._senderID,
                "sender_name" : self._senderName,
                "sender_avatar_id" : self.senderAvatarID,
                "group_id" : self._groupId,
                "is_incoming" : self._isIncoming,
                "date" : self._date]
    }
    
    
}
