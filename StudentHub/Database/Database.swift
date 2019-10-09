//
//  Database.swift
//  StudentHub
//
//  Created by Fabio Quintanilha on 9/30/19.
//  Copyright © 2019 StudentHub. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore
import SCLAlertView

class Database: AppConfig {
    
    private override init() {}
    private var db = Firestore.firestore()
    static let service = Database()
    
    var groupsChatListener: ListenerRegistration!
    var membersOnlineListener: ListenerRegistration!
    var userInvitingsListener: ListenerRegistration!
    var lastMessageSeenIndexesListener: ListenerRegistration!
    var chatMessagesListener: ListenerRegistration!
    
    func reference(collectionReference: DataCollectionReference) -> CollectionReference {
        return db.collection(collectionReference.rawValue)
    }
    
    
    //MARK: ----------- USER DATA -----------------------
    func createUser(user_id: String, data: [String: Any], completion: @escaping (Error?)-> ()) {
        reference(collectionReference: .users).document(user_id).setData(data, merge: true, completion: { (error) in
            completion(error)
        })
    }
    
    func updateUser(user_id: String, data: [String: Any]) {
        reference(collectionReference: .users).document(user_id).setData(data, merge: true)
    }
    
    func getUser(user_id: String, completion: @escaping (User) -> ()) {
        reference(collectionReference: .users).document(user_id).getDocument { (query, error) in
            if let error = error {
                print("Error getting user-> \(error.localizedDescription)")
                return
            }
            guard let documentData = query?.data() else { return }
            
            var user = User()
            user.initializeFromJson(json: documentData)
            completion(user)
        }
    }
    
    //MARK: ----------- GROUPS DATA -----------------------
    func createGroup(image: UIImage, data: [String: Any]) {
        
        var documentData = data
        
        DatabaseStorage.service.storingGroupImage(groupIdentifier: documentData["public_identifier"] as! String, image: image) { (url) in
            documentData["group_image_url"] = url
            
            let batch = self.db.batch()
            
            let groupRef = self.reference(collectionReference: .chat_groups).document()
            let docID = groupRef.documentID
            documentData["id"] = docID
            batch.setData(documentData, forDocument: groupRef, merge: true)
            
            // Commit the batch
            batch.commit() { err in
                if let err = err {
                    print("Error writing batch \(err)")
                } else {
                    print("Batch write succeeded.")
                }
            }
        }
    }
    
