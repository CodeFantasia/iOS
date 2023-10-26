//
//  ImageStorageManager.swift
//  CodeFantasia
//
//  Created by hong on 2023/10/26.
//

import Foundation
import RxSwift
import FirebaseStorage

protocol ImageStorageManagerProtocol {
    func upload(imageData: Data, path: String?) -> Single<String>
}

struct ImageStorageManager: ImageStorageManagerProtocol {
    
    private let storageRef = Storage.storage().reference()
    
    private enum ImageStorageManagerError: LocalizedError {
        case dataUploadFailed
        case urlFetchFailed
    }
    
    func upload(imageData: Data, path: String?) -> Single<String> {
        return Single<String>.create { single in
            let imageRef = storageRef.child(path ?? UUID().uuidString)
            imageRef.putData(imageData) { metadata, error in
                guard metadata != nil,
                   error == nil else {
                    single(.failure(ImageStorageManagerError.dataUploadFailed))
                    return
                }
                imageRef.downloadURL { url, error in
                    guard let url,
                       error == nil else {
                        single(.failure(ImageStorageManagerError.urlFetchFailed))
                        return
                    }
                    single(.success(url.absoluteString))
                }
            }
            return Disposables.create()
        }
    }
}
