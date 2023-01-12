import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hostnstay/screens/authentication/resetpassword.dart';
import 'package:hostnstay/screens/authentication/signup.dart';
import 'package:hostnstay/screens/navpages/bottomnav.dart';
import 'package:hostnstay/utils/errormsg.dart';
// import 'package:hostnstay/utils/successmsg.dart';
import 'package:hostnstay/utils/warningmsg.dart';
import 'package:hostnstay/widgets/divider.dart';
import 'package:hostnstay/widgets/loginnav.dart';
import 'package:hostnstay/widgets/showprogress.dart';
import 'package:hostnstay/widgets/socialbuttons.dart';
import 'package:sign_button/sign_button.dart';

import '../../widgets/inputfield.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isObscure = true;
  final _formKey = GlobalKey<FormState>();
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  late StreamSubscription sub;
  bool isConnected = false;
  bool isLoading = false;

  void pressed() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }

  String? validatepassword(value) {
    if (value.isEmpty) {
      return "Required *";
    } else if (value.length < 8) {
      return "Enter atleast 8 characters";
    } else if (value.length > 15) {
      return "Should not exceed 15 characters";
    } else {
      return null;
    }
  }

  late final TextEditingController emailController = TextEditingController();
  late final TextEditingController passwordController = TextEditingController();

  void loginUser() async {
    if (_formKey.currentState!.validate()) {
      // showLoaderDialog(context, 'Loading...');
      showLoaderDialog(context, 'Loading...');
      try {
        await _auth.signInWithEmailAndPassword(
            email: emailController.text, password: passwordController.text);
        if (!mounted) return;
        Navigator.pop(context);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const BottomNav()));
        // showSuccessMsg(context, 'Successful Login!');
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          Navigator.pop(context);
          showErrorMsg(context, 'No user exists for that email');
        } else if (e.code == 'wrong-password') {
          Navigator.pop(context);
          showWarningMsg(context, 'Wrong Password Entered. Try Again.');
        }
      } catch (e) {
        Fluttertoast.showToast(
          msg: 'Something went wrong',
        );
      }
    } else {
      return null;
    }
    _formKey.currentState!.reset();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    sub.cancel();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    sub = Connectivity().onConnectivityChanged.listen(((event) {
      isConnected = (event != ConnectivityResult.none);
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 30,
                      right: 30,
                    ),
                    child: Text(
                      'Login to Account',
                      style: GoogleFonts.courgette(
                        textStyle: const TextStyle(
                            fontSize: 30,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            letterSpacing: .5,
                            wordSpacing: 2),
                      ),
                    ),
                  ),
                ],
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 30, right: 30, bottom: 15, top: 20),
                      child: field(
                          false,
                          MultiValidator([
                            RequiredValidator(errorText: "Required *"),
                            EmailValidator(errorText: "Enter a valid email.")
                          ]),
                          emailController,
                          'Email',
                          Icons.email),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 30, right: 30, bottom: 10),
                      child: TextFormField(
                        obscureText: _isObscure,
                        validator: validatepassword,
                        controller: passwordController,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey[330],
                            labelText: 'Password',
                            labelStyle: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                            prefixIcon: const Icon(Icons.password),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                            suffixIcon: TextButton(
                                onPressed: pressed,
                                child: Text(
                                  _isObscure ? "view" : "hide",
                                  style: const TextStyle(
                                      color: Colors.blue, fontSize: 16),
                                ))),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              right: 23, left: 60, bottom: 10),
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ResetPassword()));
                            },
                            child: const Text(
                              'Forgot Password?',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width / 1.0,
                      padding: const EdgeInsets.only(
                          right: 30, left: 30, bottom: 15),
                      child: ElevatedButton(
                        onPressed: loginUser,
                        child: const Text(
                          "Login",
                          style: TextStyle(fontSize: 16, letterSpacing: 1),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              divider(),
              Container(
                width: MediaQuery.of(context).size.width / 1.0,
                padding: const EdgeInsets.only(left: 30, right: 30, bottom: 15),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      // otherSignUp(ButtonType.google, () {}),
                      // otherSignUp(ButtonType.apple, () {}),
                      // otherSignUp(ButtonType.facebook, () {})
                    ]),
              ),
              nextPage('Don\'t have an account?', () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SignupPage()));
              }, 'Sign Up Here'),
            ],
          ),
        ),
      ),
    );
  }
}
