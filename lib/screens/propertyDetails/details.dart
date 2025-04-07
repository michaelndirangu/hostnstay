// ignore: import_of_legacy_library_into_null_safe

// ignore: import_of_legacy_library_into_null_safe
import 'dart:async';

// ignore: import_of_legacy_library_into_null_safe
// import 'package:carousel_pro/carousel_pro.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hostnstay/data/userdata/ownercontact.dart';
import 'package:timeago/timeago.dart' as timeago;
// import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
// import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hostnstay/screens/booking/reserve.dart';
import 'package:hostnstay/screens/mainpages/mapscreen.dart';
import 'package:hostnstay/utils/showsnackbar.dart';
import 'package:hostnstay/widgets/largetext.dart';
import 'package:hostnstay/widgets/smalltext.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../widgets/carousel_widget.dart';

class DetailsPage extends StatefulWidget {
  final DocumentSnapshot propertyDetails;
  final List<NetworkImage> imageList;
  const DetailsPage(
      {Key? key, required this.propertyDetails, required this.imageList})
      : super(key: key);

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  late List imageURLs = [];
  late List<NetworkImage> images = [];
  int activeIndex = 0;
  final controller = CarouselController();
  double userRating = 3.0;
  IconData? selectedIcon;
  Stream<QuerySnapshot<Map<String, dynamic>>>? stream;
  late String owneruid = "";

  late double lat = -1.286389;
  late double long = 36.817223;
  late CameraPosition kGoogle;
  late List<Marker> markers = [];
  final DateTime now = DateTime.now();
  late GeoPoint geopoint;
  late GoogleMapController mapController;
  ContactModel? hostModel;
  late int pnumber;
  bool booked = false;

  late DatabaseReference userRef =
      FirebaseDatabase.instance.ref().child('users');

