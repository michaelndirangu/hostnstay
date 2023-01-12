import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hostnstay/screens/authentication/login.dart';
import 'package:hostnstay/screens/navpages/bottomnav.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  splashScreenTimer() {
    Timer(const Duration(seconds: 3), () async {
      //user is already logged in
      if (FirebaseAuth.instance.currentUser != null) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const BottomNav()));
      } else {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const LoginPage()));
      }
      // Navigator.push(context,
      //       MaterialPageRoute(builder: (context) => const LoginPage()));
    });
  }

  @override
  void initState() {
    super.initState();
    splashScreenTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.greenAccent,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 5, right: 5, top: 70, bottom: 6),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(style: BorderStyle.solid, color: Colors.black),
                        // borderRadius: BorderRadius.circular(22,),
                        shape: BoxShape.circle,
                      ),
                      child: Text('HnS',
                      style: GoogleFonts.amita(fontSize: 28),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5, right: 5, top: 70, bottom: 6),
                child: Image.asset(
                  'img/room.jpeg',
                  width: MediaQuery.of(context).size.width/1,
                  ),
              ),
              Padding(
                padding: const EdgeInsets.only(left:  20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Feel',
                    textAlign: TextAlign.start,
                    style: GoogleFonts.amita(
                      textStyle: const TextStyle(
                      letterSpacing: 1.0,
                      fontSize: 36,
                      fontWeight: FontWeight.bold
                    ),
                    )
                    ),
                ]
              ),
              ),
              const SizedBox(height: 5,),
            Padding(
              padding: const EdgeInsets.only(left:  20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'at',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.amiri(
                        textStyle:const TextStyle(
                        height: 1.5,
                        letterSpacing: 1.0,
                        fontSize: 36,
                        color: Color.fromARGB(255, 216, 17, 190),
                        fontWeight: FontWeight.bold,
                      ),
                      ),
                      ),
                  ]
                ),
                ),
                const SizedBox(height: 5,),
            Padding(
              padding: const EdgeInsets.only(left:  20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Home',
                      textAlign: TextAlign.end,
                      style: GoogleFonts.amita(
                        textStyle: const TextStyle(
                        letterSpacing: 1.0,
                        fontSize: 36,
                        fontWeight: FontWeight.bold
                      ),
                      )),
                  ]
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
