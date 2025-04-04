import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hostnstay/screens/navpages/profile.dart';
import 'package:hostnstay/utils/take_picture_page.dart';
import 'package:image_picker/image_picker.dart';

class IdScan extends StatefulWidget {
  const IdScan({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _IdScanState createState() => _IdScanState();
}

class _IdScanState extends State<IdScan> {
  String? _path;
  String? path;

  _showPhotoLibrary() async {
    XFile? file = await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      _path = file?.path;
    });
  }

  showPhotoLibrary() async {
    XFile? ifile = await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      path = ifile?.path;
    });
  }

  void _showCamera() async {
    final cameras = await availableCameras();
    final camera = cameras.first;

    // ignore: use_build_context_synchronously
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TakePicturePage(camera: camera)));

    setState(() {
      _path = result;
    });
  }

  void showCamera() async {
    final cameras = await availableCameras();
    final camera = cameras.first;

    // ignore: use_build_context_synchronously
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TakePicturePage(camera: camera)));

    setState(() {
      path = result;
    });
  }

  void _showOptions(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return SizedBox(
              height: 150,
              child: Column(children: <Widget>[
                ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      _showCamera();
                    },
                    leading: const Icon(Icons.photo_camera),
                    title: const Text("Take a picture from camera")),
                ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      _showPhotoLibrary();
                    },
                    leading: const Icon(Icons.photo_library),
                    title: const Text("Choose from photo library"))
              ]));
        });
  }

  void showOptions(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return SizedBox(
              height: 150,
              child: Column(children: <Widget>[
                ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      showCamera();
                    },
                    leading: const Icon(Icons.photo_camera),
                    title: const Text("Take a picture from camera")),
                ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      showPhotoLibrary();
                    },
                    leading: const Icon(Icons.photo_library),
                    title: const Text("Choose from photo library"))
              ]));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("upload id"),
          centerTitle: true,
          backgroundColor: Colors.cyan,
        ),
        body: SafeArea(
          child: Column(children: <Widget>[
            const SizedBox(
              height: 10,
            ),
            _path == null
                ? Center(
                    child: Image.asset(
                    'img/place-holder.png',
                  ))
                : Container(
                    height: 120,
                    width: MediaQuery.of(context).size.width / 1.1,
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(8)),
                    child: Image.file(File(_path!), width: MediaQuery.of(context).size.width / 1.1,)),
            ElevatedButton(
              child: const Text("capture front side",
                  style: TextStyle(color: Colors.white)),
              onPressed: () {
                _showOptions(context);
              },
            ),
            const SizedBox(
              height: 5,
            ),
            path == null
                ? Image.asset("img/place-holder.png")
                : Container(
                    height: 120,
                    width: MediaQuery.of(context).size.width / 1.1,
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(8)),
                    child: Image.file(File(path!), width: MediaQuery.of(context).size.width / 1.1,)),
            ElevatedButton(
              child: const Text("capture back side",
                  style: TextStyle(color: Colors.white)),
              onPressed: () {
                showOptions(context);
              },
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ProfilePage()));
                  Fluttertoast.showToast(msg: "upload succesful");
                },
                child: const Text('submit'))
          ]),
        ));
  }
}
