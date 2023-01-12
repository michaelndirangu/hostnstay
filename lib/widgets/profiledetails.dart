import 'package:flutter/material.dart';

Widget profileDetail(IconData icona, String title, IconData iconb,
    [void Function()? ontap]) {
  return Container(
    padding: const EdgeInsets.only(left: 15, right: 15),
    child: Card(
      elevation: 1.5,
      child: Padding(
        padding: const EdgeInsets.only(left: 0, right: 0),
        child: ListTile(
          minLeadingWidth: 20,
          leading: Icon(icona, color: Colors.cyan),
          title: Text(title),
          trailing: Icon(
            iconb,
            color: Colors.cyan,
          ),
          onTap: ontap,
        ),
      ),
    ),
  );
}

Widget profiledetail(IconData icona, String title, [IconData? iconb]) {
  return Container(
    padding: const EdgeInsets.only(left: 15, right: 15),
    child: Card(
      elevation: 1.5,
      child: Padding(
        padding: const EdgeInsets.only(left: 0, right: 0),
        child: ListTile(
          minLeadingWidth: 20,
          leading: Icon(icona, color: Colors.cyan),
          trailing: Icon(iconb, color: Colors.cyan),
          title: Text(title),
        ),
      ),
    ),
  );
}

Widget phonedetail(
  String title, Function() onPressed
) {
  return Container(
    padding: const EdgeInsets.only(left: 15, right: 15),
    child: Card(
      elevation: 1.5,
      child: Padding(
        padding: const EdgeInsets.only(left: 0, right: 0),
        child: ListTile(
          minLeadingWidth: 20,
          leading: const Icon(Icons.phone, color: Colors.cyan),
          trailing: IconButton(
            onPressed: onPressed, 
            icon: const Icon(Icons.edit, color: Colors.cyan,)),
          title: Text(title),
        ),
      ),
    ),
  );
}

Widget signOut(Function()? onTap) {
  return Container(
    padding: const EdgeInsets.only(left: 15, right: 15),
    child: Card(
      elevation: 1.5,
      child: Padding(
        padding: const EdgeInsets.only(left: 0, right: 0),
        child: ListTile(
          minLeadingWidth: 20,
          leading: const Icon(Icons.logout_outlined, color: Colors.cyan,),
          trailing: const Icon(Icons.arrow_forward_ios, color: Colors.cyan,),
          title: const Text('Sign Out.'),
          onTap: onTap,
        ),
      ),
    ),
  );
}
