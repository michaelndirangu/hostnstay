import 'package:blurry/blurry.dart';
import 'package:flutter/cupertino.dart';

void showWarningMsg(
  BuildContext context,
  String description,
) {
  return Blurry.warning(
      title: 'Warning',
      description: description,
      confirmButtonText: 'Okay',
      displayCancelButton: false,
      popupHeight: 150,
      onConfirmButtonPressed: () {
        Navigator.pop(context);
      }).show(context);
}

void logoutMsg(BuildContext context, Function? confirm) {
  return Blurry.warning(
          title: 'Logout',
          description: 'Are you sure you want to sign out?',
          popupHeight: 150,
          confirmButtonText: 'Confirm',
          displayCancelButton: false,
          onConfirmButtonPressed: confirm)
      .show(context);
}
