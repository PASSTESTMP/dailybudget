import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  Future<void> signInWithEmail(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      // Handle error
      // print('Error signing in: $e');
      if(email != "" && password != "") {
        try{
          await _auth.createUserWithEmailAndPassword(email: email, password: password);
          final loging = await _auth.signInWithEmailAndPassword(email: email, password: password);
          await loging.user?.sendEmailVerification();
        } catch (e) {
          // Handle error
          // print('Error signing in: $e');
        }
      }
    }
  }

  Future<void> signInWithGoogle() async {
    // Implement Google Sign-In logic here
    // This is a placeholder for the actual implementation
  }
  Future<void> signInWithFacebook() async {
    // Implement Facebook Sign-In logic here
    // This is a placeholder for the actual implementation
  }
  Future<void> signInWithApple() async {
    // Implement Apple Sign-In logic here
    // This is a placeholder for the actual implementation
  }
  Future<void> signInWithPhone(String phoneNumber) async {
    // Implement Phone Sign-In logic here
    // This is a placeholder for the actual implementation
  }
  Future<void> signUpWithEmail(String email, String password) async {
    await _auth.createUserWithEmailAndPassword(email: email, password: password);
  }
  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Stream<User?> authStateChanges() => _auth.authStateChanges();
}
