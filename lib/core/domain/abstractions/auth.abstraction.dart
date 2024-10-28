import 'package:firebase_auth/firebase_auth.dart';

abstract class IAuthService {
  Future<void> signupWithEmailandPassword(String email, String password);
  Future<UserCredential> signinWithEmailAndPassword(
    String email,
    String password,
  );
  Future<void> signout();
  Future<void> forgotPassword(String email);
}
