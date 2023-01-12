import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

class Progress extends StatelessWidget {
  const Progress({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 30, right: 30, bottom: 4),
                        child: Text('creating account',
                        style: GoogleFonts.euphoriaScript(
                          textStyle: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        ),
                        ),
                    ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const [
                    Padding(
                      padding: EdgeInsets.only(left: 30, right: 30),
                      child: SpinKitThreeBounce(
                        color: Colors.blue,
                        size: 40.0,
                        duration: Duration(milliseconds: 1200),
                        ),
                      ),
                  ],
                ),
          ],
        )
      ),
    );
  }
}
