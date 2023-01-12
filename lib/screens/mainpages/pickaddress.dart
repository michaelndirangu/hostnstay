// ignore: file_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';

class PickAddress extends StatefulWidget {
  const PickAddress({Key? key}) : super(key: key);

  @override
  State<PickAddress> createState() => _PickAddressState();
}

class _PickAddressState extends State<PickAddress> {
  User? user;
  late CollectionReference propertyDetail;

  late double lat;
  late double long;
  late String address;

  saveLocation() async {
    await propertyDetail.doc(user!.uid).update({
      'locationCoords': GeoPoint(lat, long),
    });
  }

  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser;
    propertyDetail = FirebaseFirestore.instance.collection('propertyDetails');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: const Text('Pick Location'),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: FlutterLocationPicker(
        initPosition: LatLong(-1.286389, 36.817223),
        initZoom: 11,
        minZoomLevel: 5,
        trackMyPosition: true,
        onPicked: (pickedData) {
          lat = pickedData.latLong.latitude;
          long = pickedData.latLong.longitude;
          address = pickedData.address;
          saveLocation();
        },
      ),
    );
  }
}
