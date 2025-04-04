import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hostnstay/keys.dart';
import 'package:hostnstay/screens/navpages/bottomnav.dart';
import 'package:hostnstay/utils/alert.dart';
import 'package:hostnstay/utils/awesomebar.dart';
import 'package:hostnstay/widgets/showprogress.dart';
import 'package:mpesa_flutter_plugin/mpesa_flutter_plugin.dart';

import '../../data/userdata/usermodel.dart';

class Payment extends StatefulWidget {
  final String price;
  final String title;
  final String location;
  final String rating;
  final String owneruid;
  final List imageUrls;
  const Payment(
      {Key? key,
      required this.price,
      required this.title,
      required this.location,
      required this.rating,
      required this.imageUrls,
      required this.owneruid})
      : super(key: key);

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  User? user;
  late DocumentReference paymentsRef;
  late DocumentReference paymentStatus =
      FirebaseFirestore.instance.collection('paymentStatus').doc(userEmail);
  late String? userEmail;
  late String amount = widget.price;
  late String title = widget.title;
  String transactionResult = "waiting";
  // SendSMS? send;
  UserModel? userModel;
  late DatabaseReference userRef =
      FirebaseDatabase.instance.ref().child('users');
  bool initialized = false;
  bool error = false;
  late int number;
  late String body;

  successTimer() {
    Timer(const Duration(seconds: 15), () async {
            FirebaseFirestore.instance
          .collection("Bookings")
          .doc(widget.owneruid)
          .set({
        'title': title,
        'location': widget.location,
        'price': widget.price,
        'rating': widget.rating,
        'email': userEmail,
        'locationCoords': '',
        'imageUrls': widget.imageUrls,
        'uid': widget.owneruid
      });
      if (!mounted) return;
      showBookingSuccess(
          context, "Your booking has been successfuly received.");
    });
  }

  paymentResult() {
    if (transactionResult == "waiting") {
      showLoaderDialog(context, "please wait...");
    } else if (transactionResult == "0") {
      Navigator.pop(context);
      showBookingSuccess(context, "Your payment is succesful!");
    } else {
      showAlertDialog(context, "Payment was unsuccessful. please try again");
    }
  }

  Future<void> getResult() async {
    DocumentSnapshot ds = await FirebaseFirestore.instance
        .collection('paymentStatus')
        .doc(userEmail)
        .get();
    setState(() {
      transactionResult = ds.get('resultcode');
    });
  }

  initialize() async {
    FirebaseFirestore.instance
        .collection('paymentStatus')
        .doc(userEmail)
        .set({'resultcode': transactionResult});
  }

  Future<void> lipaNaMpesa(
      {required String userPhone, required double amount}) async {
    dynamic transactionInitialisation;
    try {
      transactionInitialisation =
          await MpesaFlutterPlugin.initializeMpesaSTKPush(
              businessShortCode: "174379",
              transactionType: TransactionType.CustomerPayBillOnline,
              amount: double.parse(widget.price),
              partyA: "254$userPhone",
              partyB: "174379",
              //Lipa na Mpesa Online ShortCode
              callBackURL: Uri(
                  scheme: "https",
                  host: "us-central1-host-and-stay-2070c.cloudfunctions.net",
                  path: "/receiveCallback"),
              accountReference: "host and stay",
              phoneNumber: "254$userPhone",
              baseUri: Uri(scheme: "https", host: "sandbox.safaricom.co.ke"),
              transactionDesc: "purchase",
              passKey:
                  "bfb279f9aa9bdbcf158e97dd71a467cd2e0c893059b10f78e6b72ada1ed2c919");
      // return transactionInitialisation;
      var result = transactionInitialisation as Map<String, dynamic>;
      if (!mounted) return;
      showLoaderDialog(context, "please wait...");
      if (result.keys.contains("ResponseCode")) {
        String mResponseCode = result["ResponseCode"];
        // ignore: avoid_print
        print("Resulting Code: $mResponseCode");
        if (mResponseCode == '0') {
          Navigator.pop(context);
          // showBookingSuccess(context, "Your payment is succesful!");
          updateAccount(result["CheckoutRequestID"]);
                FirebaseFirestore.instance
          .collection("Bookings")
          .doc(widget.owneruid)
          .set({
        'title': title,
        'location': widget.location,
        'price': widget.price,
        'rating': widget.rating,
        'email': userEmail,
        'locationCoords': '',
        'imageUrls': widget.imageUrls,
        'uid': widget.owneruid
      });
          successTimer();
          // getResult();
          // paymentResult();
        } else {
          showAlertDialog(context, "payment was unsuccesful");
        }
      }
      //ignore: avoid_print
      print("RESULT: $transactionInitialisation");
    } catch (e) {
      //you can implement your exception handling here.
      //Network unreachability is a sure exception.
      // ignore: avoid_print
      print("Exception Caught: $e");
    }
  }

