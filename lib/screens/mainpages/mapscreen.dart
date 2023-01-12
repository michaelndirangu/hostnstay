import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class MapScreen extends StatefulWidget {
  final GeoPoint geoPoint;
  const MapScreen({Key? key, required this.geoPoint}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  User? user;
  late CollectionReference propertyDetail;
  late firebase_storage.Reference ref;
  late GeoPoint geopoint = widget.geoPoint;
  late CameraPosition kGoogle;
  late GoogleMapController mapController;
  late List<Marker> markers = [];

  double lat = -1.286389;
  double long = 36.817223;

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  final Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser;
    propertyDetail = FirebaseFirestore.instance.collection('propertyDetails');
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Listing Location'),
        backgroundColor: Colors.cyan,
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            // onTap: (LatLng latLng) {
            //   lat = latLng.latitude;
            //   long = latLng.longitude;
            // },
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            myLocationEnabled: true,
            initialCameraPosition: kGoogle,
            markers: Set<Marker>.of(markers),
          ),
          // Positioned(
          //     top: 50,
          //     left: 10,
          //     right: 20,
          //     child: GestureDetector(
          //       onTap: () => Get.dialog(SearchDialog(
          //         mapController: _mapController,
          //       )),
          //       child: Container(
          //         height: 50,
          //         padding: const EdgeInsets.symmetric(horizontal: 5),
          //         decoration: BoxDecoration(
          //             color: Colors.greenAccent,
          //             borderRadius: BorderRadius.circular(10)),
          //         child: Row(
          //           children: [
          //             const Icon(
          //               Icons.location_on_outlined,
          //               size: 25,
          //               color: Colors.blue,
          //             ),
          //             const SizedBox(
          //               height: 5,
          //             ),
          //             //show address on the top
          //             Expanded(
          //                 child: Text(
          //               '${locationController.pickPlaceMark.name ?? ''}'
          //               '${locationController.pickPlaceMark.locality ?? ''}'
          //               '${locationController.pickPlaceMark.postalCode ?? ''}'
          //               '${locationController.pickPlaceMark.country ?? ''}',
          //               style: const TextStyle(fontSize: 20),
          //               maxLines: 1,
          //               overflow: TextOverflow.ellipsis,
          //             )),
          //             Expanded(
          //                 child: ElevatedButton(
          //               onPressed: () async {
          //                 try {
          //                   await propertyDetail.doc(user!.uid).update({
          //                     'locationCoords': GeoPoint(lat, long),
          //                   });
          //                 } on Exception catch (e) {
          //                   showSnackBar(context, e.toString());
          //                 }
          //               },
          //               child: const Text('save location details'),
          //             )),
          //             const SizedBox(
          //               width: 10,
          //             ),
          //             const Icon(Icons.search, size: 25, color: Colors.blue),
          //           ],
          //         ),
          //       ),
          //     ))
        ],
      ),
    );
  }
}
