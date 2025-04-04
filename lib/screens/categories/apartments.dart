// ignore: import_of_legacy_library_into_null_safe
import 'dart:async';

// ignore: import_of_legacy_library_into_null_safe
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hostnstay/screens/propertyDetails/details.dart';
import 'package:hostnstay/widgets/carousel_widget.dart';
import 'package:hostnstay/widgets/hmepageshimmer.dart';
import 'package:hostnstay/widgets/skeleton.dart';

class Apartments extends StatefulWidget {
  const Apartments({Key? key}) : super(key: key);

  @override
  State<Apartments> createState() => _ApartmentsState();
}

class _ApartmentsState extends State<Apartments> {
  late CollectionReference listings;
  User? user;
  bool isConnected = false;
  late StreamSubscription sub;
  List imageURLs = [];
  late String price;
  late String location;
  List<NetworkImage> images = <NetworkImage>[];
  late String text;
  late String rating;
  TextEditingController textController = TextEditingController();
  bool hascontent = true;
  late List propertyListings;

  Future<QuerySnapshot>? listingDocumentList;
  String title = '';

  initSearchingList(String value) {
    listingDocumentList = FirebaseFirestore.instance
        .collection('propertyDetails')
        .where('location', isGreaterThanOrEqualTo: value)
        .get();

    setState(() {
      listingDocumentList;
    });
  }


  getListings() async {
    var firestore = FirebaseFirestore.instance;
    QuerySnapshot qsnap = await firestore.collection('propertyDetails').get();
    return qsnap.docs;
  }

  navigateToDetails(DocumentSnapshot properyDetails) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                DetailsPage(propertyDetails: properyDetails, imageList: images,)));
  }

  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser;
    // setState(() {
    //   propertyListings = listingDocumentList as List;
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   title: Center(
        //     child: Container(
        //       height: 60,
        //       padding:
        //           const EdgeInsets.only(left: 8, right: 8, top: 5, bottom: 5),
        //       child: TextFormField(
        //         onChanged: (value) {
        //           setState(() {
        //             title = value;
        //           });
        //           initSearchingList(value);
        //         },
        //         controller: textController,
        //         decoration: InputDecoration(
        //           border: const UnderlineInputBorder(
        //               borderSide: BorderSide(color: Colors.cyan)),
        //           hintText: 'Search for homes, spaces...',
        //           hintStyle: const TextStyle(
        //               fontSize: 18, fontWeight: FontWeight.bold),
        //           prefixIcon: IconButton(
        //             onPressed: () {
        //               initSearchingList(title);
        //             },
        //             icon: const Icon(Icons.search),
        //           ),
        //           suffixIcon: IconButton(
        //               onPressed: () {
        //                 textController.clear();
        //               },
        //               icon: const Icon(Icons.clear)),
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
        body: StreamBuilder(
            // stream: FirebaseFirestore.instance.collection("propertyDetails").snapshots(),
            stream: FirebaseFirestore.instance
                .collection("propertyDetails")
                .where('category', isEqualTo: 'apartments' )
                .snapshots(),
            // .where("category", isEqualTo: "modernhomes")
            // .snapshots(),
            builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
              // propertyListings = snapshot.data!.docs;
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const ShimmerLoading();
              } else {
                return ListView(
                    children: snapshot.data!.docs.map((document) {
                      imageURLs = [];
                      imageURLs = document.get('imageUrls');
                      price = document.get('price');
                      location = document.get('location');
                      title = document.get('title');
                      rating = document.get('rating');
                      images = [];
                      for (int i = 0; i < imageURLs.length; i++) {
                        images.add(NetworkImage(imageURLs[i]));
                      }
                      return Padding(
                        padding:
                            const EdgeInsets.only(left: 19, right: 19, top: 7),
                        child: GestureDetector(
                          onTap: () => navigateToDetails(document),
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black,
                                  width: 2,
                                  style: BorderStyle.solid,
                                ),
                                borderRadius: BorderRadius.circular(15)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 220,
                                  width:
                                      MediaQuery.of(context).size.width / 0.9,
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Carousel(
                                    images: images,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                smallDetails(title, rating, location, price),
                                const SizedBox(
                                  height: 3,
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
              }
            })
            );
  }
}