  void clearText() {
    _textFieldController.clear();
  }

  @override
  void initState() {
    super.initState();
    MpesaFlutterPlugin.setConsumerKey(kConsumerKey);
    MpesaFlutterPlugin.setConsumerSecret(kConsumerSecret);
    user = FirebaseAuth.instance.currentUser;
    userEmail = user!.email;
    body = "";
    initialize();
    paymentsRef =
        FirebaseFirestore.instance.collection('payments').doc(userEmail);
    if (user != null) {
      userRef = FirebaseDatabase.instance.ref().child('users').child(user!.uid);
    }

    getUserDetails();
    // number = int.parse(userModel?.tel ?? '');
  }

  @override
  Widget build(BuildContext context) {
    final String price = widget.price;
    var myprice = double.parse(price);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Payment'),
        centerTitle: true,
        automaticallyImplyLeading: true,
        backgroundColor: Colors.cyan,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              height: 50,
              decoration: BoxDecoration(color: Colors.cyan[230]),
              child: const Text(
                'Select a payment method below',
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            const SizedBox(
              height: 5,
            ),
            GestureDetector(
              onTap: () async {
                var providedContact = await _showTextInputDialog(context);
                if (providedContact != null) {
                  if (providedContact.isNotEmpty) {
                    lipaNaMpesa(userPhone: providedContact, amount: myprice);
                  } else {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Empty Number!'),
                            content: const Text("No number to be charged."),
                            actions: <Widget>[
                              ElevatedButton(
                                child: const Text("Cancel"),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ],
                          );
                        });
                  }
                }
              },
              child: Container(
                height: 100,
                width: MediaQuery.of(context).size.width / 1.1,
                padding: const EdgeInsets.only(left: 20, right: 20),
                decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(8)),
                child: Row(
                  children: [
                    Image.asset(
                      'img/mpesa.png',
                      height: 60,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    const Text(
                      'M-pesa',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            const SizedBox(
              height: 5,
            ),
          ],
        ),
      ),
    );
  }

  final _textFieldController = TextEditingController();

  Future<String?> _showTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('M-Pesa Number'),
            content: TextField(
              keyboardType: TextInputType.phone,
              controller: _textFieldController,
              decoration: const InputDecoration(hintText: "7...or 1...."),
            ),
            actions: <Widget>[
              ElevatedButton(
                child: const Text("Cancel"),
                onPressed: () => Navigator.pop(context),
              ),
              ElevatedButton(
                  child: const Text('Proceed'),
                  onPressed: () {
                    Navigator.pop(context, _textFieldController.text);
                    clearText();
                  }),
            ],
          );
        });
  }

  getUserDetails() async {
    DataSnapshot snapshot = await userRef.get();

    userModel =
        UserModel.fromMap(Map<String, dynamic>.from(snapshot.value as Map));
    setState(() {});
  }

  Future<void> sendEmail() async {
    final Email email = Email(
      body: body,
      subject: "HnS Reservation Confirmation",
      recipients: ['$userEmail'],
      cc: ['ndirangumichael33@gmail.com'],
      attachmentPaths: [],
      isHTML: false,
    );
    String platformResponse = "Your booking has been successfuly received.";
    try {
      await FlutterEmailSender.send(email);
      platformResponse = "Booking Successful";
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
    if (!mounted) return;
    showBookingSuccess(context, platformResponse);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const BottomNav()));
  }

  Future<void> updateAccount(String mCheckoutRequestID) {
    Map<String, String> initData = {
      'CheckoutRequestID': mCheckoutRequestID,
    };

    paymentsRef.set({
      "info": "$userEmail receipts",
    });

    return paymentsRef
        .collection("deposit")
        .doc(mCheckoutRequestID)
        .set(initData)
        // ignore: avoid_print
        .then((value) => print("Transaction Initialized."))
        // ignore: avoid_print
        .catchError((error) => print("Failed to init transaction: $error"));
  }

  Stream<DocumentSnapshot>? getAccountBalance() {
    if (initialized) {
      return paymentsRef.collection("balance").doc("account").snapshots();
    } else {
      return null;
    }
  }

  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      setState(() {
        initialized = true;
      });

      paymentsRef =
          FirebaseFirestore.instance.collection('payments').doc(userEmail);
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        error = true;
      });
    }
  }
}
