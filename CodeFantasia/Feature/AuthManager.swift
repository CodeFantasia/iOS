
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

let DB_REF = Database.database().reference()
let REF_USERS = DB_REF.child("users")

//let STORAGE_REF = Storage.storage().reference()
//let STORAGE_PROFILE_IMAGES = STORAGE_REF.child("profile_images")

struct AuthManager {
    
    static let shared = AuthManager()
    
    func registerUser(crudentials: UserAuth, completion: @escaping(Error?, DatabaseReference) -> Void) {
        let email = crudentials.email.lowercased()
        let password = crudentials.password
        
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                completion(error, DatabaseReference())
            } else if let authResult = authResult {
                let uid = authResult.user.uid
                DB_REF.child("emails").child(uid).setValue(["email": email], withCompletionBlock: { (error, ref) in
                    completion(error, ref)
                })
            } else {
                let unexpectedError = NSError(domain: "YourDomain", code: 500, userInfo: nil)
                completion(unexpectedError, DatabaseReference())
            }
        }
    }

    func checkDuplicate(email: String, completion: @escaping (Bool) -> Void) {
        DB_REF.child("emails").observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.exists() {
                if let emailsSnapshot = snapshot.children.allObjects as? [DataSnapshot] {
                    for emailSnapshot in emailsSnapshot {
                        if let emailDict = emailSnapshot.value as? [String: Any],
                           let storedEmail = emailDict["email"] as? String {
                            if storedEmail == email {
                                completion(false)
                                return
                            }
                        }
                    }
                }
                completion(true)
            } else {
                completion(true)
            }
        }
    }
    func deleteAccountWithEmail(_ uid: String, completion: @escaping (Error?) -> Void) {
        if let uid = Auth.auth().currentUser?.uid {
            let emailsRef = DB_REF.child("emails").child(uid)
            
            emailsRef.observeSingleEvent(of: .value) { (snapshot) in
                guard snapshot.exists() else {
                    completion(nil)
                    return
                }
                emailsRef.removeValue { (error, _) in
                    completion(error)
                }
            }
        } else {
            completion(nil)
        }
    }
    
    func logUserIn(withEmail email: String, password: String, completion: @escaping(AuthDataResult?, Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
}
