import 'package:flutter/material.dart';

Widget field(
  bool bol,
  String? Function(String?)? validate,
  TextEditingController cont,
  String labelText,
  IconData icon, [
  void Function()? pressed,
  IconData? iconn,
]) {
  return TextFormField(
    obscureText: bol,
    validator: validate,
    controller: cont,
    decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[330],
        labelText: labelText,
        labelStyle: const TextStyle(
          fontSize: 16,
          color: Colors.black,
          overflow: TextOverflow.fade
        ),
        prefixIcon: Icon(icon),
        suffixIcon: IconButton(onPressed: pressed, icon: Icon(iconn)),
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue))),
  );
}

Widget confirmPass(String? Function(String?)? validate, TextEditingController cont,
  void Function()? pressed,
IconData? iconn,) {
  return TextFormField(
    obscureText: true,
    validator: validate,
    controller: cont,
    decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[330],
        labelText: 'Confirm Password',
        labelStyle: const TextStyle(
          fontSize: 16,
          color: Colors.black,
        ),
        prefixIcon: const Icon(Icons.password),
        suffixIcon: IconButton(onPressed: pressed, icon: Icon(iconn)),
        border: const UnderlineInputBorder(borderSide: BorderSide.none),
        // borderSide: BorderSide(color: Colors.cyan)),
        focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.blue))),
  );
}
