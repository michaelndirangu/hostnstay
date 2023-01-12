import 'package:flutter/cupertino.dart';

Widget padding(double left, double right, [double top = 0.0 , double bottom = 0.0]) {
  return Padding(
    padding: EdgeInsets.only(
      left: left,
      right: right,
      top: top,
      bottom: bottom,
    ),
  );
}
