// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:my_app/constants/routes.dart';

import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_app/utilities/image_cropper_page.dart';
import 'package:my_app/utilities/image_picker_class.dart';
import 'package:my_app/constants/routes.dart';
import 'package:my_app/views/recognition_page.dart';
import 'package:my_app/Widgets/model_dialog.dart';

enum MenuAction { logout }

// class ReportsView extends StatefulWidget {
//   const ReportsView({super.key});

//   @override
//   State<ReportsView> createState() => _ReportsViewState();
// }

// class _ReportsViewState extends State<ReportsView> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         title: const Text('Reports'),
//         actions: [
//           PopupMenuButton<MenuAction>(
//             onSelected: (value) async {
//               switch (value) {
//                 case MenuAction.logout:
//                   final shouldLogout = await showLogOutDialog(context);
//                   if (shouldLogout) {
//                     await FirebaseAuth.instance.signOut();
//                     Navigator.of(context)
//                         .pushNamedAndRemoveUntil(loginRoute, (_) => false);
//                   }
//                   break;
//               }
//             },
//             itemBuilder: (context) {
//               return const [
//                 PopupMenuItem<MenuAction>(
//                     value: MenuAction.logout, child: Text('Logout'))
//               ];
//             },
//           )
//         ],
//       ),
//       body: const Text(' Verified & logged in'),
//     );
//   }
// }

// Future<bool> showLogOutDialog(BuildContext context) {
//   return showDialog<bool>(
//     context: context,
//     builder: (context) {
//       return AlertDialog(
//         title: const Text('Sign out'),
//         content: const Text('Are you sure you want to sign out?'),
//         actions: [
//           TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(false);
//               },
//               child: const Text('Cancel')),
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop(true);
//             },
//             child: const Text('Log out'),
//           ),
//         ],
//       );
//     },
//   ).then((value) => value ?? false);
// }

class ReportsView extends StatefulWidget {
  const ReportsView({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<ReportsView> createState() => _ReportsViewState();
}

class _ReportsViewState extends State<ReportsView> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogOutDialog(context);
                  if (shouldLogout) {
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(loginRoute, (_) => false);
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'CLick a image or upload ',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          imagePickerModal(
            context,
            onCameraTap: () {
              log('Camera clicked  ');
              pickImage(source: ImageSource.camera).then((value) {
                if (value != '') {
                  imageCropperView(value, context).then(
                    (value) {
                      if (value != '') {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (_) => RecognizePage(
                              path: value,
                            ),
                          ),
                        );
                      }
                    },
                  );
                }
              });
            },
            onGalleryTap: () {
              log('Gallery CLicked ');
              pickImage(source: ImageSource.gallery).then((value) {
                if (value != '') {
                  imageCropperView(value, context).then((value) {
                    if (value != '') {
                      imageCropperView(value, context).then(
                        (value) {
                          if (value != '') {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (_) => RecognizePage(
                                  path: value,
                                ),
                              ),
                            );
                          }
                        },
                      );
                    }
                  });
                }
              });
            },
          );
        },
        tooltip: 'Increment',
        label: const Text("Scan Photo"),
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
