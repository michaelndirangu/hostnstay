// ignore: import_of_legacy_library_into_null_safe
import 'dart:async';

// ignore: import_of_legacy_library_into_null_safe
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hostnstay/screens/propertyDetails/details.dart';
import 'package:hostnstay/widgets/carousel_widget.dart';
import 'package:hostnstay/widgets/largetext.dart';
import 'package:hostnstay/widgets/skeleton.dart';

class RecommendPage extends StatefulWidget {
  const RecommendPage({Key? key}) : super(key: key);

  @override
  State<RecommendPage> createState() => _RecommendPageState();
}

class _RecommendPageState extends State<RecommendPage> {
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
  late Position _currentPosition;
  double lat = 0.0;
  double long = 0.0;
  late String loc = "";
  CollectionReference firecollection =
      FirebaseFirestore.instance.collection("propertyDetails");

  Future<QuerySnapshot>? listingDocumentList;
  String title = '';
  var address = "";
  late StreamSubscription<Position> streamSubscription;

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
            builder: (context) => DetailsPage(
                  propertyDetails: properyDetails,
                  imageList: images,
                )));
  }

  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser;
    _getCurrentPosition();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("For You"),
          centerTitle: true,
          backgroundColor: Colors.cyan,
        ),
        body: StreamBuilder(
            // stream: FirebaseFirestore.instance.collection("propertyDetails").snapshots(),
            stream: firecollection.where("rating", isGreaterThanOrEqualTo: "3").snapshots().asBroadcastStream(),
            builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
              // propertyListings = snapshot.data!.docs;
              if (!snapshot.hasData) {
                // return showLoaderDialog(context, "searching...");
                return Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.search,
                        size: 30,
                      ),
                      LargeText(size: 25, text: 'Recommended')
                    ],
                  ),
                );
              } else {
                if (snapshot.data!.docs
                    .where((QueryDocumentSnapshot<Object?> element) =>
                        element["location"]
                            .toString()
                            .toLowerCase()
                            .contains(address.toLowerCase()))
                    .isEmpty) {
                  return Center(
                    child: LargeText(
                        size: 22,
                        text: "😞 no listings available in your area."),
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
                                  .contains(address.toLowerCase()))
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
            }));
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;
    // await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
    //     .then((Position position) {
    //   setState(() => _currentPosition = position);
    //   lat = _currentPosition.latitude;
    //   long = _currentPosition.longitude;
    //   getAddress(position);
    // }).catchError((e) {
    //   debugPrint(e);
    // });
    streamSubscription =
        Geolocator.getPositionStream().listen((Position position) {
      lat = _currentPosition.latitude;
      long = _currentPosition.longitude;
      getAddress(position);
    });
  }

  Future<void> getAddress(Position position) async {
    List<Placemark> placemark = await placemarkFromCoordinates(lat, long);
    Placemark place = placemark[0];
    address = "${place.locality},${place.administrativeArea}";
    print(address);
  }
}
