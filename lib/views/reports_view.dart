// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:my_app/constants/routes.dart';
import 'dart:io';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_app/utilities/image_cropper_page.dart';
import 'package:my_app/utilities/image_picker_class.dart';
import 'package:my_app/constants/routes.dart';
import 'package:my_app/views/recognition_page.dart';
import 'package:my_app/Widgets/model_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';

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

final FirebaseAuth auth = FirebaseAuth.instance;
final myController = TextEditingController();
final User? user = auth.currentUser;
final uid = user?.uid;

CollectionReference _reference =
    FirebaseFirestore.instance.collection('MediRecords');

class ReportsView extends StatefulWidget {
  const ReportsView({Key? key, required this.title}) : super(key: key);

  final String title;
  void show(msg) {
    print(msg);
  }

  @override
  State<ReportsView> createState() => _ReportsViewState();
}

class _ReportsViewState extends State<ReportsView> {
  int _counter = 0;
  void submit() {
    Navigator.of(context).pop();
  }

  Future openDialog() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text("File name"),
            content: TextField(
              controller: myController,
              autofocus: true,
              decoration: InputDecoration(hintText: 'Enter your name'),
            ),
            actions: [
              TextButton(onPressed: submit, child: const Text('SUBMIT'))
            ],
          ));
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  String url = '';
  uploadPDF() async {
    //Picking PDF FILE
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    File pick = File(result!.files.single.path.toString());
    var file = pick.readAsBytesSync();
    String name = DateTime.now().microsecondsSinceEpoch.toString();

    //Uploading File to firebase
    var pdfFile = FirebaseStorage.instance.ref().child(name).child('/.pdf');
    UploadTask task = pdfFile.putData(file);
    TaskSnapshot snapshot = await task;
    url = await snapshot.ref.getDownloadURL();
    String uniqid = uid.toString();
    await openDialog();
    name = myController.text;
    Map<String, String> data = {'name': name, 'ReportUrl': url, 'ID': uniqid};
    _reference.add(data);

    CoolAlert.show(
      context: context,
      type: CoolAlertType.success,
      text: "Your Upload was successful!",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
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
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text(
              "SCan or Upload Records",
            ),
            SizedBox(
              height: 260,
            ),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        recordsRoute, (route) => false);
                  },
                  child: Text("Records")),
            ),
            SizedBox(
              height: 200,
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: ElevatedButton(
                onPressed: () {
                  uploadPDF();
                },
                child: Text(
                  "Upload Pdf",
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    fixedSize: const Size(120, 40),
                    padding: EdgeInsets.all(2)

                    // Background color
                    ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.grey[400],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          imagePickerModal(
            context,
            onCameraTap: () {
              log('Camera clicked ');
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
              log('Gallery Clicked');
              pickImage(source: ImageSource.gallery).then((value) {
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
          );
        },
        tooltip: 'Increment',
        label: const Text(
          "Scan reports",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
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
