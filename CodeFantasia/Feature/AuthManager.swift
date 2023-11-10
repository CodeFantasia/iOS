
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
        let email = crudentials.email
        let password = crudentials.password
        
        Auth.auth().createUser(withEmail: email, password: password)
        DB_REF.child("emails").setValue(["email" : email])
    }
    
    func checkDuplicate(email: String, completion: @escaping (Bool) -> Void) {
        DB_REF.child("emails").observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.exists() {
                if let emails = snapshot.value as? [String: Any],
                   let storedEmail = emails["email"] as? String {
                    if storedEmail == email {
                        completion(false)
                    } else {
                        completion(true)
                    }
                } else {
                    completion(true)
                }
            } else {
                completion(true)
            }
        }
    }

    func deleteAccountWithEmail(_ email: String, completion: @escaping (Error?) -> Void) {
        let emailsRef = DB_REF.child("emails")
        emailsRef.observeSingleEvent(of: .value) { (snapshot) in
            guard snapshot.exists(), var emails = snapshot.value as? [String: Any] else {
                completion(nil)
                return
            }

            if let storedEmail = emails["email"] as? String, storedEmail == email {
                emailsRef.removeValue { (error, _) in
                    completion(error)
                }
            } else {
                completion(nil)
            }
        }
    }

    
    func logUserIn(withEmail email: String, password: String, completion: @escaping(AuthDataResult?, Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
}
