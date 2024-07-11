import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


final FirebaseFirestore _firestore = FirebaseFirestore.instance;


Future<void> saveUserData(User? user, {String? displayName}) async {
  if (user != null) {
    await _firestore.collection('users').doc(user.uid).set({
      'email': user.email,
      'displayName': displayName ?? user.displayName ?? 'No Name',
      'lastLogin': DateTime.now(),
    });
  }
}


final FirebaseAuth _auth = FirebaseAuth.instance;

// Sign up and store user data
Future<User?> createUser(String email, String password, String displayName) async {
  final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
    email: email,
    password: password,
  );
  if (userCredential.user != null) {
    await saveUserData(userCredential.user, displayName: displayName);
  }
  return userCredential.user;
}

// Sign in and update login time
Future<User?> signInUser(String email, String password) async {
  final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
    email: email,
    password: password,
  );
  if (userCredential.user != null) {
    // Optionally update last login time or other relevant data
    await _firestore.collection('users').doc(userCredential.user!.uid).update({
      'lastLogin': DateTime.now(),
    });
  }
  return userCredential.user;
}
