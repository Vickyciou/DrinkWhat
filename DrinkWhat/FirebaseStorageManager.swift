//
//  FirestorageManager.swift
//  DrinkWhat
//
//  Created by Vickyciou on 2023/7/7.
//

import Foundation
import FirebaseStorage

class FirebaseStorageManager {

    func uploadPhoto(image: UIImage, completion: @escaping (Result<URL, Error>) -> Void) {

        let fileReference = Storage.storage().reference().child(UUID().uuidString + ".jpg")
        if let data = image.jpegData(compressionQuality: 0.9) {

            fileReference.putData(data, metadata: nil) { result in
                switch result {
                case .success:
                    fileReference.downloadURL(completion: completion)
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}
