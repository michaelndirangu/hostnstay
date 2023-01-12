import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hostnstay/firebase_options.dart';
import 'package:hostnstay/keys.dart';
import 'package:hostnstay/screens/authentication/scan.dart';
import 'package:hostnstay/screens/navpages/splashscreen.dart';
import 'package:mpesa_flutter_plugin/initializer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  MpesaFlutterPlugin.setConsumerKey(kConsumerKey);
  MpesaFlutterPlugin.setConsumerSecret(kConsumerSecret);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      darkTheme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
