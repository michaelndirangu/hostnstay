import 'package:flutter/material.dart';

Widget divider() {
  return Container(
          padding:
              const EdgeInsets.only(left: 30, right: 30, bottom: 15),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                    margin: const EdgeInsets.only(left: 5, right: 10),
                    child: const Divider(
                      color: Colors.cyan,
                      height: 36,
                      thickness: 2,
                    )),
              ),
              const Text('Or'),
              Expanded(
                child: Container(
                    margin: const EdgeInsets.only(left: 10, right: 5),
                    child: const Divider(
                      color: Colors.cyan,
                      height: 36,
                      thickness: 2,
                    )),
              ),
            ],
          ),
  );
}
