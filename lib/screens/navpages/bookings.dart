import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hostnstay/data/userdata/hostmodel.dart';
import 'package:hostnstay/data/userdata/usermodel.dart';
import 'package:hostnstay/widgets/hmepageshimmer.dart';
import 'package:hostnstay/widgets/largetext.dart';
import 'package:hostnstay/widgets/smalltext.dart';
import 'package:rating_dialog/rating_dialog.dart';

class MyBookings extends StatefulWidget {
  const MyBookings({super.key});

  @override
  State<MyBookings> createState() => _MyBookingsState();
}

class _MyBookingsState extends State<MyBookings> {
  late String? userEmail;
  User? user;
  bool isVisible = false;
  late String title;
  late final reviewController = TextEditingController();
  late CollectionReference reviews;
  // TextEditingController ratingController = TextEditingController();
  double userRatings = 1.0;
  double userRating = 3.0;
  IconData? selectedIcon;
  // late final ratingController;
  late TextEditingController ratingController;
  bool isVertical = false;
  late double rating;
  double initialRating = 2.0;
  HostModel? hostModel;
  late String reviewer;
  String? photourl;
  late DatabaseReference userRef =
      FirebaseDatabase.instance.ref().child('users');
  late CollectionReference bookings;
  late String userID;

  getHostDetails() async {
    DataSnapshot snapshot = await userRef.get();

    hostModel =
        HostModel.fromMap(Map<String, dynamic>.from(snapshot.value as Map));
    setState(() {});
  }

  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser;
    userEmail = user!.email;
    ratingController = TextEditingController(text: '3.0');
    rating = initialRating;
    reviews = FirebaseFirestore.instance.collection("reviews");
    bookings = FirebaseFirestore.instance.collection("Bookings");

