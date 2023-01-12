import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

Widget heading(String text) {
  return Padding(
    padding: const EdgeInsets.only(left: 20, right: 20, bottom: 8),
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 22,
      ),
    ),
  );
}

Widget field(String hint,
    TextEditingController? cont,
    [TextInputType? keyboardinput, int? minlines, int? maxlines]) {
  return Padding(
    padding: const EdgeInsets.only(left: 20, right: 20, bottom: 8),
    child: TextFormField(
      validator: RequiredValidator(errorText: 'Required *'),
      controller: cont,
      minLines: minlines,
      keyboardType: keyboardinput,
      maxLines: maxlines,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(),
        border: const OutlineInputBorder(
          borderSide: BorderSide(
            width: 1.5,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 1.5),
        ),
      ),
    ),
  );
}

Widget location(TextEditingController? cont) {
  return Padding(
    padding: const EdgeInsets.only(left: 20, right: 20),
    child: TextFormField(
      validator: RequiredValidator(errorText: 'required *'),
      controller: cont,
      decoration: const InputDecoration(
        prefixIcon: Icon(
          Icons.location_on_outlined,
          color: Colors.blue,
        ),
        hintText: 'Enter Your Location',
        hintStyle: TextStyle(),
        border: OutlineInputBorder(
          borderSide: BorderSide(),
        ),
        focusedBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
      ),
    ),
  );
}
