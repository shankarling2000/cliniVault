import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_app/constants/routes.dart';
import 'package:my_app/views/recognition_page.dart';
import 'package:my_app/views/register_view.dart';
import 'package:my_app/views/reports_view.dart';
import 'package:my_app/views/verify_email.dart';
import 'package:my_app/views/verify_email.dart';
import 'firebase_options.dart';
import '../views/login_view.dart';
import '../views/reports_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Clini  Vault',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const HomePage(),
      routes: {
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        reportsRoute: (context) => const ReportsView(
              title: 'Scan Page',
            ),
        verifyEmailRoute: (context) => const VerifyEmailView(),
        recognizePage: (context) => const RecognizePage()
      },
      debugShowCheckedModeBanner: false,
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        // switch (snapshot.connectionState) {
        //   case ConnectionState.done:
        //     final user = FirebaseAuth.instance.currentUser;
        //     if (user != null) {
        //       if (user.emailVerified) {
        //         return const ReportsView();
        //       } else {
        //         return const VerifyEmailView();
        //       }
        //     } else {
        return const LoginView();
        //     }

        //   default:
        //     return const CircularProgressIndicator();
        // }
      },
    );
  }
}
