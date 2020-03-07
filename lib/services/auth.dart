import 'package:WildcatMobileOrder/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  //final means it is const
  //underscore auth means private
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //Create a user object based on FirebaseUser
  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  //auth change user stream
  //Sets up a stream so that every time a user signs in or out we can track and alter
  Stream<User> get user {
    return _auth.onAuthStateChanged
    .map(_userFromFirebaseUser);
    //^^This maps the given back "FirebaseUser" to our simplified user object
  }

  //*Practice with Anon sign in for functionality skell
  Future signInAnon() async {
    try {
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  //sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch(e) { //If error in signing out catch the error and print it to console
      print(e.toString());
      return null;
    }
  }

  //TODO: allow sign in with email and pass
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  //TODO: implement register with email and pass
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);

    } catch(e) {

      print(e.toString());
      return null;

    }
  }

  
  //TODO: implement register and sign in with Google
}