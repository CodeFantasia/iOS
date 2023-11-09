//
//  UserRepository.swift
//  CodeFantasia
//
//  Created by Hyunwoo Lee on 2023/10/24.
//

import Foundation
import RxSwift
import FirebaseAuth

protocol UserRepositoryProtocol {
    func read(userId: String) -> Single<UserProfile>
    func readAll() -> Single<[UserProfile]>
    func create(user: UserProfile)
    func delete(user: UserProfile)
    func `delete`(userId: String)
    func update(user: UserProfile)
}

struct UserRepository: UserRepositoryProtocol {
    
    private enum UserRepositoryError: LocalizedError {
        case dataConvertError
    }
    
    private let firebaseManager: FireBaseManagerProtocol
    private let collectionId: String
    
    init(
        collectionId: String = "User",
        firebaseBaseManager: FireBaseManagerProtocol
    ) {
        self.collectionId = collectionId
        self.firebaseManager = firebaseBaseManager
    }
    
    func read(userId: String) -> Single<UserProfile> {
        return firebaseManager.read(collectionId, userId)
            .map {
                if let userData = $0.toObject(UserProfile.self) {
                    return userData
                } else {
                    throw UserRepositoryError.dataConvertError
                }
            }
    }
    
    func readAll() -> Single<[UserProfile]> {
        return firebaseManager.read(collectionId)
            .map { datas in
                return datas.compactMap { $0.toObject(UserProfile.self) }
            }
    }
    
    func create(user: UserProfile) {
        if let currentUserUID = Auth.auth().currentUser?.uid {
            firebaseManager.create(collectionId, currentUserUID, user)
        } else {
            firebaseManager.create(collectionId, user.userID ?? "", user)
        }
    }
    
    func delete(user: UserProfile) {
        firebaseManager.delete(collectionId, user.userID ?? "")
    }
    
    func `delete`(userId: String) {
        firebaseManager.delete(collectionId, userId)
    }
    
    func update(user: UserProfile) {
        if let currentUserUID = Auth.auth().currentUser?.uid {
            firebaseManager.update(collectionId, currentUserUID, user)
        } else {
            firebaseManager.update(collectionId, user.userID ?? "", user)
        }
    }
}
