
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hostnstay/icons.dart';
import 'package:hostnstay/screens/categories/apartments.dart';
import 'package:hostnstay/screens/categories/explore.dart';
import 'package:hostnstay/screens/categories/rooms.dart';
import 'package:hostnstay/screens/categories/villas.dart';

class Tabs extends StatefulWidget {
  const Tabs({super.key});

  @override
  State<Tabs> createState() => _TabsState();
}

class _TabsState extends State<Tabs> with TickerProviderStateMixin {
  late final tabController = TabController(length: 4, vsync: this);
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Host and Stay',
          style: GoogleFonts.amita(fontSize: 28),
          ),
          titleTextStyle: const TextStyle(color: Colors.cyan, fontSize: 24),
          centerTitle: true,
          // systemOverlayStyle: const SystemUiOverlayStyle(statusBarColor: Colors.white),
          backgroundColor: Colors.white,
          bottom: TabBar(
                padding: const EdgeInsets.only(bottom: 0, top: 2),
                labelPadding: const EdgeInsets.only(left: 15, right: 20, bottom: 0.2),
                controller: tabController,
                labelColor: Colors.cyan,
                unselectedLabelColor: Colors.black.withOpacity(0.9),
                isScrollable: true,
                indicatorWeight: 5,
                indicatorSize: TabBarIndicatorSize.label,
                indicator: const UnderlineTabIndicator(borderSide: BorderSide(color: Colors.cyan, width: 3.0)),
                tabs: const <Widget>[
                  Tab(
                    text: 'Modern Homes',
                    icon: Icon(CustomIcons.modernhome_),
                  ),
                  Tab(
                    text: 'Apartments',
                    icon: Icon(CustomIcons.apartment_)
                  ),
                  Tab(
                    text: 'Villas',
                    icon: Icon(CustomIcons.villa)
                  ),
                  // Tab(
                  //   text: 'Homes',
                  //   icon: Icon(CustomIcons.home)
                  // ),
                  Tab(
                    text: 'Rooms',
                    icon: Icon(CustomIcons.room)
                  ),
                ],
              ),
          ),
          body: TabBarView(
            controller: tabController,
            children: const [
                HomePage(),
                Apartments(),
                Villas(),
                // Homes(),
                Rooms(),              
            ],
          ),
        ),
    );
  }
}