    func snapshotGroups(completion: @escaping ([String : [GroupChat]]) -> ()) {
        groupsChatListener = self.reference(collectionReference: .chat_groups).order(by: "group_name").addSnapshotListener { (snapshot, error) in
            if let error = error {
                print("Error snapshoting Groups -> \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else { return }
            
            var groups = [GroupChat]()
            var myActiveGroups = [GroupChat]()
            let count = documents.count
            print("COUNT before \(count)")
            
            var i = 0
            for document in documents {
                var group = GroupChat()
                group.initializeFromJson(json: document.data(), completion: { (image) in
                    group.groupImage = image
                    groups.append(group)
                    if group.groupMembersID.contains(CurrentUser.id) {
                        myActiveGroups.append(group)
                    }
                    
                    i += 1
                    
                    print("COUNT after \(i)")
                    if count == i {
                        var groupsDic = [String : [GroupChat]]()
                        groupsDic["myActiveGroups"] = myActiveGroups
                        groupsDic["allGroups"] = groups
                        
                        completion(groupsDic)
                    }
                })
            }
            
        }
    }
    
    func removesnapshotGroupsListener() {
        if groupsChatListener != nil {
            groupsChatListener.remove()
        }
    }
    
    func appendMember(groupID: String, memberID: String, data: [String: Any]) {
        
        let batch = self.db.batch()
        
        let groupMembersRef = self.reference(collectionReference: .chat_groups).document(groupID)
        batch.setData(["group_members" :  FieldValue.arrayUnion([data])], forDocument: groupMembersRef, merge: true)
        
        let membersIDRef = self.reference(collectionReference: .chat_groups).document(groupID)
        batch.setData(["group_members_id" :  FieldValue.arrayUnion([memberID])], forDocument: membersIDRef, merge: true)
        
        // Commit the batch
        batch.commit() { err in
            if let err = err {
                print("Error writing batch \(err)")
            } else {
                print("Batch write succeeded.")
            }
        }
    }
    
    func deleteMemberID(groupID: String, memberID: String) {
        let batch = self.db.batch()
        
        let membersIDRef = self.reference(collectionReference: .chat_groups).document(groupID)
        batch.setData(["group_members_id" :  FieldValue.arrayRemove([memberID])], forDocument: membersIDRef, merge: true)
        
        // Commit the batch
        batch.commit() { err in
            if let err = err {
                print("Error writing batch \(err)")
            } else {
                print("Batch write succeeded.")
            }
        }
    }
        
    
    func updateMembers(groupID: String, membersArray: [[String : Any]]) {
        self.reference(collectionReference: .chat_groups).document(groupID).updateData(["group_members": membersArray])
    }
    
    func appendMemberOnline(groupID: String, memberID: String) {
        self.reference(collectionReference: .chat_groups).document(groupID).setData(["members_online" :  FieldValue.arrayUnion([memberID])], merge: true)
    }
    
    func removeMemberOnline(groupID: String, memberID: String) {
        self.reference(collectionReference: .chat_groups).document(groupID).setData(["members_online" :  FieldValue.arrayRemove([memberID])], merge: true)
    }
    
    func snapshotMemberOnline(groupID: String, completion: @escaping ([String]) -> ()) {
        membersOnlineListener = self.reference(collectionReference: .chat_groups).document(groupID).addSnapshotListener { (snapshot, error) in
            if let error = error {
                print("Error snapshoting Groups -> \(error.localizedDescription)")
                return
            }
            
            guard let documentData = snapshot?.data() else { return }
            let membersOnline = documentData["members_online"] as? [String] ?? [String]()
            completion(membersOnline)
        }
    }
    
    func removesMembersOnlineListener() {
        if self.membersOnlineListener != nil {
            membersOnlineListener.remove()
        }
    }
    
    func inviteUserToGroup(email: String, groupID: String, groupIdentifier: String) {
        
        self.reference(collectionReference: .users).whereField("email", isEqualTo: email).getDocuments { (query, error) in
            if error != nil {
                self.ErrorAlert(title: "Error", message: "User not found.")
                return
            }
            
            guard let documents = query?.documents else { return }
            
            print("Getting user to invite \(documents.count)")
            
            if documents.count >= 1 {
                let documentData = documents[0].data()
                var user = User()
                user.initializeFromJson(json: documentData)
                
                let batch = self.db.batch()
                print("Getting user to invite \(user.id)")
                let userIDRef = self.reference(collectionReference: .users).document(user.id)
                batch.setData(["groups_inviting" :  FieldValue.arrayUnion([groupIdentifier])], forDocument: userIDRef, merge: true)
                
                let invitingRef = self.reference(collectionReference: .chat_groups).document(groupID)
                batch.setData(["inviting_sent_to" :  FieldValue.arrayUnion([user.id])], forDocument: invitingRef, merge: true)
                
                // Commit the batch
                batch.commit() { err in
                    if let err = err {
                        print("Error writing batch \(err)")
                    } else {
                        print("Batch write succeeded.")
                    }
                }
            }
        }
    }
    
    func snapshotUserInvitings(userID: String, completion: @escaping ([String]) -> ()) {
        userInvitingsListener = self.reference(collectionReference: .users).document(userID).addSnapshotListener { (snapshot, error) in
            if let error = error {
                print("Error snapshoting Groups -> \(error.localizedDescription)")
                return
            }
            
            guard let documentData = snapshot?.data() else { return }
            let invitings = documentData["groups_inviting"] as? [String] ?? [String]()
            completion(invitings)
        }
    }
    
    func removesUserInvitingsListener() {
        if self.userInvitingsListener != nil {
            userInvitingsListener.remove()
        }
    }
    
    func acceptGroupInviting(userID: String, userName: String, groupIdentifier: String) {
        self.reference(collectionReference: .chat_groups).whereField("public_identifier", isEqualTo: groupIdentifier).getDocuments { (query, error) in
            if let error = error {
                print("Error getting Groups -> \(error.localizedDescription)")
                return
            }
            
            guard let documents = query?.documents else { return }
            
            if documents.count > 0 {
                let document = documents[0]
                let documentData = document.data()
                let groupID = documentData["id"] as? String ?? ""
                if !groupID.isEmpty {
                    
                    let batch = self.db.batch()
                    
                    let userRef = self.reference(collectionReference: .users).document(userID)
                    batch.setData(["groups_inviting" :  FieldValue.arrayRemove([groupIdentifier]),
                                   "last_message_index_seen_on_group" : [groupID : 0]], forDocument: userRef, merge: true)
                    
                    let grouprRef = self.reference(collectionReference: .chat_groups).document(groupID)
                    batch.setData(["inviting_sent_to" :  FieldValue.arrayRemove([userID]),
                                   "group_members" : FieldValue.arrayUnion([["id" : userID, "name": userName]]),
                                   "group_members_id" : FieldValue.arrayUnion([userID])], forDocument: grouprRef, merge: true)
                    
                    
                    // Commit the batch
                    batch.commit() { err in
                        if let err = err {
                            print("Error writing batch \(err)")
                        } else {
                            print("Batch write succeeded.")
                        }
                    }
                }
            }
        }
    }
    
    func rejectGroupInviting(userID: String, groupIdentifier: String) {
        self.reference(collectionReference: .chat_groups).whereField("public_identifier", isEqualTo: groupIdentifier).getDocuments { (query, error) in
            if let error = error {
                print("Error getting Groups -> \(error.localizedDescription)")
                return
            }
            
            guard let documents = query?.documents else { return }
            
            if documents.count > 0 {
                let document = documents[0]
                let documentData = document.data()
                let groupID = documentData["id"] as? String ?? ""
                if !groupID.isEmpty {
                    
                    let batch = self.db.batch()
                    
                    let userRef = self.reference(collectionReference: .users).document(userID)
                    batch.setData(["groups_inviting" :  FieldValue.arrayRemove([groupIdentifier])], forDocument: userRef, merge: true)
                    
                    let grouprRef = self.reference(collectionReference: .chat_groups).document(groupID)
                    batch.setData(["inviting_sent_to" :  FieldValue.arrayRemove([userID])], forDocument: grouprRef, merge: true)
                    
                    
                    // Commit the batch
                    batch.commit() { err in
                        if let err = err {
                            print("Error writing batch \(err)")
                        } else {
                            print("Batch write succeeded.")
                        }
                    }
                }
            }
        }
    }
    
    
    //MARK: ----------- GROUP CHAT DATA -----------------------
    func createGroupChatMessage(groupID: String, data: [String: Any]) {
        
        var documentData = data
        
        let batch = self.db.batch()
        let messageRef = self.reference(collectionReference: .chat_groups).document(groupID).collection("messages").document()
        let docID = messageRef.documentID
        documentData["id"] = docID
        batch.setData(documentData, forDocument: messageRef, merge: true)
        
        
        let indexRef = self.reference(collectionReference: .chat_groups).document(groupID).collection("messages").document(docID)
        batch.setData(["index" : FieldValue.increment(Int64(1))], forDocument: indexRef, merge: true)
        
        let groupRef = self.reference(collectionReference: .chat_groups).document(groupID)
        batch.setData(["number_of_messages" : FieldValue.increment(Int64(1))], forDocument: groupRef, merge: true)
        
        // Commit the batch
        batch.commit() { err in
            if let err = err {
                print("Error writing batch \(err)")
            } else {
                print("Batch write succeeded.")
            }
        }
    }
    
    func snapshotChatMessages(groupID: String, completion: @escaping ([GroupChatMessage]) -> ()) {
        self.reference(collectionReference: .chat_groups).document(groupID).collection("messages").order(by: "date", descending: false).addSnapshotListener { (snapshot, error) in
            if let error = error {
                print("Error snapshoting Groups -> \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else { return }
            
            var messages = [GroupChatMessage]()
            for document in documents {
                var message = GroupChatMessage()
                message.initializeFromJson(json: document.data())
                messages.append(message)
            }
            completion(messages)
        }
    }
    
    func updateLastMessageSeenByUser(userID: String, groupID: String, messageIndex: Int) {
        let batch = self.db.batch()
        
        let messageIndexRef = self.reference(collectionReference: .users).document(userID)
        batch.setData(["last_message_index_seen_on_group" : [groupID: messageIndex]], forDocument: messageIndexRef, merge: true)
        
        // Commit the batch
        batch.commit() { err in
            if let err = err {
                print("Error writing batch \(err)")
            } else {
                print("Batch write succeeded.")
            }
        }
    }
    
    func snapshotLastMessageSeenByUser(userID: String, completion: @escaping ([String: Int]) -> ()) {
        lastMessageSeenIndexesListener = self.reference(collectionReference: .users).document(userID).addSnapshotListener { (snapshot, error) in
            if let error = error {
                print("Error snapshoting Groups -> \(error.localizedDescription)")
                return
            }
            
            guard let documentData = snapshot?.data() else { return }
            let lastMessageSeenIndexes = documentData["last_message_index_seen_on_group"] as? [String : Int] ?? [String: Int]()
            completion(lastMessageSeenIndexes)
        }
    }
    
    func removesLastMessageSeenIndexesListenerListener() {
        if self.lastMessageSeenIndexesListener != nil {
            lastMessageSeenIndexesListener.remove()
        }
    }
    
    
    //MARK: ----------- FEEDS DATA -----------------------
    
    func createFeed(images: [UIImage], data: [String: Any]) {
        var documentData = data
        
        let batch = self.db.batch()
        
        let feedRef = self.reference(collectionReference: .feeds).document()
        let docID = feedRef.documentID
        documentData["id"] = docID
        
    
        DatabaseStorage.service.storingFeedImages(feed_id: docID, images: images) { (URLs) in
            documentData["images_url"] = URLs
            batch.setData(documentData, forDocument: feedRef, merge: true)
            
            // Commit the batch
            batch.commit() { err in
                if let err = err {
                    print("Error writing batch \(err)")
                } else {
                    print("Batch write succeeded.")
                }
            }
        }
    }
    
    func snapshotFeeds(completion: @escaping ([Feed]) -> ()) {
        self.reference(collectionReference: .feeds).order(by: "date", descending: false).addSnapshotListener { (snapshot, error) in
            if let error = error {
                print("Error snapshoting Feeds -> \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else { return }
            
            var feeds = [Feed]()
            
            for document in documents {
                var feed = Feed()
                feed.initializeFromJSON(json: document.data()) { (images) in
                    feed.images = images
                    feeds.append(feed)
                    completion(feeds)
                }
            }
            
        }
    }
    
}
