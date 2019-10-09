//
//  Storage.swift
//  StudentHub
//
//  Created by Fabio Quintanilha on 9/30/19.
//  Copyright © 2019 StudentHub. All rights reserved.
//

import Foundation
import FirebaseFirestore
import Firebase
import FirebaseStorage

class DatabaseStorage {
    
    private init () {}
    static let service = DatabaseStorage()
    
    private func reference() -> StorageReference {
        let storageRef = Storage.storage().reference()
        return storageRef
    }
    
    func loadImageFromStorage(url: String, handler: @escaping (UIImage) -> ()) {
        let storageRef = Storage.storage().reference(forURL: url)
        storageRef.downloadURL(completion: { (url, error) in
            if url != nil {
                let data = try? Data(contentsOf: url!)
                let image = UIImage(data: data! as Data)
                handler(image!)
            }
        })
    }
    
    func storingGroupImage(groupIdentifier: String, image: UIImage, completion: @escaping (String) -> ()) {
        
        
        let metaData = StorageMetadata()
        guard let imageData = image.jpegData(compressionQuality: 0.05) else { return }
        metaData.contentType = "image/jpg"
        
      
        let storageReference: StorageReference = reference().child("Groups_image").child(groupIdentifier).child("image/\(Date().timeIntervalSince1970)")
        
        let uploadTask = storageReference.putData(imageData, metadata: metaData) { (metaData, error) in
            
            storageReference.downloadURL(completion: { (url, error) in
                guard let downloadURL = url else {
                    print("DEVELOPER ERROR Storing image: \(String(describing: error?.localizedDescription))")
                    return
                }
                completion(downloadURL.absoluteString)
            })
            
        }
        
        uploadTask.observe(.success) { snapshot in
            // Upload completed successfully
            print("Upload completed successfully")
        }
        
        uploadTask.observe(.failure) { snapshot in
            if let error = snapshot.error as NSError? {
                switch (StorageErrorCode(rawValue: error.code)!) {
                case .objectNotFound:
                    // File doesn't exist
                    print("File does not exist")
                    break
                case .unauthorized:
                    // User doesn't have permission to access file
                    print("File does not exist")
                    break
                case .cancelled:
                    // User canceled the upload
                    print("upload cancelled")
                    break
                case .unknown:
                    print("Unknown Error")
                    break
                default:
                    // A separate error occurred. This is a good place to retry the upload.
                    break
                }
            }
        }
    }
}
