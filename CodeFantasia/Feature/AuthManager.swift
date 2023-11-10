
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
    
    func logUserIn(withEmail email: String, password: String, completion: @escaping(AuthDataResult?, Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
}
