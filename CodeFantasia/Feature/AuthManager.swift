
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
    
    func checkDuplicateUser(email: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().fetchSignInMethods(forEmail: email) { (signInMethods, error) in
            print("SignInMethods: \(signInMethods)")
        }
    }
    
//    func registerUser(crudentials: UserAuth) {
//        let email = crudentials.email
//        let password = crudentials.password
//        let name = crudentials.name
//
//        Auth.auth().createUser(withEmail: email, password: password)
//        DB_REF.child("Emails").updateChildValues(email)
//    }
    
    func registerUser(crudentials: UserAuth, completion: @escaping(Error?, DatabaseReference) -> Void) {
        let email = crudentials.email
        let password = crudentials.password
        let name = crudentials.name
        
        Auth.auth().createUser(withEmail: email, password: password)
        
    }
    
    func logUserIn(withEmail email: String, password: String, completion: @escaping(AuthDataResult?, Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }

}
