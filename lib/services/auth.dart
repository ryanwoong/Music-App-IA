import 'package:firebase_auth/firebase_auth.dart';


class AuthService {
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> registerUser({
    required,
    username,
    required email,
    required password,
  }) async {
    User? user;
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword( email: email, password: password);

      user = userCredential.user;
      await user!.reload();
      user = _auth.currentUser;
      return user;
    } catch (error) {
      print("error: " + error.toString());
      return null;
    }
  }
}
