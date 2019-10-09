//
//  Feed.swift
//  StudentHub
//
//  Created by Fabio Quintanilha on 10/9/19.
//  Copyright © 2019 StudentHub. All rights reserved.
//

import Foundation

struct Feed {
    private var _id: String = ""
    private var _content: String = ""
    private var _senderID: String = ""
    private var _senderName: String = ""
    private var _senderAvatarID: String = ""
    private var _senderMajor: String = ""
    private var _date: Date = Date()
    private var _isImage: Bool = false
    private var _imagesURL: [String] = [String]()
    private var _images: [UIImage] = [UIImage]()
    
    var content: String {
        get {
            return self._content
        }
    }
    
    var senderID: String {
        get {
            return self._senderID
        }
    }
    
    var senderName: String {
        get {
            return self._senderName
        }
    }
    
    var senderAvatarID: String {
        get {
            return self._senderAvatarID
        }
    }
    
    var senderMajor: String {
        get {
            return self._senderMajor
        }
    }
    
    var date: Date {
        get {
            return self._date
        }
    }
    
    var isImage: Bool {
        get {
            return self._isImage
        }
    }
    
    var imagesURL: [String] {
        get {
            return self._imagesURL
        }
    }
    
    var images: [UIImage] {
        get {
            return self._images
        }
        set {
            self._images = newValue
        }
    }
    
    init (){}
    
    init (content: String, senderID: String, senderName: String, senderAvatarID: String, senderMajor: String, isImage: Bool, images: [UIImage]) {
        self._content = content
        self._senderID = senderID
        self._senderName = senderName
        self._senderAvatarID = senderAvatarID
        self._senderMajor = senderMajor
        self._isImage = isImage
        self._date = Date()
        self._images = images
    }
    
    mutating func initializeFromJSON(json: [String: Any], completion: @escaping ([UIImage]) -> () ) {
        self._id = json["id"] as? String ?? ""
        self._content = json["content"] as? String ?? ""
        self._senderID = json["sender_id"] as? String ?? ""
        self._senderName = json["sender_name"] as? String ?? ""
        self._senderAvatarID = json["sender_avatar_id"] as? String ?? ""
        self._senderMajor = json["sender_major"] as? String ?? ""
        self._isImage = json["is_image"] as? Bool ?? false
        self._date = json["date"] as? Date ?? Date()
        self._imagesURL = json["images_url"] as? [String] ?? [String]()
        
        
        DatabaseStorage.service.loadImagesFromStorage(urls: _imagesURL, handler: { (images) in
            completion(images)
        })
    }
    
    var dataJson: [String : Any] {
        return ["id" : self._id,
                "content" : self._content,
                "sender_id" : self._senderID,
                "sender_name" : self._senderName,
                "sender_avatar_id" : self._senderAvatarID,
                "sender_major" : self._senderMajor,
                "date" : self.date,
                "is_image" : _isImage,
                "images_url" : _imagesURL]
    }
    
    
}
