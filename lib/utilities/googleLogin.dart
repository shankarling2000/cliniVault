import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_app/utilities/error_dialog.dart';

import '../constants/routes.dart';
import '../services/auth_service.dart';

loginwithGoogle(context) async {
  try {
    UserCredential usercredential = await AuthService().signInWithGoogle();
    await CoolAlert.show(
      context: context,
      type: CoolAlertType.success,
      text: "Your Upload was successful!",
    );

    final user = usercredential.user;
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
