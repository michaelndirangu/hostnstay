// ignore: import_of_legacy_library_into_null_safe
import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter/material.dart';
import 'package:hostnstay/screens/navpages/findplace.dart';
import 'package:hostnstay/screens/propertyDetails/details.dart';
import 'package:hostnstay/utils/warningmsg.dart';
import 'package:hostnstay/widgets/largetext.dart';
import 'package:hostnstay/widgets/searchinput.dart';
import 'package:hostnstay/widgets/showprogress.dart';
import 'dart:async';

import 'package:hostnstay/widgets/skeleton.dart';

import '../../widgets/carousel_widget.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  CollectionReference firecollection =
      FirebaseFirestore.instance.collection("propertyDetails");
  TextEditingController searchCont = TextEditingController();
  TextEditingController minCont = TextEditingController();
  TextEditingController maxCont = TextEditingController();
  TextEditingController locationCont = TextEditingController();
  TextEditingController ratingCont = TextEditingController();
  late String category = "";
  String title = "";
  List imageURLs = [];
  late String price;
  late String location;
  List<NetworkImage> images = <NetworkImage>[];
  late String text;
  late String rating;
  bool searching = false;
  late String minPrice;
  late final SingleValueDropDownController catController =
      SingleValueDropDownController();
  final CollectionReference collection =
      FirebaseFirestore.instance.collection('propertyDetails');
  late Stream<QuerySnapshot> searchresults;

  clearInput(TextEditingController cont) {
    cont.clear();
  }

  Stream<QuerySnapshot> getStream() {
    /// Perform your 5 condition here
    return collection.snapshots();
  }

  Stream<QuerySnapshot> getData() {
    List<Stream<QuerySnapshot>> streams = [];
    var queryOne =
        collection.where("category", isEqualTo: category).snapshots();

    var queryTwo =
        collection.where("location", isEqualTo: locationCont.text).snapshots();

    var queryThree =
        collection.where("rating", isEqualTo: ratingCont.text).snapshots();

    var queryFour = collection
        .where("price", isGreaterThanOrEqualTo: minCont.text)
        .snapshots();

    var queryFive = collection
        .where("price", isLessThanOrEqualTo: maxCont.text)
        .snapshots();

    streams.add(queryOne);
    streams.add(queryTwo);
    streams.add(queryThree);
    streams.add(queryFour);
    streams.add(queryFive);

    Stream<QuerySnapshot> results = StreamGroup.merge(streams);
    // results.listen((QuerySnapshot querySnapshot) {
    //   querySnapshot.docs.forEach((document) => print(document.data()));
    //   setState(() {
    //       querySnapshot.docs.forEach((document) => searchresults = document as Stream<QuerySnapshot<Object?>>);
    //   });
    // });
    return results;
  }

  navigateToDetails(DocumentSnapshot properyDetails) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DetailsPage(
                  propertyDetails: properyDetails,
                  imageList: images,
                )));
  }

  // Stream getStreams() {
  //   List<Stream> streams = [];
  //   streams.add(FirebaseFirestore.instance
  //       .collection("propertyDetails")
  //       .where("category", isEqualTo: mycategory)
  //       .snapshots());
  //   streams.add(FirebaseFirestore.instance
  //       .collection("propertyDetails")
  //       .where("location", isEqualTo: locationCont)
  //       .snapshots());
  //   streams.add(FirebaseFirestore.instance
  //       .collection("propertyDetails")
  //       .where("rating", isEqualTo: ratingCont)
  //       .snapshots());
  //   streams.add(FirebaseFirestore.instance
  //       .collection("propertyDetails")
  //       .where("price", isGreaterThanOrEqualTo: minCont)
  //       .snapshots());
  //   streams.add(FirebaseFirestore.instance
  //       .collection("propertyDetails")
  //       .where("price", isLessThanOrEqualTo: maxCont)
  //       .snapshots());
  //   return StreamGroup.merge(streams);
  // }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Search for a place"),
          centerTitle: true,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.blue,
        ),
        body: searching
            ? StreamBuilder(
                // stream: FirebaseFirestore.instance
                //     .collection("propertyDetails")
                //     .where('category', isEqualTo: category)
                //     .snapshots(),
                // builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
                //   if (snapshot.connectionState == ConnectionState.waiting) {
                //     return const ShimmerLoading();
                //   } else {
                //     if (
                //         (snapshot.data!.docs
                //             .where((QueryDocumentSnapshot<Object?> element) =>
                //                 element["location"]
                //                     .toString()
                //                     .toLowerCase()
                //                     .contains(title.toLowerCase()))
                //             .isEmpty)) {
                //       return Center(
                //         child:
                //             LargeText(size: 22, text: "😞 No Results Found."),
                //       );
                //     } else {
                //       return ListView(
                //         children: [
                //           ...snapshot.data!.docs
                //               .where((QueryDocumentSnapshot<Object?> element) =>
                //                   element["location"]
                //                       .toString()
                //                       .toLowerCase()
                //                       .contains(title.toLowerCase()))
                //               .map((QueryDocumentSnapshot<Object?> document) {
                //             String title = document.get("location");
                //             imageURLs = [];
                //             imageURLs = document.get('imageUrls');
                //             price = document.get('price');
                //             location = document.get('location');
                //             title = document.get('title');
                //             rating = document.get('rating');
                //             images = [];
                //             for (int i = 0; i < imageURLs.length; i++) {
                //               images.add(
                //                 NetworkImage(imageURLs[i]),
                //               );
                //             }

                //             return Padding(
                //               padding: const EdgeInsets.only(
                //                   left: 19, right: 19, top: 7),
                //               child: GestureDetector(
                //                 onTap: () => navigateToDetails(document),
                //                 child: Container(
                //                   decoration: BoxDecoration(
                //                       border: Border.all(
                //                         color: Colors.black,
                //                         width: 2,
                //                         style: BorderStyle.solid,
                //                       ),
                //                       borderRadius: BorderRadius.circular(15)),
                //                   child: Column(
                //                     mainAxisAlignment: MainAxisAlignment.start,
                //                     crossAxisAlignment:
                //                         CrossAxisAlignment.start,
                //                     children: [
                //                       Container(
                //                         height: 120,
                //                         width:
                //                             MediaQuery.of(context).size.width /
                //                                 0.9,
                //                         decoration: BoxDecoration(
                //                           color: Colors.transparent,
                //                           borderRadius:
                //                               BorderRadius.circular(14),
                //                         ),
                //                         child: Carousel(
                //                           images: images,
                //                           dotSpacing: 15,
                //                           boxFit: BoxFit.cover,
                //                           dotSize: 4,
                //                           autoplay: false,
                //                           dotBgColor: Colors.transparent,
                //                           dotColor: Colors.blue,
                //                           dotVerticalPadding: 5,
                //                           indicatorBgPadding: 5,
                //                           defaultImage: const AssetImage(
                //                               "img/thumbnail.png"),
                //                           borderRadius: true,
                //                           radius: const Radius.circular(12),
                //                         ),
                //                       ),
                //                       const SizedBox(
                //                         height: 5,
                //                       ),
                //                       smallDetails(
                //                           title, rating, location, price),
                //                       const SizedBox(
                //                         height: 3,
                //                       )
                //                     ],
                //                   ),
                //                 ),
                //               ),
                //             );
                //           })
                //         ],
                //       );
                //     }
                //   }
                // },
                stream: firecollection
                    .where("category", isEqualTo: category)
                    .where("price", isEqualTo: minCont.text)
                    .where("location", isEqualTo: locationCont.text)
                    .snapshots()
                    .asBroadcastStream(),
                builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
                  // propertyListings = snapshot.data!.docs;
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: LargeText(size: 22, text: "😞 No Results Found."),
                    );
                  } else {
                    if (snapshot.hasData == false) {
                      return Center(
                        child:
                            LargeText(size: 22, text: "😞 No Results Found."),
                      );
                    } else {
                      return ListView(
                        children: [
                          ...snapshot.data!.docs
                              .map((QueryDocumentSnapshot<Object?> document) {
                            String title = document.get("category");
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
                              padding: const EdgeInsets.only(
                                  left: 19, right: 19, top: 7),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                          height: 120,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              0.9,
                                          decoration: BoxDecoration(
                                            color: Colors.transparent,
                                            borderRadius:
                                                BorderRadius.circular(14),
                                          ),
                                          child: Carousel(
                                              images: images)),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      smallDetails(
                                          title, rating, location, price),
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
                })
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 70,
                        child: TextFormField(
                          // onChanged: (value) {
                          //   setState(() {
                          //     title = "value";
                          //   });
                          // },
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const FindPlace()));
                          },
                          obscureText: false,
                          controller: searchCont,
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              labelText: 'search for space',
                              labelStyle: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  overflow: TextOverflow.fade),
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    searchCont.clear();
                                  },
                                  icon: const Icon(
                                    Icons.clear,
                                    color: Colors.cyan,
                                  )),
                              focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue))),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      LargeText(
                          size: 22, text: 'Select preferred listing features.'),
                      const SizedBox(
                        height: 4,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20, right: 20, bottom: 8),
                        child: DropDownTextField(
                          controller: catController,
                          clearOption: false,
                          enableSearch: false,
                          dropDownItemCount: 5,
                          textFieldDecoration: const InputDecoration(
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
                              category =
                                  val?.value; // val is DropDownValueModel?
                            });
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      LargeText(size: 22, text: "Price Range"),
                      const SizedBox(
                        height: 4,
                      ),
                      Row(
                        children: [
                          SizedBox(
                              width: 140,
                              child: specificSearch(
                                  minCont, TextInputType.number, "Min", () {
                                minCont.clear();
                              })),
                          const Spacer(),
                          SizedBox(
                              width: 140,
                              child: specificSearch(
                                  maxCont, TextInputType.number, "Max", () {
                                maxCont.clear();
                              }))
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      LargeText(size: 22, text: 'Location'),
                      const SizedBox(
                        height: 3,
                      ),
                      specificSearch(locationCont, TextInputType.text,
                          "enter desired location", () {
                        locationCont.clear();
                      }),
                      const SizedBox(
                        height: 8,
                      ),
                      LargeText(size: 22, text: 'Rating'),
                      const SizedBox(
                        height: 3,
                      ),
                      specificSearch(ratingCont, TextInputType.number, 'rating',
                          () {
                        ratingCont.clear();
                      }),
                      const SizedBox(
                        height: 8,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 1.0,
                        child: ElevatedButton(
                            onPressed: () {
                              if (minCont.text.isEmpty &&
                                  maxCont.text.isEmpty &&
                                  locationCont.text.isEmpty &&
                                  ratingCont.text.isEmpty) {
                                showWarningMsg(
                                    context, 'please fill out all the fields');
                              } else {
                                setState(() {
                                  searching = true;
                                  title = locationCont.text;
                                });
                              }
                            },
                            child: const Text("search for listing")),
                      )
                    ],
                  ),
                ),
              ));
  }

  Widget buildResults(BuildContext context) {
    return StreamBuilder(
        stream: firecollection.snapshots().asBroadcastStream(),
        builder: (BuildContext context, snapshot) {
          if (!snapshot.hasData) {
            return showLoaderDialog(context, "searching...");
          } else {
            //get data from db
            return ListView(
              children: [
                ...snapshot.data!.docs
                    .where((QueryDocumentSnapshot<Object?> element) =>
                        element["title"]
                            .toString()
                            .toLowerCase()
                            .contains(title.toLowerCase()))
                    .map((QueryDocumentSnapshot<Object?> data) {
                  final String title = data.get("title");

                  return ListTile(
                    title: LargeText(size: 22, text: title),
                  );
                })
              ],
            );
          }
        });
  }
}
