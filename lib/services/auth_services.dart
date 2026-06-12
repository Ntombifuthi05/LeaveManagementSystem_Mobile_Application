import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  FirebaseAuth get _auth => FirebaseAuth.instance;

  // 🔹 Sign in with email and password
  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  // 🔹 Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // 🔹 Get current user
  User? get currentUser => _auth.currentUser;

  // 🔹 Auth state changes stream
  Stream<User?> get userChanges => _auth.authStateChanges();
}
