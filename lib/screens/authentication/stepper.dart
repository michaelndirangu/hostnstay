import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StepperPage extends StatefulWidget {
  const StepperPage({super.key});

  @override
  State<StepperPage> createState() => _StepperPageState();
}

class _StepperPageState extends State<StepperPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                const Icon(Icons.account_circle),
                Text('Personal Details',
                style: GoogleFonts.allura(
                  fontSize: 28,
                  fontWeight: FontWeight.bold
                ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
