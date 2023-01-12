import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddImagesPage extends StatefulWidget {
  const AddImagesPage({Key? key}) : super(key: key);

  @override
  State<AddImagesPage> createState() => _AddImagesPageState();
}

class _AddImagesPageState extends State<AddImagesPage> {
  bool uploading = false;
  double val = 0;
  late User user;
  late String userEmail;

  // late CollectionReference propertyRef;
  late DocumentReference propertyRef;
  late firebase_storage.Reference ref;
  late DatabaseReference imgRef =
      FirebaseDatabase.instance.ref().child('propertyImages');
  List<File> images = [];

  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser!;
    var uid = user.uid;
    userEmail = user.email!;

    imgRef = FirebaseDatabase.instance.ref().child('propertyImages');
    // propertyRef = FirebaseFirestore.instance.collection('propertyDetails');
    propertyRef = FirebaseFirestore.instance.doc('propertyDetails/$uid');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        title: const Text('Add Images'),
        actions: [
          TextButton(
              onPressed: () {
                setState(() {
                  uploading = true;
                });
                upLoadFiles().whenComplete(() => Navigator.of(context).pop);
                Navigator.pop(context);
                Navigator.of(context).pop;
              },
              child: const Text('Upload'))
        ],
      ),
      body: Stack(
        children: [
          GridView.builder(
              itemCount: images.length + 1,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3),
              itemBuilder: (context, index) {
                return index == 0
                    ? Center(
                        child: IconButton(
                          icon: const Icon(Icons.add_a_photo),
                          onPressed: () {
                            !uploading ? pickImageFromGallery() : null;
                          },
                        ),
                      )
                    : Container(
                        margin: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: FileImage(images[index - 1]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
              }),
          uploading
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'uploading...',
                        style: TextStyle(fontSize: 20),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CircularProgressIndicator(
                        value: val,
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                    ],
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  pickImageFromGallery() async {
    XFile? xFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (xFile == null) return;
    final pickedFile = File(xFile.path);
    setState(() {
      images.add(pickedFile);
    });
  }

  //upload images to firebase storage
  Future upLoadFiles() async {
    List<String> urls = [];
    for (int i = 0; i < images.length; i++) {
      ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('propertyImages/$userEmail/$i');
      await ref.putFile(images[i]);
      String imageUrl = await ref.getDownloadURL();
      urls.add(imageUrl);
    }
    // await propertyRef.doc(user!.uid).update({
    //   "imageUrls": urls,
    // });

    await propertyRef.update({
      "imageUrls": urls,
    });
  }
}
