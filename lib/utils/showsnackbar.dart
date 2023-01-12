import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(text),
    elevation: 2.0,
    behavior: SnackBarBehavior.floating,
    width: MediaQuery.of(context).size.width/1.2,
    backgroundColor: Colors.white,
  ));
}
