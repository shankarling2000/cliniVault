import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_app/views/reports_view.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Email Verification'),
        actions: [
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogOutDialog(context);
                  if (shouldLogout) {
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil('/login/', (_) => false);
                  }
                  break;
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuAction>(
                    value: MenuAction.logout, child: Text('Logout'))
              ];
            },
          )
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Center(
            child: const Text('Verify your email address',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w400)),
          ),
          SizedBox(
            height: 30,
          ),
          TextButton(
              onPressed: () async {
                var user = FirebaseAuth.instance.currentUser;
                await user?.sendEmailVerification();

                const snackBar = SnackBar(
                  content: Text('Email verification sent'),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
              child: const Text('Send email verification')),
          TextButton(
            onPressed: (() async {
              final user = await FirebaseAuth.instance.currentUser;
              user!.reload();
              if (user != null) {
                print(user);
                print(user.emailVerified);
                if (await user.emailVerified) {
                  print("INSIDE THE DFUCK");
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil('/reports/', (route) => false);
                } else {
                  const snackBar = SnackBar(
                    content: Text('Email not verified'),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              }
            }),
            child: Text('Get started'),
          )
        ],
      ),
    );
  }
}

Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Sign out'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text('Log out'),
          ),
        ],
      );
    },
  ).then((value) => value ?? false);
}
