import 'dart:developer';
import 'dart:io';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:image_cropper/image_cropper.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth auth = FirebaseAuth.instance;

final User? user = auth.currentUser;
final uid = user?.uid;
final myController = TextEditingController();

// Clean up the controller when the widget is disposed.

//import '../Screen/recognition_page.dart';
final storageRef = FirebaseStorage.instance.ref();
String imageurl = '';
CollectionReference _reference =
    FirebaseFirestore.instance.collection('MediRecords');
// Create a reference to "mountains.jpg"

// While the file names are the same, the references point to different files

Future<String> imageCropperView(String? path, BuildContext context) async {
  CroppedFile? croppedFile = await ImageCropper().cropImage(
    sourcePath: path!,
    aspectRatioPresets: [
      CropAspectRatioPreset.square,
      CropAspectRatioPreset.ratio3x2,
      CropAspectRatioPreset.original,
      CropAspectRatioPreset.ratio4x3,
      CropAspectRatioPreset.ratio16x9
    ],
    uiSettings: [
      AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false),
      IOSUiSettings(
        title: 'Crop',
      ),
      WebUiSettings(
        context: context,
      ),
    ],
  );
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
  if (croppedFile != null) {
    await openDialog();

    log("ImGW Cropped");
    log(croppedFile.path);
    print("fuck 1329");
    print(croppedFile.path);
    print("shit ");
    String name = DateTime.now().microsecondsSinceEpoch.toString();
    final mountainsRef = storageRef.child(name);
    String dataUrl = croppedFile.path;
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String filePath = dataUrl;
    File file = File(filePath);

    try {
      await mountainsRef.putFile(file);
      imageurl = await mountainsRef.getDownloadURL();
      print(imageurl);

      String Record = myController.text;
      // print("Fuckufkc\nfuckfucb\n\n\n\n\nfuc\n\n\n");
      // print('NAME OF THE RECORD\n\n\n\n\n\n\bnn');
      // print(Record);
      // print("Fuckufkc\nfuckfucb\n\n\n\n\nfuc\n\n\n");
      // print('NAME OF THE RECORD\n\n\n\n\n\n\bnn');
      String uniqid = uid.toString();
      Map<String, String> data = {
        'name': Record,
        'Url': imageurl,
        'ID': uniqid
      };
      _reference.add(data);
      await CoolAlert.show(
        context: context,
        type: CoolAlertType.success,
        text: "Your Upload was successful!",
      );
      //ignore: unused_catch_clause, nullable_type_in_catch_clause
    } on FirebaseException catch (e) {
      print("errorrrrr");
    }

    return croppedFile.path;
  } else {
    log("Done Nothing");
    return '';
  }
}
