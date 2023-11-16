//
//  FirebaseManager.swift
//  CodeFantasia
//
//  Created by hong on 2023/10/19.
//

import Foundation
import RxSwift
import FirebaseStorage
import Firebase

protocol FireBaseManagerProtocol {
    func create<T: Encodable>(_ collectionId: String, _ documentId: String, _ data: T)
    func delete(_ collectionId: String, _ documentId: String)
    func update<T: Encodable>(_ collectionId: String, _ documentId: String, _ data: T)
//    func read(_ collectionId: String, _ documentId: String) -> Single<Data>
    func read(_ collectionId: String, _ documentId: String) -> Observable<Data>
    func `read`(_ collectionId: String) -> Single<[Data]>
    func getFollowingList(_ collectionId: String,_ documentId: String) -> Observable<[String]>
    func getFollowersList(_ collectionId: String,_ documentId: String) -> Observable<[String]>
}

struct FireBaseManager: FireBaseManagerProtocol {
    
    private enum FireBaseManagerError: LocalizedError {
        case dataReadError
        case dataDoesntExist
        case responseDataConvertToDataTypeError
    }
    
    private let db = Firestore.firestore()
    
    private func collectionReference(_ collectionId: String) -> CollectionReference {
        return db.collection(collectionId)
    }
    
    private func documentReference(
        _ collectionId: String,
        _ documentId: String
    ) -> DocumentReference {
        return collectionReference(collectionId).document(documentId)
    }
    
    private func encodableToData<T: Encodable>(_ data: T) -> Data? {
        do {
            return try JSONEncoder().encode(data)
        } catch {
            print(error)
            return nil
        }
    }
    
    private func dataToDictonary(_ data: Data) -> [String: Any]? {
        do {
            return try JSONSerialization.jsonObject(with: data) as? [String: Any]
        } catch {
            print(error)
            return nil
        }
    }
    
    private func dictionaryToData(_ data: [String: Any]) -> Data? {
        do {
            return try JSONSerialization.data(withJSONObject: data)
        } catch {
            print(error)
            return nil
        }
    }
    
    func create<T: Encodable>(
        _ collectionId: String,
        _ documentId: String,
        _ data: T
    ) {
        guard let encodableToDataTypeData = encodableToData(data) else { return }
        guard let dataToDictionaryTypeData = dataToDictonary(encodableToDataTypeData) else { return }
        db.collection(collectionId).document(documentId).setData(dataToDictionaryTypeData)
    }
    
    func delete(
        _ collectionId: String,
        _ documentId: String
    ) {
        db.collection(collectionId).document(documentId).delete()
    }
    
    func update<T: Encodable>(
        _ collectionId: String,
        _ documentId: String,
        _ data: T
    ){
        guard let encodableToDataTypeData = encodableToData(data) else { return }
        guard let dataToDictionaryTypeData = dataToDictonary(encodableToDataTypeData) else { return }
        db.collection(collectionId).document(documentId).updateData(dataToDictionaryTypeData)
    }
    
//    func read(
//        _ collectionId: String,
//        _ documentId: String
//    ) -> Single<Data> {
//        return Single<Data>.create { single in
//            documentReference(collectionId, documentId).getDocument { snapshot, error in
//                print("📡📡📡📡📡📡📡📡📡\n--- FetchedData ---\nPath: \(collectionId)/\(documentId)")
//                if let error {
//                    print(error)
//                    single(.failure(error))
//                } else {
//                    guard let responseData = snapshot?.data() else {
//                        single(.failure(FireBaseManagerError.dataDoesntExist))
//                        return
//                    }
//                    guard let dataTypeData = dictionaryToData(responseData) else {
//                        single(.failure(FireBaseManagerError.responseDataConvertToDataTypeError))
//                        return
//                    }
//                    dump(dataTypeData)
//                    single(.success(dataTypeData))
//                }
//            }
//            return Disposables.create()
//        }
//    }
    func read(
        _ collectionId: String,
        _ documentId: String
    ) -> Observable<Data> {
        return Observable.create { observer -> Disposable in
            let listener = documentReference(collectionId, documentId)
                .addSnapshotListener { snapshot, error in
                    print("📡📡📡📡📡📡📡📡📡\n--- FetchedData ---\nPath: \(collectionId)/\(documentId)")
                    if let error = error {
                        print(error)
                        observer.onError(error)
                    } else {
                        guard let responseData = snapshot?.data() else {
                            observer.onError(FireBaseManagerError.dataDoesntExist)
                            return
                        }
                        guard let dataTypeData = dictionaryToData(responseData) else {
                            observer.onError(FireBaseManagerError.responseDataConvertToDataTypeError)
                            return
                        }
                        dump(dataTypeData)
                        observer.onNext(dataTypeData)
                    }
                }

            // Subscription이 폐기될 때 리스너를 제거하기 위한 Disposable을 반환합니다.
            return Disposables.create {
                listener.remove()
            }
        }
    }
    
    func `read`(
        _ collectionId: String
    ) -> Single<[Data]> {
        return Single<[Data]>.create { single in
            collectionReference(collectionId).getDocuments { snapshot, error in
                print("📡📡📡📡📡📡📡📡📡\n--- FetchedData ---\nPath: \(collectionId)")
                if let error {
                    print(error)
                    single(.failure(error))
                } else {
                    guard let responseData = snapshot?.documents else {
                        single(.failure(FireBaseManagerError.dataDoesntExist))
                        return
                    }
                    let dataTypeDatas = responseData.compactMap({ element in
                        let dataTypeData = dictionaryToData(element.data())
                        return dataTypeData
                    })
                    dump(dataTypeDatas)
                    single(.success(dataTypeDatas))
                }
            }
            return Disposables.create()
        }
    }
    func getFollowingList(_ collectionId: String,_ documentId: String) -> Observable<[String]> {
        return Observable.create { observer -> Disposable in
            let listener = documentReference(collectionId, documentId)
                .addSnapshotListener { snapshot, error in
                    if let error = error {
                        observer.onError(error)
                        return
                    }

                    guard let document = snapshot, document.exists else {
                        observer.onError(NSError(domain: "User not found", code: 404, userInfo: nil))
                        return
                    }
                    let followingList = document.get("following") as? [String] ?? []
                    observer.onNext(followingList)
                    observer.onCompleted()
                }
                return Disposables.create()
            }
        }
    func getFollowersList(_ collectionId: String,_ documentId: String) -> Observable<[String]> {
        return Observable.create { observer -> Disposable in
            let listener = documentReference(collectionId, documentId)
                .addSnapshotListener { snapshot, error in
                    if let error = error {
                        observer.onError(error)
                        return
                    }

                    guard let document = snapshot, document.exists else {
                        observer.onError(NSError(domain: "User not found", code: 404, userInfo: nil))
                        return
                    }
                    let followerList = document.get("followers") as? [String] ?? []
                    observer.onNext(followerList)
                    observer.onCompleted()
                }
                return Disposables.create()
            }
        }
  }

