import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepo {
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  // Private constructor for singleton pattern
  AuthRepo._privateConstructor()
      : _auth = FirebaseAuth.instance,
        _googleSignIn = GoogleSignIn();

  // Singleton instance
  static final AuthRepo _instance = AuthRepo._privateConstructor();

  // Factory constructor to return the singleton instance
  factory AuthRepo() {
    return _instance;
  }

  // Method to sign in with Google
  Future<User?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      return null;
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final UserCredential userCredential =
        await _auth.signInWithCredential(credential);
    return userCredential.user;
  }

  // Method to sign out
  Future<void> signOut() async {
    await _googleSignIn.disconnect();
    await _googleSignIn.signOut();
    await _auth.signOut();
    print("user signed out");
    print(_auth.currentUser);
  }

  // Method to get the current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  bool isLoggedIn() {
    if (_auth.currentUser == null) {
      return false;
    }
    return true;
  }
}