    if (user != null) {
      userRef = FirebaseDatabase.instance.ref().child('users').child(user!.uid);
    }
    getHostDetails();
    reviewer = hostModel?.firstName ?? "";
    photourl = hostModel?.profileImage ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('My Booking History'),
          centerTitle: true,
          automaticallyImplyLeading: true,
          backgroundColor: Colors.cyan,
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Bookings')
              .where('email', isEqualTo: userEmail)
              .snapshots(),
          builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const ShimmerLoading();
            } else {
              return ListView(
                children: snapshot.data!.docs.map((document) {
                  String price = document.get('price');
                  String location = document.get('location');
                  title = document.get('title');
                  Timestamp date = document.get('bookingdate');
                  DateTime bookingdate = date.toDate();
                  userID = document.get('uid');
                  // setState(() {
                  //   userID = useriD;
                  // });
                  return Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: Card(
                      elevation: 1.5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: LargeText(size: 22, text: title),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SmallText(text: "$price KSH"),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SmallText(text: location),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SmallText(text: "booked on $bookingdate"),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                  onPressed: () {
                                    showModalBottomSheet(
                                        context: context,
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(12.0)),
                                        ),
                                        builder: ((builder) => bottomSheet()));
                                  },
                                  child: const Text("rate now"))
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
            }
          },
        ));
  }

  void showRatingDialog() {
    final dialog = RatingDialog(
        initialRating: 1,
        title: const Text(
          "Rate and Review",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        message:
            const Text("Select stars to rate and also add your remarks here"),
        image: Image.asset("img/launcher1.jpg"),
        submitButtonText: "Submit",
        onSubmitted: (response) {
          // ignore: avoid_print
          print('rating: ${response.rating}, comment: ${response.comment} ');
        });
    showDialog(context: context, builder: (context) => dialog);
  }

  // Widget makeDismissable({required Widget child}) => GestureDetector(
  //       behavior: HitTestBehavior.opaque,
  //       onTap: () => Navigator.of(context).pop(),
  //       child: GestureDetector(onTap: () {}, child: child),
  //     );
  // Widget buildSheet() => makeDismissable(
  //       child: DraggableScrollableSheet(
  //         initialChildSize: 0.7,
  //         builder: (_, controller) => Container(
  //           decoration: const BoxDecoration(
  //             color: kBackgroundColor,
  //             borderRadius: BorderRadius.vertical(
  //               top: Radius.circular(20),
  //             ),
  //           ),
  //           padding: const EdgeInsets.all(16),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: <Widget>[
  //               Text(
  //                 "Rate & Review Your Stay at $title",
  //                 style: Theme.of(context).textTheme.headline6,
  //                 textAlign: TextAlign.center,
  //               ),
  //               const Divider(),
  //               Padding(
  //                 padding: const EdgeInsets.all(20.0),
  //                 child: Column(
  //                   children: [
  //                     Text(
  //                       "Star Rating",
  //                       style: Theme.of(context)
  //                           .textTheme
  //                           .button!
  //                           .copyWith(fontWeight: FontWeight.bold),
  //                       textAlign: TextAlign.start,
  //                     ),
  //                     const SizedBox(height: 12),
  //                     Column(
  //                       children: <Widget>[
  //                         RatingBar.builder(
  //                             initialRating: 1,
  //                             minRating: 1,
  //                             direction: Axis.horizontal,
  //                             allowHalfRating: true,
  //                             itemCount: 5,
  //                             itemPadding: const EdgeInsets.all(4.0),
  //                             itemBuilder: (context, _) => Icon(
  //                                   Icons.star,
  //                                   color: Colors.amber[800],
  //                                 ),
  //                             onRatingUpdate: (rating) {
  //                               // userRatings = rating;
  //                               setState(() {});
  //                               // print(rating);
  //                             })
  //                       ],
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //               const Divider(),
  //               Padding(
  //                 padding: const EdgeInsets.all(20.0),
  //                 child: Column(
  //                   children: <Widget>[
  //                     Text(
  //                       "Review",
  //                       style: Theme.of(context)
  //                           .textTheme
  //                           .button!
  //                           .copyWith(fontWeight: FontWeight.bold),
  //                     ),
  //                     Column(
  //                       children: <Widget>[
  //                         Container(
  //                           margin: const EdgeInsets.symmetric(vertical: 10),
  //                           padding: const EdgeInsets.symmetric(
  //                             horizontal: 22,
  //                             vertical: 0.9,
  //                           ),
  //                           decoration: BoxDecoration(
  //                             color: kPrimaryColor.withOpacity(0.05),
  //                             borderRadius: BorderRadius.circular(29),
  //                           ),
  //                           child: TextField(
  //                             controller: reviewController,
  //                             maxLines: null,
  //                             keyboardType: TextInputType.multiline,
  //                             decoration: InputDecoration(
  //                               border: InputBorder.none,
  //                               hintText: "Type in a review...",
  //                               hintStyle:
  //                                   TextStyle(color: Colors.grey.shade500),
  //                             ),
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                     const SizedBox(height: 12),
  //                     SizedBox(
  //                       child: ElevatedButton(
  //                         onPressed: addReview,
  //                         child: const Text('submit'),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     );

  // addReview() {
  //   // reviews.doc(widget.user['serviceProviderEmail']).collection('reviews').add(
  //   //   {
  //   //     "reviewedByName": loggedInUser?.name,
  //   //     "reviewedByImageUrl": loggedInUser?.imageUrl,
  //   //     "reviewedDate": DateTime.now(),
  //   //     "review": reviewController.text,
  //   //     "rating": userRatings,
  //   //   },
  //   // );
  //   final firestore = FirebaseFirestore.instance.collection('users');
  //   // CollectionReference ref = FirebaseFirestore.instance.collection('users');
  //   // ref.doc(widget.user['uid']).update({
  //   //   'ratings': userRatings,
  //   // }).then((value) {
  //   //   print("successfully updated");
  //   // }).onError((error, stackTrace) {
  //   //   print("error occured!!!");
  //   // });
  //   reviewController.clear();
  //   Fluttertoast.showToast(msg: 'review added succesfully');
  //   Navigator.pop(context);
  // }
  Widget bottomSheet() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: LargeText(size: 22, text: 'Rate and Review'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          height: double.maxFinite,
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),
          child: Column(
            children: <Widget>[
              const Divider(
                color: Colors.black,
                thickness: 2.0,
              ),
              const SizedBox(
                height: 2,
              ),
              RatingBarIndicator(
                rating: userRating,
                itemBuilder: (context, index) => Icon(
                  selectedIcon ?? Icons.star,
                  color: Colors.cyan,
                ),
                itemCount: 5,
                itemSize: 50.0,
                unratedColor: Colors.cyan.withAlpha(50),
                direction: isVertical ? Axis.vertical : Axis.horizontal,
              ),
              const SizedBox(height: 10.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextFormField(
                  controller: ratingController,
                  keyboardType: TextInputType.number,
                  onChanged: ((value) {
                    userRating = double.parse(value);
                    setState(() {
                      bottomSheet();
                    });
                  }),
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'Enter rating',
                    labelText: 'Enter rating',
                    suffixIcon: MaterialButton(
                      onPressed: () {
                        userRating = double.parse(ratingController.text);
                        setState(() {
                          bottomSheet();
                        });
                      },
                      child: const Text('Rate'),
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 0.9,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(29),
                ),
                child: TextFormField(
                  controller: reviewController,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)),
                    hintText: "Type in a review...",
                    hintStyle: TextStyle(color: Colors.grey.shade500),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                child: ElevatedButton(
                  onPressed: addReview,
                  child: const Text('submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  addReview() {
    reviews.doc(userEmail).set({
      'rating': userRating.toString(),
      'review': reviewController.text,
      'photo': hostModel?.profileImage?? "",
      'ratedby': hostModel?.firstName ?? "",
      'ratedon': DateTime.now(),
      'uid': userID
    });
    final firestore = FirebaseFirestore.instance.collection('propertyDetails');
    firestore.doc(userID).update({"rating": userRating.toString()}).then((value) {
      print("successfully updated");
    }).onError((error, stackTrace) {
      print("error occured!!!");
    });
    reviewController.clear();
    Fluttertoast.showToast(msg: "Review submmitted succesfully");
  }
}
