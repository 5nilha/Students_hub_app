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
        self.reference(collectionReference: .chat_groups).addSnapshotListener { (snapshot, error) in
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
    
    func appendMember(groupID: String, memberID: String) {
        self.reference(collectionReference: .chat_groups).document(groupID).setData(["group_members" :  FieldValue.arrayUnion([memberID])], merge: true)
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
