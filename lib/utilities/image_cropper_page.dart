import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:image_cropper/image_cropper.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';

//import '../Screen/recognition_page.dart';
final storageRef = FirebaseStorage.instance.ref();

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

  if (croppedFile != null) {
    log("ImGW Cropped");
    log(croppedFile.path);
    print("fuck 1329");
    print(croppedFile.path);
    print("shit ");
    String name = croppedFile.path;
    final mountainsRef = storageRef.child(name);
    String dataUrl = croppedFile.path;
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String filePath = dataUrl;
    File file = File(filePath);

    try {
      await mountainsRef.putFile(file);
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
