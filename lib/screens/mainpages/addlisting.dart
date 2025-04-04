import 'dart:async';
// ignore: import_of_legacy_library_into_null_safe
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hostnstay/screens/mainpages/pickaddress.dart';
import 'package:hostnstay/screens/navpages/bottomnav.dart';
import 'package:hostnstay/screens/propertyDetails/uploadimages.dart';
import 'package:hostnstay/utils/showsnackbar.dart';
import 'package:hostnstay/utils/successmsg.dart';
import 'package:hostnstay/widgets/largetext.dart';
import 'package:hostnstay/widgets/showprogress.dart';
import 'package:hostnstay/widgets/uploadlisting.dart';

class AddListing extends StatefulWidget {
  const AddListing({Key? key}) : super(key: key);

  @override
  State<AddListing> createState() => _AddListingState();
}

class _AddListingState extends State<AddListing> {
  User? user;
  late CollectionReference propertyDetail;
  late firebase_storage.Reference ref;
  late StreamSubscription sub;
  bool isConnected = false;
  List urls = [];
  late String mycategory = "";
  late String rating = "No rating";

  final _key = GlobalKey<FormState>();
  late final TextEditingController titleController;
  late final TextEditingController locController;
  late final TextEditingController descController;
  late final TextEditingController priceController;
  late final SingleValueDropDownController catController = SingleValueDropDownController();

  @override
  void initState() {
    titleController = TextEditingController();
    locController = TextEditingController();
    descController = TextEditingController();
    priceController = TextEditingController();

    sub = Connectivity().onConnectivityChanged.listen(((event) {
      isConnected = (event != ConnectivityResult.none);
    }));

    user = FirebaseAuth.instance.currentUser;
    propertyDetail = FirebaseFirestore.instance.collection('propertyDetails');
    super.initState();
  }

  void saveDetails() async {
    var title = titleController.text.trim();
    var location = locController.text.trim();
    var description = descController.text.trim();
    var price = priceController.text.trim();
    if (_key.currentState!.validate()) {
      if (isConnected = true) {
        showLoaderDialog(context, 'saving details...');
        try {
          await propertyDetail.doc(user!.uid).set({
            'title': title,
            'location': location,
            'price': price,
            'description': description,
            'imageUrls': urls,
            'category': mycategory,
            'rating': rating,
            'locationCoords': ''
          });
          if (!mounted) return;
          Navigator.pop(context);
          showSuccessMsg(context, 'Details uploaded Succesfully');
        } on firebase_storage.FirebaseException catch (e) {
          showSnackBar(context, e.message!.toString());
        }
      } else {
        Navigator.pop(context);
        Fluttertoast.showToast(msg: 'check your connection');
      }
    } else {
      Fluttertoast.showToast(msg: 'check your connection');
    }
  }

  @override
  void dispose() {
    sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.black,
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const BottomNav()));
          },
        ),
        backgroundColor: const Color.fromARGB(255, 122, 221, 235),
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.cyan),
        title: LargeText(size: 24, text: 'Add Listing Details'),
        centerTitle: true,
        elevation: 3,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              key: _key,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  heading('Title'),
                  field('Enter listing title', titleController),
                  const SizedBox(height: 3),
                  heading('Price'),
                  field('Enter your price', priceController,
                      TextInputType.number),
                  const SizedBox(height: 3),
                  heading('Location'),
                  const SizedBox(
                    height: 3,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 8),
                    child: DropDownTextField(
                      controller: catController,
                      clearOption: false,
                      enableSearch: false,
                      dropDownItemCount: 5,
                      textFieldDecoration: const InputDecoration(
                        filled: true,
                        labelText: 'Category',
                        hintText: 'Select a Category',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please select a category";
                        }
                        return null;
                      },
                      dropDownList: const [
                        DropDownValueModel(
                            name: "modernhomes", value: "modernhomes"),
                        DropDownValueModel(
                            name: "apartments", value: "apartments"),
                        DropDownValueModel(name: "villas", value: "villas"),
                        DropDownValueModel(name: "rooms", value: "rooms"),
                        DropDownValueModel(name: "homes", value: "homes"),
                      ],
                      onChanged: (val) {
                        setState(() {
                          mycategory = val?.value; // val is DropDownValueModel?
                        });
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const PickAddress()));
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => const MapScreen()));
                      },
                      child: const Text('add location'),
                    ),
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => const GpsLocation()));
                      },
                      child: const Text('Use Current Location'),
                    ),
                  ),
                  location(locController),
                  const SizedBox(height: 3),
                  heading('Description'),
                  field(
                      'Describe the apartment, room, house or outdoor space that you\'re renting out',
                      descController,
                      TextInputType.multiline,
                      6,
                      8),
                  const SizedBox(height: 5),
                  const Padding(
                    padding: EdgeInsets.only(left: 20, right: 20, bottom: 8),
                    child: Text(
                      'Property Images',
                      style: TextStyle(fontSize: 22),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.greenAccent,
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const AddImagesPage()));
                        },
                        icon: const Icon(Icons.add_a_photo),
                        label: const Text(
                          'Select Images to Upload',
                          style: TextStyle(fontSize: 16),
                        )),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    height: 50,
                    width: MediaQuery.of(context).size.width / 1.0,
                    child: ElevatedButton(
                        onPressed: saveDetails,
                        child: const Text('Save Details.')),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

// 'address': '${this.placeName}:${this.restaurantAddress}',
// 'location': GeoPoint(this.restaurantLatitude, this.restaurantLongitude),
