
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hostnstay/utils/showsnackbar.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  late final TextEditingController emailController;
  FirebaseAuth auth = FirebaseAuth.instance;

  Future resetPass() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
      Fluttertoast.showToast(msg: 'reset link has been sent.');
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!.toString());
    }
  }

  @override
  void initState() {
    emailController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: Text(
          'Reset Password',
          style: GoogleFonts.courgette(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 5,
      ),
      body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(
                  left: 30,
                  right: 30,
                  bottom: 15,
                ),
                child: Text(
                  'Enter your email below to receive the password reset link.',
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 17),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 30,
                  right: 30,
                  bottom: 15,
                ),
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  obscureText: false,
                  controller: emailController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[330],
                    prefixIcon: const Icon(Icons.email),
                    labelText: 'Enter your email',
                    labelStyle: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)),
                  ),
                ),
              ),
              Container(
                height: 40,
                width: MediaQuery.of(context).size.width / 1.0,
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: ElevatedButton(
                  onPressed: resetPass,
                  child: const Text(
                    'Send Reset Email',
                  ),
                ),
              ),
            ],
          ),
        ),
    );
  }
}