// ignore: import_of_legacy_library_into_null_safe
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hostnstay/screens/propertyDetails/details.dart';
import 'package:hostnstay/widgets/largetext.dart';
import 'package:hostnstay/widgets/skeleton.dart';

import '../../widgets/carousel_widget.dart';

class FindPlace extends StatefulWidget {
  const FindPlace({super.key});

  @override
  State<FindPlace> createState() => _FindPlaceState();
}

class _FindPlaceState extends State<FindPlace> {
  CollectionReference firecollection =
      FirebaseFirestore.instance.collection("propertyDetails");
  TextEditingController searchCont = TextEditingController();
  String title = "";
  List imageURLs = [];
  late String price;
  late String location;
  List<NetworkImage> images = <NetworkImage>[];
  late String text;
  late String rating;

  navigateToDetails(DocumentSnapshot properyDetails) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                DetailsPage(propertyDetails: properyDetails, imageList: images,)));
  }

  @override
  void initState() {
    super.initState();
    // title = searchCont.text.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.cyan,
        title: Center(
          child: TextFormField(
            onChanged: (value) {
              setState(() {
                title = value;
              });
            },
            controller: searchCont,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.cyan)),
              hintText: 'Search for homes, spaces...',
              hintStyle:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              suffixIcon: IconButton(
                  onPressed: () {
                    searchCont.clear();
                  },
                  icon: const Icon(Icons.clear)),
            ),
          ),
        ),
      ),
      body: StreamBuilder(
          stream: firecollection.snapshots().asBroadcastStream(),
          builder: (BuildContext context, snapshot) {
            if (!snapshot.hasData) {
              // return showLoaderDialog(context, "searching...");
              return Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.search, size: 30,),
                    LargeText(size: 25, text: 'search here')
                  ],
                ),
              );
            } else {
              if (snapshot.data!.docs
                  .where((QueryDocumentSnapshot<Object?> element) =>
                      element["title"]
                          .toString()
                          .toLowerCase()
                          .contains(title.toLowerCase()))
                  .isEmpty) {
                return Center(
                  child: LargeText(size: 22, text: "😞 No Results Found."),
                );
              } else {
                //get data from db
                return ListView(
                  children: [
                    ...snapshot.data!.docs
                        .where((QueryDocumentSnapshot<Object?> element) =>
                            element["location"]
                                .toString()
                                .toLowerCase()
                                .contains(title.toLowerCase()))
                        .map((QueryDocumentSnapshot<Object?> document) {
                      String title = document.get("title");
                      imageURLs = [];
                      imageURLs = document.get('imageUrls');
                      price = document.get('price');
                      location = document.get('location');
                      title = document.get('title');
                      rating = document.get('rating');
                      images = [];
                      for (int i = 0; i < imageURLs.length; i++) {
                        images.add(
                          NetworkImage(imageURLs[i]),
                        );
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
                                  height: 160,
                                  width:
                                      MediaQuery.of(context).size.width / 0.9,
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Carousel(images: images),
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
                    })
                  ],
                );
              }
            }
          }),
    );
  }
}
