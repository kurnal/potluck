//
//  FirebaseStorageManager.swift
//  
//
//  Created by Sierra Seabrease on 5/1/21.
//

import UIKit
import FirebaseStorage

//Upload image to storage, citation on about page
class FirebaseStorageManager {
    
    public func uploadImageData(data: Data, serverFileName: String, completionHandler: @escaping (_ isSuccess: Bool, _ url: String?) -> Void) {
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        // Create a reference to the file you want to upload
        let directory = "uploads/"
        let fileRef = storageRef.child(directory + serverFileName)
        
        _ = fileRef.putData(data, metadata: nil) { metadata, error in
            fileRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    // Uh-oh, an error occurred!
                    completionHandler(false, nil)
                    return
                }
                // File Uploaded Successfully
                completionHandler(true, downloadURL.absoluteString)
            }
        }
    }

}
