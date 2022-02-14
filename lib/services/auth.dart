import 'package:firebase_auth/firebase_auth.dart';
import 'package:pep/models/user.dart';
import 'package:pep/services/database.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  UserAttributes? _userFromFirebase(User? user) {
    if (user == null) {
      return null;
    }
    return UserAttributes(isAdmin: false, uid: user.uid, email: user.email);
  }

  Stream<UserAttributes?> get onAuthStateChanged {
    return _firebaseAuth.authStateChanges().map(_userFromFirebase);
  }

  Future<UserAttributes?> signIn(String email, String password) async {
    final credential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);

    // Map back to User model
    return _userFromFirebase(credential.user);
  }

  Future<UserAttributes?> register(String username, String email, String password) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    await DatabaseService(uid: credential.user!.uid).addUser(credential.user!.uid, username, email);

    // Map back to User model
    return _userFromFirebase(credential.user);
  }

  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }
}
