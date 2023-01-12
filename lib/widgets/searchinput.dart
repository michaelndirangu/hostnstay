import 'package:flutter/material.dart';

Widget specificSearch(
  TextEditingController searchCont,
  TextInputType inputType,
  String labelText,
  void Function()? clearText,
) {
  return TextFormField(
    obscureText: false,
    controller: searchCont,
    keyboardType: inputType,
    decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        labelText: labelText,
        labelStyle: const TextStyle(
            fontSize: 16, color: Colors.black, overflow: TextOverflow.fade),
        suffixIcon:
            IconButton(onPressed: clearText, icon: const Icon(Icons.clear)),
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue))),
  );
}
