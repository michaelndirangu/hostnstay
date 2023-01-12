import 'package:flutter/material.dart';

// ignore: must_be_immutable
class LargeText extends StatelessWidget {

  double size;
  final String text;
  final Color color;
   LargeText({ Key? key, 
   required this.size,
   required this.text, 
   this.color = Colors.black
    }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.start,
      style: TextStyle(
        color: color,
        fontSize: size,
        fontWeight: FontWeight.bold

      ),
    );
  }
}