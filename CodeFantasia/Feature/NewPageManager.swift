//
//  NewPageManager.swift
//  CodeFantasia
//
//  Created by t2023-m0049 on 2023/11/04.
//

//import Firebase
//import FirebaseAuth
//import FirebaseDatabase
//import FirebaseStorage
//
//let DB_REF = Database.database().reference()
//let REF_USERS = DB_REF.child("users")
//
//let STORAGE_REF = Storage.storage().reference()
//let STORAGE_PROFILE_IMAGES = STORAGE_REF.child("profile_images")
//
//struct AuthManager {
//
//    static let shared = AuthManager()
//
//    func registerUser(crudentials: UserAuth, completion: @escaping(Error?, DatabaseReference) -> Void) {
//        let email = crudentials.email
//        let password = crudentials.password
//        let name = crudentials.name
//
//        guard let imageData = crudentials.profileImage.jpegData(compressionQuality: 0.3) else { return }
//        let filename = NSUUID().uuidString
//        let storageRef = STORAGE_PROFILE_IMAGES.child(filename)
//
//        storageRef.putData(imageData) { (meta, error) in
//            storageRef.downloadURL { (url, error) in
//                guard let profileImageUrl = url?.absoluteString else { return }
//
//                Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
//                    if let error = error {
//                        print("계정 등록 에러: \(error.localizedDescription)")
//                        return
//                    }
//
//                    guard let uid = result?.user.uid else { return }
//
//                    let values = ["email" : email,
//                                  "name" : name,
//                                  "profileImageUrl" : profileImageUrl]
//
//                    REF_USERS.child(uid).updateChildValues(values, withCompletionBlock: completion)
//                }
//
//            }
//        }
//    }
//
//    func logUserIn(withEmail email: String, password: String, completion: @escaping(AuthDataResult?, Error?) -> Void) {
//        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
//    }
//
//}
