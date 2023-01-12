import 'package:blurry/blurry.dart';
import 'package:flutter/cupertino.dart';

void showErrorMsg(BuildContext context, String description) {
  return Blurry.error(
      title: 'Error Message',
      description: description,
      confirmButtonText: 'Close',
      displayCancelButton: false,
      popupHeight: 150,
      onConfirmButtonPressed: () {
        Navigator.pop(context);
      }).show(context);
}
