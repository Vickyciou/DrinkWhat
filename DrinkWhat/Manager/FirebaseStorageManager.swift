//
//  FirestorageManager.swift
//  DrinkWhat
//
//  Created by Vickyciou on 2023/7/7.
//

import Foundation
import FirebaseStorage

enum UploadError: LocalizedError {
    case dataConversionFailed

    var errorDescription: String? {
        switch self {
        case.dataConversionFailed:
            return "Failed to convert the image to JPEG format binary data."
        }
    }
}

class FirebaseStorageManager {
    func uploadPhoto(image: UIImage) async throws -> URL {
        let fileReference = Storage.storage().reference().child(UUID().uuidString + ".jpg")
        if let data = image.jpegData(compressionQuality: 0.9) {
            fileReference.putData(data, metadata: nil)
            let url = try await fileReference.downloadURL()
            return url
        } else {
            throw UploadError.dataConversionFailed
        }
    }
}
