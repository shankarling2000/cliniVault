import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
      ),
      body: Column(
        children: [
          const Text('Please verify your email address'),
          TextButton(
              onPressed: () async {
                var user = FirebaseAuth.instance.currentUser;
                await user?.sendEmailVerification();

                const snackBar = SnackBar(
                  content: Text('Email has been sent,check your spambox'),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
              child: const Text('Send email verification')),
          TextButton(
              onPressed: (() async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/login/', (_) => false);
              }),
              child: Text('Logout')),
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
                    content: Text('Email not has been verifed'),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              }
            }),
            child: Text('GEt started'),
          )
        ],
      ),
    );
  }
}

enum MenuAction { logout }

class ReportsView extends StatefulWidget {
  const ReportsView({super.key});

  @override
  State<ReportsView> createState() => _ReportsViewState();
}

class _ReportsViewState extends State<ReportsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(' Main UI'),
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
      body: const Text('Hello world'),
    );
  }
}

Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Sign out'),
        content: const Text('Are you sure you want to sign out?'),
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
