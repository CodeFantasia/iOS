//
//  ImageStorageManager.swift
//  CodeFantasia
//
//  Created by hong on 2023/10/26.
//

import Foundation
import RxSwift
import FirebaseStorage
import FirebaseDatabase

protocol ImageStorageManagerProtocol {
    func upload(imageData: Data, path: String?) -> Single<String>
}

//struct ImageStorageManager: ImageStorageManagerProtocol {
//
//    private let storageRef = Storage.storage().reference()
//
//    private enum ImageStorageManagerError: LocalizedError {
//        case dataUploadFailed
//        case urlFetchFailed
//    }
//
//    func upload(imageData: Data, path: String?) -> Single<String> {
//        return Single<String>.create { single in
//            let imageRef = storageRef.child(path ?? UUID().uuidString)
//            imageRef.putData(imageData) { metadata, error in
//                guard metadata != nil,
//                   error == nil else {
//                    single(.failure(ImageStorageManagerError.dataUploadFailed))
//                    return
//                }
//                imageRef.downloadURL { url, error in
//                    guard let url,
//                       error == nil else {
//                        single(.failure(ImageStorageManagerError.urlFetchFailed))
//                        return
//                    }
//                    single(.success(url.absoluteString))
//                }
//            }
//            return Disposables.create()
//        }
//    }
//}


struct ImageStorageManager {

    func upload(imageData: Data, path: String, completion: @escaping (String?) -> Void) {
        
        let storageRef = Storage.storage().reference().child(path)

        storageRef.putData(imageData) { (meta, error) in
            storageRef.downloadURL { (url, error) in
                guard let profileImageUrl = url?.absoluteString, error == nil else {
                    print("URL 다운로드 실패: \(error?.localizedDescription ?? "알 수 없는 오류")")
                    completion(nil)
                    return
                }

                completion(profileImageUrl)
            }
        }
    }

}

//storageRef.putData(imageData) { (meta, error) in
//    storageRef.downloadURL { (url, error) in
//        guard let profileImageUrl = url?.absoluteString else { return }
//
//        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
//            if let error = error {
//                print("계정 등록 에러: \(error.localizedDescription)")
//                return
//            }
//
//            guard let uid = result?.user.uid else { return }
//
//            let values = ["email" : email,
//                          "name" : name,
//                          "profileImageUrl" : profileImageUrl]
//
//            REF_USERS.child(uid).updateChildValues(values, withCompletionBlock: completion)
//        }
//
//    }
//}
