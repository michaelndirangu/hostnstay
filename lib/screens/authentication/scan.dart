import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hostnstay/screens/authentication/register.dart';
import 'package:image_picker/image_picker.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Upload Id"),
          centerTitle: true,
          backgroundColor: Colors.cyan,
        ),
        body: Center(
          child: Column(
            children: [
              const SizedBox(height: 6,),
                          imagea == null
                ? Center(
                    child: Image.asset(
                    'img/place-holder.png',
                  ))
                : Container(
                    height: 170,
                    width: MediaQuery.of(context).size.width / 1.1,
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(8),
                        ),
                    child: Image.file(imagea!, fit: BoxFit.fill,)),
              ElevatedButton(
              child: const Text("capture front side",
                  style: TextStyle(color: Colors.white)),
              onPressed: () {
                showOptionsA(context);
              },
            ),
              const SizedBox(height: 6,),
                          imageb == null
                ? Center(
                    child: Image.asset(
                    'img/place-holder.png',
                  ))
                : Container(
                    height: 170,
                    width: MediaQuery.of(context).size.width / 1.1,
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(8)),
                    child: Image.file(imageb!, fit: BoxFit.cover,),),
              ElevatedButton(
              child: const Text("capture back side",
                  style: TextStyle(color: Colors.white)),
              onPressed: () {
                showOptionsB(context);
              },),
              const SizedBox(
              height: 10,
            ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RegisterPage()));
                    Fluttertoast.showToast(msg: "upload succesful");
                  },
                  child: const Text('submit'))
            ],
          ),
        ));
  }

  File? imagea;
  File? imageb;
  Future pickImageA() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() => imagea = imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future takeImageA() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() => imagea = imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

    Future pickImageB() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() => imageb = imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future takeImageB() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() => imageb = imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }
    void showOptionsA(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return SizedBox(
              height: 150,
              child: Column(children: <Widget>[
                ListTile(
                    onTap: () {
                      Navigator.pop(context);
                    takeImageA();
                    },
                    leading: const Icon(Icons.photo_camera),
                    title: const Text("Take a picture from camera")),
                ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      pickImageA();
                    },
                    leading: const Icon(Icons.photo_library),
                    title: const Text("Choose from photo library"))
              ]));
        });
  }

      void showOptionsB(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return SizedBox(
              height: 150,
              child: Column(children: <Widget>[
                ListTile(
                    onTap: () {
                      Navigator.pop(context);
                    takeImageB();
                    },
                    leading: const Icon(Icons.photo_camera),
                    title: const Text("capture from camera")),
                ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      pickImageB();
                    },
                    leading: const Icon(Icons.photo_library),
                    title: const Text("Choose from photo library"))
              ]));
        });
  }
}
