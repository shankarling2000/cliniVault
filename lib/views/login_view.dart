import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_app/constants/routes.dart';

import '../utilities/Textfields.dart';
import '../utilities/error_dialog.dart';
import '../utilities/googleLogin.dart';
import '../utilities/user_verification.dart';

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
          SizedBox(
            height: 100,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              const SizedBox(
                height: 20,
              ),
              Text(
                "Login",
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.w400),
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          text_field(_email, TextInputType.emailAddress, "Enter your email"),
          text_field(_password, TextInputType.text, "Enter your password"),
          TextButton(
            onPressed: () async {
              userVerification(_email, _password, context);
            },
            child: const Text('Sign in'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(registerRoute, (route) => false);
            },
            child: const Text('Not Registered yet? Register here'),
          ),
          Text(
            'OR',
            style: TextStyle(fontSize: 30),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () async {
                  loginwithGoogle(context);
                },
                child: Text(
                  'Login with  ',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w300),
                ),
              ),
              InkWell(
                onTap: () async {
                  loginwithGoogle(context);
                },
                child: Image.network(
                  'http://pngimg.com/uploads/google/google_PNG19635.png',
                  height: 60,
                  width: 50,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
