import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_app/constants/routes.dart';
import 'package:my_app/utilities/error_dialog.dart';

userVerification(_email, _password, context) async {
  final email = _email.text;
  final password = _password.text;
  //prefs.setString('email', email);
  //prefs.setString('password', password);

  try {
    final userCredential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      if (user.emailVerified) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(reportsRoute, (route) => false);
      } else {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(verifyEmailRoute, (route) => false);
      }
    }
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      await showErrorDialog(context, 'User not found');
    } else if (e.code == 'wrong-password') {
      await showErrorDialog(context, 'Invalid username or password');
    }
  } catch (e) {
    await showErrorDialog(context, 'Error: $e');
  }
}
