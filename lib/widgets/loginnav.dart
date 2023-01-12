import 'package:flutter/material.dart';

Widget nextPage(String text1, Function()? press, String text2) {
  return Padding(
          padding: const EdgeInsets.only(left: 30, right: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
               Text(
                text1,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    letterSpacing: .5),
              ),
              TextButton(
                  onPressed: press,
                  child: Text(
                    text2,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ))
            ],
          ),
  );
}
