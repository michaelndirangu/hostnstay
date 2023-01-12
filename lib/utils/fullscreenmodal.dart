// ignore: import_of_legacy_library_into_null_safe
import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hostnstay/screens/propertyDetails/details.dart';
import 'package:hostnstay/widgets/largetext.dart';
import 'package:hostnstay/widgets/skeleton.dart';

class SearchModal extends ModalRoute {
  TextEditingController searchCont = TextEditingController();
  String title = "";
  CollectionReference firecollection =
      FirebaseFirestore.instance.collection("propertyDetails");
  late BuildContext context;

  List imageURLs = [];
  late String price;
  late String location;
  List<NetworkImage> images = <NetworkImage>[];
  late String text;
  late String rating;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 500);
  @override
  bool get opaque => false;
  bool get barrierDismissable => false;
  @override
  Color get barrierColor => Colors.black.withOpacity(0.6);
  @override
  String? get barrierLabel => null;
  @override
  bool get maintainState => true;

  navigateToDetails(DocumentSnapshot properyDetails) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                DetailsPage(propertyDetails: properyDetails, imageList: images,)));
  }

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        child: Container(
          // width: MediaQuery.of(context).size.width / 1.0,
          padding:
              const EdgeInsets.only(top: 8, bottom: 8, left: 15, right: 15),
          child: ElevatedButton(
            onPressed: () => Navigator.of(context).pop(context),
            child: const Text('close'),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // implement the search field
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          title = "value";
                        });
                      },
                      controller: searchCont,
                      autofocus: true,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 20),
                        filled: true,
                        fillColor: Colors.grey.shade300,
                        suffixIcon: IconButton(
                            onPressed: () {
                              searchCont.clear();
                            },
                            icon: const Icon(Icons.clear)),
                        hintText: 'Search for spaces, romms...',
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(30)),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  // This button is used to close the search modal
                  TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'))
                ],
              ),

              // display other things like search history, suggestions, search results, etc.
              const SizedBox(
                height: 20,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 5),
                child: Text('Recently Searched',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              StreamBuilder(
                  stream: firecollection.snapshots().asBroadcastStream(),
                  builder: (BuildContext context, snapshot) {
                    if (!snapshot.hasData) {
                      // return showLoaderDialog(context, "searching...");
                      return const Text('hello');
                    } else {
                      if (snapshot.data!.docs
                          .where((QueryDocumentSnapshot<Object?> element) =>
                              element["title"]
                                  .toString()
                                  .toLowerCase()
                                  .contains(title.toLowerCase()))
                          .isEmpty) {
                        return Center(
                          child: Row(
                            children: [
                              LargeText(size: 22, text: "No Results Found."),
                            ],
                          ),
                        );
                      } else {
                        //get data from db
                        return ListView(
                          children: [
                            ...snapshot.data!.docs
                                .where(
                                    (QueryDocumentSnapshot<Object?> element) =>
                                        element["title"]
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
                                images.add(NetworkImage(imageURLs[i]));
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
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 220,
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
                                            images: images,
                                            dotSpacing: 15,
                                            boxFit: BoxFit.cover,
                                            dotSize: 4,
                                            autoplay: false,
                                            dotBgColor: Colors.transparent,
                                            dotColor: Colors.blue,
                                            dotVerticalPadding: 5,
                                            indicatorBgPadding: 5,
                                            defaultImage: const AssetImage(
                                                "img/thumbnail.png"),
                                            borderRadius: true,
                                            radius: const Radius.circular(12),
                                          ),
                                        ),
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
                  }
                  )
            ],
          ),
        ),
      ),
    );
  }

  // animations for the search modal
  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // add fade animation
    return FadeTransition(
      opacity: animation,
      // add slide animation
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, -1),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      ),
    );
  }

  @override
  bool get barrierDismissible => throw UnimplementedError();
}
