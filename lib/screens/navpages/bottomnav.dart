import 'package:flutter/material.dart';
import 'package:hostnstay/screens/navpages/bookings.dart';
import 'package:hostnstay/screens/navpages/findplace.dart';
import 'package:hostnstay/screens/navpages/profile.dart';
import 'package:hostnstay/screens/mainpages/cattabs.dart';
import 'package:hostnstay/screens/navpages/recommended.dart';
import 'package:hostnstay/screens/navpages/search.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  List pages = const [Tabs(), SearchPage(), RecommendPage(), MyBookings(), ProfilePage()];

  int currentIndex = 0;

  void onTap(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          onTap: onTap,
          currentIndex: currentIndex,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          selectedItemColor: Colors.lightBlueAccent,
          unselectedItemColor: Colors.grey.withOpacity(0.8),
          showSelectedLabels: true,
          showUnselectedLabels: true,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(label: 'Home', icon: Icon(Icons.home)),
            BottomNavigationBarItem(label: 'Search', icon: Icon(Icons.search)),
            BottomNavigationBarItem(label: '4you', icon: Icon(Icons.recommend_outlined)),
            BottomNavigationBarItem(
                label: 'bookings', icon: Icon(Icons.list_alt)),
            BottomNavigationBarItem(label: 'Profile', icon: Icon(Icons.person)),
          ]),
    );
  }
}
