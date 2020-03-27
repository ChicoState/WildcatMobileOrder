import 'package:WildcatMobileOrder/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  //final means it is const
  //underscore auth means private
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  // auth change user stream
  // Sets up a stream so that every time a user signs in or out we can track and alter
  Stream<FirebaseUser> get user {
    return _auth.onAuthStateChanged;
  }

  //*Practice with Anon sign in for functionality skell
  Future signInAnon() async {
    try {
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<String> signInWithGoogle() async {
    try {
      //Creates the account variable
      //! Currently will break if the user leaves the account sign-in page to go back to the app.
      //! Throws an exception that cannot be caught waiting for fix. Documentation: https://github.com/flutter/flutter/issues/26705
      final GoogleSignInAccount googleSignInAccount =
          await googleSignIn.signIn();
      // Waits on authentication
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);

      final AuthResult result = await _auth.signInWithCredential(credential);
      final user = result.user;

      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final FirebaseUser currentUser = await _auth.currentUser();
      assert(user.uid == currentUser.uid);

      return 'signInWithGoogle succeeded: $user';
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<void> signOutGoogle() async {
    await googleSignIn.signOut();
    // do we need to sign out of Firebase instance?
    await _auth.signOut();
    print("User Sign Out");
  }
}
