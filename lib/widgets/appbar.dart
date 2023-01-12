import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

AppBar buildAppBar(BuildContext context) {
  const icon = CupertinoIcons.moon_stars;

  return AppBar(
    // leading: BackButton(
    //   color: Colors.cyan,
    //   onPressed: () {
    //     Navigator.push(context, MaterialPageRoute(
    //       builder: (context) => const HomePage()));
    //   },
    // ),
    automaticallyImplyLeading: true,
    elevation: 0,
    systemOverlayStyle: const SystemUiOverlayStyle(statusBarColor: Colors.white),
    backgroundColor: Colors.transparent,
    actions: [
      IconButton(
        onPressed: () {},
        icon: const Icon(icon),
        color: Colors.cyan
        ),
    ],
  );
}
