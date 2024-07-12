import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Save user data to Firestore
  Future<void> saveUserData(User? user, {String? displayName}) async {
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).set({
        'email': user.email ?? '',
        'displayName': displayName ?? user.displayName ?? 'No Name',
        'lastLogin': DateTime.now(),
        'createdAt': FieldValue.serverTimestamp(),
        'profilePicture': 'default_profile_picture_url'
      });
    }
  }

  // Sign up user function with enhanced error handling and data storage
  Future<String> createUser({
    required String email, 
    required String password, 
    required String displayName
  }) async {
    String res = "Some error occurred";
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        await saveUserData(userCredential.user, displayName: displayName);
        res = "success";
      }
    } on FirebaseAuthException catch (e) {
      res = e.message ?? 'Failed to register user. Please try again later.';
    } catch (e) {
      res = 'Failed to register user: ${e.toString()}';
    }
    return res;
  }

  // Modified sign in method with detailed feedback
  Future<String> signInUser({required String email, required String password}) async {
    String res = "Some error occurred with login";
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        await _firestore.collection('users').doc(userCredential.user!.uid).update({
          'lastLogin': DateTime.now(),
        });
        res = "success";
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        res = 'User not found';
      } else if (e.code == 'wrong-password') {
        res = 'Invalid password';
      } else {
        res = e.message ?? 'Failed to sign in. Please try again later.';
      }
    } catch (e) {
      res = 'Failed to sign in: ${e.toString()}';
    }
    return res;
  }
}
