import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:my_app/constants/routes.dart';

import '../utilities/error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  late SharedPreferences prefs;
  @override
  void initState() {
    super.initState();
    _email = TextEditingController();
    _password = TextEditingController();
    SharedPreferences.getInstance().then((SharedPreferences sp) {
      prefs = sp;
      final email = prefs.getString('email');
      final password = prefs.getString('password');
      if (email != null && password != null) {
        FirebaseAuth.instance
            .signInWithEmailAndPassword(
          email: email,
          password: password,
        )
            .then((userCredential) {
          final user = FirebaseAuth.instance.currentUser;
          if (user != null) {
            if (user.emailVerified) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                reportsRoute,
                (route) => false,
              );
            } else {
              Navigator.of(context).pushNamedAndRemoveUntil(
                verifyEmailRoute,
                (route) => false,
              );
            }
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('CliniVault'),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                "Login",
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.w400),
              )
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter your email',
            ),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter your password',
            ),
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              prefs.setString('email', email);
              prefs.setString('password', password);

              try {
                final userCredential =
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: email,
                  password: password,
                );
                final user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  if (user.emailVerified) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        reportsRoute, (route) => false);
                  } else {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        verifyEmailRoute, (route) => false);
                  }
                }
              } on FirebaseAuthException catch (e) {
                if (e.code == 'user-not-found') {
                  await showErrorDialog(context, 'User not found');
                } else if (e.code == 'wrong-password') {
                  await showErrorDialog(
                      context, 'Invalid username or password');
                }
              } catch (e) {
                await showErrorDialog(context, 'Error: $e');
              }
            },
            child: const Text('Sign in'),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(registerRoute, (route) => false);
              },
              child: const Text('Not Registered yet? Register here'))
        ],
      ),
    );
  }
}
