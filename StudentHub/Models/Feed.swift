//
//  Feed.swift
//  StudentHub
//
//  Created by Fabio Quintanilha on 10/9/19.
//  Copyright © 2019 StudentHub. All rights reserved.
//

import Foundation

struct Feed {
    private var _content: String!
    private var _sender_id: String!
    private var _sender_name: String!
    private var _sender_avatar_id: String!
    private var _date: Date!
    private var _isImage: Bool!
    private var _image_url: String!
    
    var content: String {
        get {
            return self._content
        }
    }
    
    var sender_id: String {
        get {
            return self._sender_id
        }
    }
    
    var sender_name: String {
        get {
            return self._sender_name
        }
    }
    
    var sender_avatar_id: String {
        get {
            return self._sender_avatar_id
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
    
    var image_url: String {
        get {
            return self._image_url
        }
    }
    
}
