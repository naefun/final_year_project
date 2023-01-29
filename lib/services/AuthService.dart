import 'package:firebase_auth/firebase_auth.dart';

class AuthService{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Stream<User?> get onAuthStateChanged => _firebaseAuth.authStateChanges();

  // GET UID
  Future<String?> getCurrentUID() async {
    return _firebaseAuth.currentUser?.uid;
  }
}