import 'package:careing/presence.dart';

class FirebaseAuthService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  FirebaseAuth _auth = FirebaseAuth.instance;
 
 
 Future<void> addUser(String UID, String name, String email, String password) {
    // Call the user's CollectionReference to add a new user
    return users
        .doc(UID)
        .set({
          'Name': name, // John Doe
          'Email': email,
          'Password': password
          // Stokes and Sons
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }


  
}
