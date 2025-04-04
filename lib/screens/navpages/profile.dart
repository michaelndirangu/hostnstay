import 'dart:io';

import 'package:blurry/blurry.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hostnstay/data/userdata/usermodel.dart';
import 'package:hostnstay/screens/authentication/login.dart';
import 'package:hostnstay/screens/authentication/scan.dart';
import 'package:hostnstay/screens/mainpages/addlisting.dart';
import 'package:hostnstay/services/profilemethods.dart';
import 'package:hostnstay/utils/logoutdialog.dart';
import 'package:hostnstay/utils/showsnackbar.dart';
import 'package:hostnstay/widgets/profiledetails.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ndialog/ndialog.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController phoneNoController = TextEditingController();
  User? user;
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  UserModel? userModel;
  late DatabaseReference userRef =
      FirebaseDatabase.instance.ref().child('users');

  File? imageFile;
  bool showLocalFile = false;
  var imgHolder = const AssetImage('img/avater.jpg');

  ProfileMethods profilenav = ProfileMethods();

  getUserDetails() async {
    DataSnapshot snapshot = await userRef.get();

    userModel =
        UserModel.fromMap(Map<String, dynamic>.from(snapshot.value as Map));
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userRef = FirebaseDatabase.instance.ref().child('users').child(user!.uid);
    }
    getUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile Details',
          style: TextStyle(fontSize: 18),
        ),
        automaticallyImplyLeading: true,
        centerTitle: true,
        backgroundColor: Colors.cyan,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            profileImage(),
            const SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        userModel?.firstName ?? '',
                        style: GoogleFonts.amita(
                            textStyle: const TextStyle(
                          fontSize: 20,
                        )),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            profiledetail(Icons.email, userModel?.email ?? ''),
            phonedetail(userModel?.tel ?? '', editPhone),
            profileDetail(Icons.payment_outlined, 'Payment Details',
                Icons.arrow_forward_ios, profilenav.paymentpage),
            profileDetail(Icons.perm_identity_outlined, 'Personal Documents',
                Icons.arrow_forward_ios, () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const MyWidget()));
            }),
            profileDetail(
                Icons.copy, 'Terms and Conditions.', Icons.arrow_forward_ios),
            signOut(logout),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FloatingActionButton.extended(
                    elevation: 8,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AddListing()));
                    },
                    label: const Text('Add Listing'),
                    icon: const Icon(Icons.add_box),
                    backgroundColor: Colors.blue,
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  Widget profileImage() {
    return Center(
      child: Stack(children: <Widget>[
        CircleAvatar(
          radius: 80,
          // backgroundImage: showLocalFile
          //     ? FileImage(imageFile!)
          //     : userModel?.profileImage == ''
          //         ? const AssetImage('img/avater.jpg') as ImageProvider
          //         : NetworkImage(userModel!.profileImage),
          backgroundImage: showLocalFile
              ? FileImage(imageFile!)
              : userModel?.profileImage == ''
                  ? const AssetImage('img/avater.jpg') as ImageProvider
                  : NetworkImage(userModel?.profileImage ?? ''),
        ),
        Positioned(
          bottom: 15,
          right: 15,
          child: InkWell(
            onTap: () {
              showModalBottomSheet(
                  context: context, builder: ((builder) => bottomSheet()));
            },
            child: const Icon(
              Icons.camera_alt,
              color: Colors.cyan,
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
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          const Text(
            'Choose a Profile Photo',
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              TextButton.icon(
                icon: const Icon(Icons.camera),
                label: const Text('Camera'),
                onPressed: pickImageFromCamera,
              ),
              TextButton.icon(
                icon: const Icon(Icons.browse_gallery),
                label: const Text('Gallery'),
                onPressed: pickImageFromGallery,
              )
            ],
          )
        ],
      ),
    );
  }

  pickImageFromGallery() async {
    XFile? xFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (xFile == null) return;
    final tempImage = File(xFile.path);
    imageFile = tempImage;
    showLocalFile = true;
    setState(() {});

    //upload to firebase storage
    if (!mounted) return;
    ProgressDialog progressDialog = ProgressDialog(
      context,
      title: const Text('Uploading Image.'),
      message: const Text('Please wait.'),
    );
    progressDialog.show();
    try {
      var fileName = '${userModel!.firstName}.jpg';

      UploadTask uploadTask = FirebaseStorage.instance
          .ref()
          .child('profileimages/ $fileName')
          .putFile(imageFile!);
      setState(() {});
      TaskSnapshot snapshot = await uploadTask;
      String profileImageUrl = await snapshot.ref.getDownloadURL();
      if (kDebugMode) {
        print(profileImageUrl);
      }
      DatabaseReference userRef =
          FirebaseDatabase.instance.ref().child('users').child(userModel!.uid);
      await userRef.update({
        'profileImage': profileImageUrl,
      });
      progressDialog.dismiss();
    } catch (e) {
      progressDialog.dismiss();
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  pickImageFromCamera() async {
    XFile? xFile = await ImagePicker().pickImage(source: ImageSource.camera);
    if (xFile == null) return;
    final tempImage = File(xFile.path);

    imageFile = tempImage;
    showLocalFile = true;
    setState(() {});
  }

  //   pickDocument() async {
  //   // XFile? xFile = File
  //   if (xFile == null) return;
  //   final tempImage = File(xFile.path);

  //   imageFile = tempImage;
  //   showLocalFile = true;
  //   setState(() {});
  // }

//Sign Out.
  void logout() async {
    // logoutMsg(context, () async {
    //   try {
    //     await _auth.signOut();
    //     if (!mounted) return;
    //     Navigator.of(context).pushReplacement(
    //         MaterialPageRoute(builder: (context) => const LoginPage()));
    //   } on FirebaseAuthException catch (e) {
    //     showSnackBar(context, e.message!);
    //   }
    // });
    showLogoutDialog(context, () async {
      try {
        await _auth.signOut();
        if (!mounted) return;
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const LoginPage()));
      } on FirebaseAuthException catch (e) {
        showSnackBar(context, e.message!);
      }
    }, () {
      Navigator.pop(context);
    });
  }

  editPhone() async {
    Blurry.input(
      title: 'Edit Phone Number',
      themeColor: Colors.cyan,
      icon: Icons.phone,
      popupHeight: 200,
      textInputType: TextInputType.phone,
      description: 'Edit your phone number below',
      confirmButtonText: 'save',
      onConfirmButtonPressed: () async {
        await userRef.update({'tel': phoneNoController.text.trim()});
        if (!mounted) return;
        Navigator.pop(context);
        Fluttertoast.showToast(msg: 'phone number updated succesfully');
      },
      inputLabel: 'Enter new phone number',
      inputTextController: phoneNoController,
      onCancelButtonPressed: () {
        Navigator.of(context).pop();
      },
    ).show(context);
    setState(() {});
  }
}
