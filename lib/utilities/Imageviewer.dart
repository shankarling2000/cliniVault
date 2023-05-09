import 'package:flutter/material.dart';

import '../constants/routes.dart';

class ImageView extends StatelessWidget {
  final ImageUrl;
  ImageView({this.ImageUrl});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Image view'),
          leading: BackButton(
            onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
              recordsRoute,
              (route) => false,
            ),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(ImageUrl), fit: BoxFit.cover),
          ),
        ));
  }
}
