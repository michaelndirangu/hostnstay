// ignore: file_names
import 'package:blurry/blurry.dart';
import 'package:flutter/material.dart';

void editProfileDetail(
  BuildContext context,
  TextEditingController inputTextController,
  Function() onConfirmButtonPressed,
) {
  return Blurry.input(
    title: 'Edit Phone Number',
    themeColor: Colors.cyan,
    icon: Icons.phone,
    popupHeight: 200,
    textInputType: TextInputType.phone,
    description: 'Edit your phone number below',
    confirmButtonText: 'save',
    onConfirmButtonPressed: onConfirmButtonPressed,
    inputLabel: 'Enter new phone number',
    inputTextController: inputTextController,
    onCancelButtonPressed: () {
      Navigator.pop(context);
    },
  ).show(context);
}
