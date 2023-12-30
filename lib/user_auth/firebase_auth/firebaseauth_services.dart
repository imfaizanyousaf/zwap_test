import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:zwap_test/global/commons/toast.dart';

class FirebaseAuthService {
  FirebaseAuthService() {
    // Call Firebase.initializeApp() in the constructor or wherever appropriate
    initializeFirebase();
  }

  Future<void> initializeFirebase() async {
    await Firebase.initializeApp();
  }

  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        showToast(message: 'Email already in use!');
      } else {
        showToast(message: 'An Error Occured! Try again later');
      }
    }
    return null;
  }

  Future<User?> sigInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential' || e.code == 'wrong-password') {
        showToast(message: 'Invalid Email or Password');
      } else {
        showToast(message: 'An Error Occured! Try again later');
      }
    }
    return null;
  }
}