  getUserDetails() async {
    DataSnapshot snapshot = await userRef.get();

    hostModel =
        ContactModel.fromMap(Map<String, dynamic>.from(snapshot.value as Map));
    setState(() {});
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  navigateToMap(DocumentSnapshot properyDetails) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MapScreen(
                  geoPoint: geopoint,
                )));
  }

  final Completer<GoogleMapController> _controller = Completer();

  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      if (!mounted) return;
      showSnackBar(context, "ERROR$error");
    });
    return await Geolocator.getCurrentPosition();
  }

  // getownerDetails() async {
  //   DataSnapshot snapshot = await userRef.get();
  //   setState(() {
  //     reviewer = snapshot.child("firstname") as String;
  //     print(reviewer);
  //   });
  //   userModel =
  //       UserModel.fromMap(Map<String, dynamic>.from(snapshot.value as Map));
  //   setState(() {});
  // }

  var features = {
    "wifi.png": "WiFi",
    "bed.png": "Bed",
    "smarttv.jpg": "Smart Tv",
    "shower.png": "Shower",
    "coffee.png": "Coffee Maker"
  };

  @override
  void initState() {
    geopoint = widget.propertyDetails.get('locationCoords');
    setState(() {
      lat = geopoint.latitude;
      long = geopoint.longitude;
    });
    kGoogle = CameraPosition(
      target: LatLng(lat, long),
      zoom: 14.4746,
    );
    markers = <Marker>[
      Marker(
        markerId: const MarkerId('1'),
        position: LatLng(lat, long),
        infoWindow: const InfoWindow(title: 'location'),
      ),
    ];
    owneruid = widget.propertyDetails.get("uid");
    userRef = FirebaseDatabase.instance.ref().child('users').child(owneruid);
    getUserDetails();
    // pnumber = int.parse(hostModel?.tel ?? "");
    stream = FirebaseFirestore.instance
        .collection('reviews')
        .where("uid", isEqualTo: widget.propertyDetails.get("uid"))
        .snapshots();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String price = widget.propertyDetails.get('price');
    String title = widget.propertyDetails.get('title');
    GeoPoint geoPoint = widget.propertyDetails.get('locationCoords');
    String location = widget.propertyDetails.get('location');
    String rating = widget.propertyDetails.get('rating');
    imageURLs = widget.propertyDetails.get('imageUrls');
    owneruid = widget.propertyDetails.get('uid');

    images = [];
    imageURLs = [];
    List imageslist = widget.imageList;
    for (int i = 0; i < imageURLs.length; i++) {
      images.add(NetworkImage(imageURLs[i]));
    }

    print("images passed are ${images} and $imageURLs");
    if (kDebugMode) {
      print(imageslist);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.propertyDetails.get('title')),
        centerTitle: true,
        backgroundColor: Colors.cyan,
        automaticallyImplyLeading: true,
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          width: MediaQuery.of(context).size.width / 1.0,
          padding:
              const EdgeInsets.only(top: 8, bottom: 8, left: 15, right: 15),
          child: booked == false? ElevatedButton(
                        onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Booking(
                                    price: price,
                                    title: title,
                                    location: location,
                                    imageUrls: imageslist,
                                    rating: rating,
                                    owneruid: owneruid)));
                      },
                      // child: image == null?
                      //                Text("No image captured"):
                      //                Image.file(File(image!.path), height: 300,),
                      child: const Text('Book Now'),
            ): ElevatedButton(
              onPressed: (){}, 
              child: const Text("Already Reserved"))
          // child: ElevatedButton(
          // ),
        ),
      ),
      // ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: double.maxFinite,
                  height: 250,
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                  ),
                  child: Carousel(images: widget.imageList), // Remove border, make border optional.
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: LargeText(
                  text: widget.propertyDetails.get('title'), size: 27),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                children: [
                  const Icon(Icons.location_on_outlined, color: Colors.blue),
                  const SizedBox(width: 5),
                  SmallText(text: widget.propertyDetails.get('location')),
                  const Spacer(),
                  SmallText(text: widget.propertyDetails.get('price')),
                  const SizedBox(
                    width: 4,
                  ),
                  const Text('KSH')
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                children: [
                  const Icon(
                    Icons.star,
                    color: Colors.blue,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  LargeText(
                      size: 18, text: widget.propertyDetails.get('rating')),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    LargeText(text: 'Features.', size: 23),
                    TextButton(
                        onPressed: () {}, child: SmallText(text: 'See All'))
                  ],
                )),
            const SizedBox(height: 5),
            Container(
              height: 90,
              width: double.maxFinite,
              margin: const EdgeInsets.only(left: 20),
              child: ListView.builder(
                  itemCount: 5,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (_, index) {
                    return Container(
                      margin: const EdgeInsets.only(right: 30),
                      child: Column(
                        children: [
                          Container(
                            width: 60,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(11),
                              image: DecorationImage(
                                  image: AssetImage(
                                      "img/${features.keys.elementAt(index)}"),
                                  fit: BoxFit.cover),
                            ),
                          ),
                          const SizedBox(height: 5),
                          SizedBox(
                            child: SmallText(
                              text: features.values.elementAt(index),
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: LargeText(text: 'Description', size: 25),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: SmallText(text: widget.propertyDetails.get('description')),
            ),
            const SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 3),
              child: LargeText(text: 'Location of Listing', size: 23),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 8),
              child: GestureDetector(
                onDoubleTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => MapScreen(geoPoint: geoPoint)));
                },
                onLongPress: () => navigateToMap,
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.cyan, width: 3),
                          borderRadius: BorderRadius.circular(14)),
                      height: 200,
                      child: GoogleMap(
                        onMapCreated: (GoogleMapController controller) {
                          _controller.complete(controller);
                        },
                        myLocationEnabled: true,
                        initialCameraPosition: kGoogle,
                        markers: Set<Marker>.of(markers),
                      ),
                    ),
                    Positioned(
                      left: 5,
                      child: IconButton(
                        icon: const Icon(
                          Icons.local_activity,
                          color: Colors.blue,
                        ),
                        onPressed: () async {
                          getUserCurrentLocation().then((value) async {
                            showSnackBar(
                                context, "${value.latitude}${value.longitude}");
                            markers.add(
                              Marker(
                                  markerId: const MarkerId("2"),
                                  position:
                                      LatLng(value.latitude, value.longitude),
                                  infoWindow:
                                      const InfoWindow(title: "my location")),
                            );
                            CameraPosition cameraPosition = CameraPosition(
                                target: LatLng(value.latitude, value.longitude),
                                zoom: 4);
                            final GoogleMapController controller =
                                await _controller.future;
                            controller.animateCamera(
                                CameraUpdate.newCameraPosition(cameraPosition));
                            setState(() {});
                          });
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 2),
              child: LargeText(size: 16, text: "Talk to the owner"),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 8),
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.cyan, width: 2),
                    borderRadius: BorderRadius.circular(12)),
                child: Card(
                  elevation: 1.5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        child: Image.asset(
                          "img/email.png",
                          width: 80,
                          height: 80,
                        ),
                        onTap: () async {
                          String email =
                              Uri.encodeComponent(hostModel?.email ?? "");
                          String subject =
                              Uri.encodeComponent("Details on $title");
                          String body =
                              Uri.encodeComponent("Hi! I'm Flutter Developer");
                          print(subject); //output: Hello%20Flutter
                          Uri mail = Uri.parse(
                              "mailto:$email?subject=$subject&body=$body");
                          if (await launchUrl(mail)) {
                            //email app opened
                          } else {
                            //email app is not opened
                          }
                        },
                      ),
                      GestureDetector(
                        child: Image.asset(
                          "img/whatsapp.jpg",
                          width: 95,
                          height: 95,
                        ),
                        onTap: () async {
                          String whatsapp =
                              Uri.encodeComponent(hostModel?.tel ?? "");
                          var whatsappUrl = Uri.parse(
                              "whatsapp://send?phone=$whatsapp&text=hello");
                          try {
                            launchUrl(whatsappUrl);
                          } catch (e) {
                            //To handle error and display error message
                            showSnackBar(context, "an error occurred");
                          }
                        },
                      ),
                      GestureDetector(
                        child: Image.asset(
                          "img/phone.png",
                          width: 80,
                          height: 80,
                        ),
                        onTap: () async {
                          String phone =
                              Uri.encodeComponent(hostModel?.tel ?? "");
                          Uri phoneno = Uri.parse('tel:$phone');
                          if (await launchUrl(phoneno)) {
                            //dialer opened
                          } else {
                            //dailer is not opened
                          }
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 2),
              child: LargeText(size: 18, text: "Ratings and Reviews"),
            ),
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('reviews')
                    .where("uid", isEqualTo: owneruid)
                    .snapshots(),
                builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox(
                      height: 150,
                      child: Column(
                        children: [
                          Card(
                            elevation: 1.0,
                          )
                        ],
                      ),
                    );
                  } else {
                    if (
                      !snapshot.hasData
                    ){
                      return Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 8),
                        child: Container(
                          height: 150,
                          decoration: BoxDecoration(
                          border: Border.all(color: Colors.cyan, width: 2),
                          borderRadius: BorderRadius.circular(12)),
                          child: Card(
                            elevation: 1.5,
                            child: Row(
                              children: [
                                LargeText(size: 26, text: "No Reviews Yet")
                              ]
                            )
                          )
                        )
                      );
                    } else {
                      return SizedBox(
                      height: 300,
                      width: 600,
                      child: ListView(
                        children: snapshot.data!.docs.map((data) {
                          String rating = data.get('rating');
                          String review = data.get('review');
                          String photourl = data.get('photo');
                          String reviewer = data.get('ratedby');
                          Timestamp date = data.get('ratedon');
                          DateTime ratingdate = date.toDate();
                          userRating = double.parse(rating);
                          String rateddate = timeago.format(ratingdate);
                          // setState(() {
                          //   userRating = double.parse(rating);
                          // });
                          return Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, top: 5),
                            child: Container(
                              height: 150,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.cyan, width: 2),
                                  borderRadius: BorderRadius.circular(12)),
                              child: Card(
                                elevation: 1.5,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8, right: 8),
                                      child: Row(
                                        children: [
                                          RatingBarIndicator(
                                            rating: userRating,
                                            itemBuilder: (context, index) =>
                                                Icon(
                                              selectedIcon ?? Icons.star,
                                              color: Colors.cyan,
                                            ),
                                            itemCount: 5,
                                            itemSize: 25.0,
                                            unratedColor:
                                                Colors.cyan.withAlpha(50),
                                            direction: Axis.horizontal,
                                          ),
                                          const Spacer(),
                                          Text(rateddate)
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 55,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Text(review),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Row(
                                        children: [
                                          Text('review by $reviewer'),
                                          const Spacer(),
                                          CircleAvatar(
                                            radius: 20,
                                            backgroundImage:
                                                NetworkImage(photourl),
                                            backgroundColor: Colors.cyan,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    );
                    }
                  }
                }),
          ],
        ),
      ),
    );
  }
}
