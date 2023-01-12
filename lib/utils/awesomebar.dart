import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';

void showBookingSuccess(BuildContext context, String message) {
  final snackbar = SnackBar(
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 5),
      margin: const EdgeInsets.only(top: 10, bottom: 600, right: 20, left: 20),
      elevation: 0,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
          title: "Booking Successful",
          message: message,
          contentType: ContentType.success));
  ScaffoldMessenger.of(context).showSnackBar(snackbar);
}
