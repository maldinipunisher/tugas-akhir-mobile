part of 'services.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<User?> register(
      String email, String password, String name) async {
    final res = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);

    res.user!.updateDisplayName(name);
    res.user!.reload();
    return res.user;
  }

  static Future<User> login(String email, String password) async {
    final res = await _auth.signInWithEmailAndPassword(
        email: email, password: password);

    return res.user!;
  }

  static Stream<User?> get checkUserExist => _auth.authStateChanges();
}
