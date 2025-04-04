import 'package:blurry/blurry.dart';
import 'package:flutter/material.dart';

void showSuccessMsg(
  BuildContext context,
  String description,
) {
  return Blurry.success(
      title: 'Message',
      popupHeight: 150,
      description: description,
      confirmButtonText: 'Okay',
      displayCancelButton: false,
      barrierColor: Colors.white.withValues(alpha: 0.7),
      onConfirmButtonPressed: () {
        Navigator.pop(context);
      }).show(context);      
}
