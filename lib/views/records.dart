import 'dart:developer';

import 'package:flutter/material.dart';
import '../constants/curentuserid.dart';
import '../constants/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../utilities/Imageviewer.dart';
import '../utilities/Pdfviewer.dart';

class records extends StatelessWidget {
  records({Key? key}) : super(key: key) {
    _stream = _reference.snapshots();
  }
  CollectionReference _reference =
      FirebaseFirestore.instance.collection('MediRecords');
  late Stream<QuerySnapshot> _stream;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: BackButton(
          onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
            reportsRoute,
            (route) => false,
          ),
        ),
        title: const Text('CliniVault'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _stream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Eroorrrrrrrrrrrrrrr/.........."),
            );
          }
          if (snapshot.hasData) {
            QuerySnapshot querySnapshot = snapshot.data;
            List<QueryDocumentSnapshot> medirecords = querySnapshot.docs;

            List<Map> medi = medirecords.map((e) => e.data() as Map).toList();
            List ids = [uid];
            List selectedUsers =
                medi.where((u) => ids.contains(u["ID"])).toList();

            return ListView.builder(
                itemCount: selectedUsers.length,
                itemBuilder: (BuildContext context, int index) {
                  Map thisItem = selectedUsers[index];

                  return Container(
                      child: Column(
                    children: [
                      Text(
                        '${thisItem['name']}',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                      thisItem.containsKey('Url')
                          ? InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ImageView(
                                            ImageUrl: thisItem['Url'])));
                              },
                              child: Container(
                                height: 20,
                                child: Text('Tap to view'),
                              ),
                            )
                          : Container(),
                      thisItem.containsKey('ReportUrl')
                          ? InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => View(
                                              Reporturl: thisItem['ReportUrl'],
                                            )));
                              },
                              child: Container(
                                height: 20,
                                child: Text('Tap to view'),
                              ),
                            )
                          : Container(),
                      SizedBox(
                        height: 30,
                      )
                    ],
                  ));
                });
          }
          return Text("It's Empty Here");
        },
      ),
    );
  }
}

            // print(',Sagar\n\n\n\n');
            // print(selectedUsers);
            // print("The length of selectedUSers is ${selectedUsers.length}");

            // print("The length of MEdiUSers is ${medi.length}");
            // print('End\nEnd\nEnd\nEnd\n');