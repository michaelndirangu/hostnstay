
import 'package:flutter/material.dart';

Widget profileImage() {
  return Center(
    child: Stack(children: <Widget>[
      const CircleAvatar(
        radius: 80,
        backgroundImage: AssetImage('img/avater.jpg'),
      ),
      Positioned(
        bottom: 15,
        right: 15,
        child: InkWell(
          onTap: () {},
          child: const Icon(
            Icons.camera_alt,
            color: Colors.blue,
            size: 28,
          ),
        ),
      )
    ]),
  );
}

Widget bottomSheet() {
  return Container(
    height: 100,
    width: 75,
    margin: const EdgeInsets.symmetric(
      horizontal: 20,
      vertical: 20,
    ),
    child: Column(
      children: <Widget>[
        const Text(
          'Choose a Profile Photo',
          style: TextStyle(
            fontSize: 20
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          children: <Widget>[
            TextButton.icon(
              icon: const Icon(Icons.camera), 
              label: const Text('Camera'),
              onPressed: () {},
              ),
            TextButton.icon(
              icon: const Icon(Icons.browse_gallery), 
              label: const Text('Gallery'),
              onPressed: () {},)
          ],
        )
      ],
    ),
  );
}
