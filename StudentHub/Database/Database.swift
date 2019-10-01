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

class Database {
    
    private init() {}
    private var db = Firestore.firestore()
    static let service = Database()
    
    var groupsChatListener: ListenerRegistration!
    var membersOnlineListener: ListenerRegistration!
    
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
    func createGroup(image: UIImage, data: [String: Any], completion: @escaping () -> ()) {
        
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
                completion()
            }
        }
    }
    
    func snapshotGroups(completion: @escaping ([GroupChat]) -> ()) {
        groupsChatListener = self.reference(collectionReference: .chat_groups).addSnapshotListener { (snapshot, error) in
            if let error = error {
                print("Error snapshoting Groups -> \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else { return }
            
            var groups = [GroupChat]()
            for document in documents {
                var group = GroupChat()
                group.initializeFromJson(json: document.data(), completion: { (image) in
                    group.groupImage = image
                    groups.append(group)
                    completion(groups)
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
    
    //MARK: ----------- GROUP CHAT DATA -----------------------
    func createGroupChatMessage(groupID: String, data: [String: Any], completion: @escaping () -> ()) {
        
        var documentData = data
        
        let batch = self.db.batch()
        let messageRef = self.reference(collectionReference: .chat_groups).document(groupID).collection("messages").document()
        let docID = messageRef.documentID
        documentData["id"] = docID
        batch.setData(documentData, forDocument: messageRef, merge: true)
        
        
        // Commit the batch
        batch.commit() { err in
            if let err = err {
                print("Error writing batch \(err)")
            } else {
                print("Batch write succeeded.")
            }
            completion()
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
    
}
