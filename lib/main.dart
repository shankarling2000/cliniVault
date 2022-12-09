import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_app/views/register_view.dart';
import 'package:my_app/views/reports_view.dart';
import 'package:my_app/views/verify_email.dart';
import 'package:my_app/views/verify_email.dart';
import 'firebase_options.dart';
import '../views/login_view.dart';
import '../views/reports_view.dart' as ReportsView;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const HomePage(),
      routes: {
        '/login/': (context) => const LoginView(),
        '/register/': (context) => const RegisterView(),
        '/reports/': (context) => const ReportsView.ReportsView(),
        '/verifyEmail/': (context) => const VerifyEmailView()
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
