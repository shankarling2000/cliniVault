import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_app/constants/routes.dart';

import '../services/auth_service.dart';
import 'error_dialog.dart';

userRegistration(context) async {
  try {
    AuthService().signInWithGoogle();

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
