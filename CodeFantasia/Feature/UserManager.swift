
import Firebase

let DB_REF = Database.database().referece() 
let REF_USERS = DB_REF.child("users")

let STORAGE_REF = Storage.stroage().reference()
let STORAGE_PROFILE_IMAGES = STORAGE_REF.child("profile_images")
