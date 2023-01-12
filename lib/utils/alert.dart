import 'package:flutter/material.dart';

void showAlertDialog(BuildContext context, String text) {
  Widget okButton = TextButton(
    child: const Text('Ok'),
    onPressed: () {
      Navigator.pop(context, 'Ok');
    },
  );

  AlertDialog alert = AlertDialog(
    title: const Text(
      'Message.',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    ),
    elevation: 4,
    content: Builder(
      builder: (context) {
        return SizedBox(
          height: 15,
          width: MediaQuery.of(context).size.width / 1.3,
          child: Text(text),
        );
      },
    ),
    actions: [okButton],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
