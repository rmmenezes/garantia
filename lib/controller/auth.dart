import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Authentication {
  late final FirebaseAuth _auth = FirebaseAuth.instance;
  late User _user;

  Future<User> signInWithGoogle({required BuildContext context}) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential =
            await _auth.signInWithCredential(credential);
        _user = userCredential.user!;
        return _user;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          throw const AuthenticationException(
              message: 'An account already exists with the same email address but different sign-in credentials. Try signing in a different way.');
        } else if (e.code == 'invalid-credential') {
          throw const AuthenticationException(
              message: 'The supplied auth credential is malformed or has expired.');
        } else {
          throw const AuthenticationException(
              message: 'An unexpected error occurred. Please try again later.');
        }
      } catch (e) {
        throw const AuthenticationException(
            message: 'An unexpected error occurred. Please try again later.');
      }
    } else {
      throw const AuthenticationException(
          message: 'No Google account found. Please try again.');
    }
  }
}

class AuthenticationException implements Exception {
  final String message;

  const AuthenticationException({required this.message});

  @override
  String toString() => 'AuthenticationException: $message';
}
