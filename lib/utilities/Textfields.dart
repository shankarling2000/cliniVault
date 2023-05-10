import 'package:flutter/material.dart';

text_field(fieldcontroller, keyboardType, hintmessage) {
  TextField(
    controller: fieldcontroller,
    enableSuggestions: false,
    autocorrect: false,
    keyboardType: keyboardType,
    decoration: InputDecoration(
      border: OutlineInputBorder(),
      hintText: hintmessage,
    ),
  );
}
