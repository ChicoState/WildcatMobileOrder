import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Manages and tracks authentication via Firebase
class UserRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  /// Default UserRepository constructor, requires FirebaseAuth and
  /// GoogleSignIn objects
  UserRepository({FirebaseAuth firebaseAuth, GoogleSignIn googleSignin})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignin ?? GoogleSignIn();

  /// Allows a user to sign in with Google (GMail) [default]
  Future<FirebaseUser> signInWithGoogle() async {
    final googleUser = await _googleSignIn.signIn();
    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    await _firebaseAuth.signInWithCredential(credential);
    return _firebaseAuth.currentUser();
  }

  /// Method to sign in with email & password [not used]
  Future<void> signInWithCredentials(String email, String password) =>
      _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

  /// Allows a user to sign up with email & password [not used]
  Future<void> signUp({String email, String password}) async =>
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

  /// Signs out and un-authenticates a user
  Future<void> signOut() async => Future.wait([
      _firebaseAuth.signOut(),
      _googleSignIn.signOut(),
    ]);

  /// Returns current sign in status
  Future<bool> isSignedIn() async {
    final currentUser = await _firebaseAuth.currentUser();
    return currentUser != null;
  }

  /// Returns currently signed in user
  Future<FirebaseUser> getUser() async => await _firebaseAuth.currentUser();
}
