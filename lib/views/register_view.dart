import 'package:flutter/material.dart';
import 'package:my_app/constants/routes.dart';
import '../utilities/Textfields.dart';
import '../utilities/googleLogin.dart';
import '../utilities/user_register.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    super.initState();
    _email = TextEditingController();
    _password = TextEditingController();
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
        title: const Text('CliniVault'),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                "Register",
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.w400),
              )
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          text_field(_email, TextInputType.emailAddress, "Enter your email"),
          text_field(_password, TextInputType.text, "Enter your password"),
          TextButton(
            onPressed: () {
              userRegistration(context);
            },
            child: const Text('Sign up'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(loginRoute, (route) => false);
            },
            child: const Text("Already registered? Login here"),
          ),
          const Text(
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
                child: const Text(
                  'Continue with  ',
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
