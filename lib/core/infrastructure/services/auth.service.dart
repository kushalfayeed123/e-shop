import 'dart:io';

import 'package:eshop/core/domain/abstractions/auth.abstraction.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService implements IAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future forgotPassword(String email) async {
    try {
      _firebaseAuth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseException catch (e) {
      final message = e.message ?? '';

      throw HttpException(message);
    } catch (e) {
      final message = e.toString();

      throw HttpException(message);
    }
  }

  @override
  Future<UserCredential> signinWithEmailAndPassword(
      String email, String password) async {
    try {
      final res = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return res;
    } on FirebaseAuthException catch (e) {
      throw HttpException(e.message ?? '');
    } catch (e) {
      throw HttpException(e.toString());
    }
  }

  @override
  Future<void> signout() async {
    await _firebaseAuth.signOut();
  }

  @override
  Future<void> signupWithEmailandPassword(
    String email,
    String password,
  ) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        const HttpException('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        const HttpException('The account already exists for that email.');
      }
    } catch (e) {
      HttpException(e.toString());
    }
  }
}
