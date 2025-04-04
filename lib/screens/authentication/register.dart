import 'dart:async';

// import 'package:connectivity/connectivity.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hostnstay/screens/authentication/login.dart';
import 'package:hostnstay/screens/authentication/scan.dart';
import 'package:hostnstay/screens/navpages/bottomnav.dart';
import 'package:hostnstay/services/passwordauth.dart';
import 'package:hostnstay/utils/errormsg.dart';
import 'package:hostnstay/utils/showsnackbar.dart';
import 'package:hostnstay/utils/successmsg.dart';
import 'package:hostnstay/utils/warningmsg.dart';
import 'package:hostnstay/widgets/inputfield.dart';
import 'package:hostnstay/widgets/progress.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _key = GlobalKey<FormState>();
  final PasswordAuth pass = PasswordAuth();
  bool isObscure = true;
  bool isLoading = false;
  bool isConnected = false;
  late StreamSubscription sub;
  bool? agree = false;
  ConnectivityResult connectivityResult = ConnectivityResult.none;


  // FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  late final TextEditingController emailController;
  late final TextEditingController locationController;
  late final TextEditingController passwordController;
  late final TextEditingController firstnameController;
  late final TextEditingController lastnameController;
  late final TextEditingController phoneController;
  late final TextEditingController confirmCont;

  void pressed() {
    setState(() {
      isObscure = !isObscure;
    });
  }

  String? confirmPass(value) {
    if (value.isEmpty) {
      return 'Required *';
    } else if (value != passwordController.text) {
      return 'Passwords do not match';
    } else {
      return null;
    }
  }

  void setAgreedToTOS(bool? newValue) {
    setState(() {
      agree = newValue;
    });
  }

  @override
  void initState() {
    emailController = TextEditingController();
    locationController = TextEditingController();
    passwordController = TextEditingController();
    firstnameController = TextEditingController();
    lastnameController = TextEditingController();
    phoneController = TextEditingController();
    confirmCont = TextEditingController();
    sub = Connectivity().onConnectivityChanged.listen((event) {
      isConnected = (event != ConnectivityResult.none);
    });

    super.initState();
  }

  void signup() async {
    var firstName = firstnameController.text.trim();
    var lastName = lastnameController.text.trim();
    var email = emailController.text.trim();
    var tel = phoneController.text.trim();
    var password = passwordController.text.trim();
    if (_key.currentState!.validate()) {
      if (agree = true) {
        setState(() {
          isLoading = true;
        });

        if (isConnected = true) {
          try {
            FirebaseAuth auth = FirebaseAuth.instance;

            UserCredential userCredential =
                await auth.createUserWithEmailAndPassword(
                    email: email, password: password);
            if (userCredential.user != null) {
              //store user data
              DatabaseReference userRef =
                  FirebaseDatabase.instance.ref().child('users');

              String uid = userCredential.user!.uid;

              await userRef.child(uid).set({
                'firstName': firstName,
                'lastName': lastName,
                'uid': uid,
                'email': email,
                'tel': tel,
                'profileImage': ''
              });

              setState(() {
                isLoading = false;
              });
              if (!mounted) return;
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const BottomNav()));
              showSuccessMsg(context, 'Account registered succesfully.');
            } else {
              if (!mounted) return;
              showErrorMsg(context, 'An error occurred');
            }
          } on FirebaseAuthException catch (e) {
            setState(() {
              isLoading = false;
            });
            if (e.code == 'email-already-in-use') {
              showWarningMsg(context, 'That email is already in use.');
            } else if (e.code == 'weak-password') {
              Fluttertoast.showToast(msg: 'Password is too weak');
            }
          } catch (e) {
            setState(() {
              isLoading = false;
            });
            showSnackBar(context, 'Something went wrong');
          }
        } else {
          setState(() {
            isLoading = false;
            Fluttertoast.showToast(msg: 'No internet connection');
          });
        }
      } else {
        Fluttertoast.showToast(
            msg: 'Agree to terms and conditions', gravity: ToastGravity.CENTER);
      }
    } else {
      return null;
    }
    return null;
  }

  @override
  void dispose() {
    sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: isLoading
          ? const Center(
              child: SizedBox(
                child: Progress(),
              ),
            )
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              reverse: true,
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
                          bottom: 20,
                        ),
                        child: Text(
                          'Sign Up',
                          style: GoogleFonts.courgette(
                            textStyle: const TextStyle(
                                color: Colors.blue,
                                fontSize: 30,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SingleChildScrollView(
                    child: Form(
                      key: _key,
                      child: Column(
                        children: <Widget>[
                          // Padding(
                          //   padding: const EdgeInsets.only(
                          //       left: 30, right: 30, bottom: 15),
                          //   child: Row(
                          //     children: [
                          //       SizedBox(
                          //         width: 140,
                          //         child: field(
                          //           false,
                          //           RequiredValidator(errorText: 'Required*'),
                          //           firstnameController,
                          //           'First Name',
                          //           Icons.person,
                          //         ),
                          //       ),
                          //       const Spacer(),
                          //       SizedBox(
                          //         width: 140,
                          //         child: field(
                          //             false,
                          //             RequiredValidator(errorText: 'Required*'),
                          //             lastnameController,
                          //             'Last Name',
                          //             Icons.person),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          Padding(
                              padding: const EdgeInsets.only(
                                  left: 30, right: 30, bottom: 15),
                              child: field(
                                  false,
                                  RequiredValidator(errorText: 'Required*'),
                                  firstnameController,
                                  'First Name',
                                  Icons.person)),
                          Padding(
                              padding: const EdgeInsets.only(
                                  left: 30, right: 30, bottom: 15),
                              child: field(
                                  false,
                                  RequiredValidator(errorText: 'Required*'),
                                  lastnameController,
                                  'Last Name',
                                  Icons.person)),
                          Padding(
                              padding: const EdgeInsets.only(
                                  left: 30, right: 30, bottom: 15),
                              child: field(
                                  false,
                                  RequiredValidator(errorText: "Required*"),
                                  phoneController,
                                  'Phone',
                                  Icons.phone)),
                          Padding(
                              padding: const EdgeInsets.only(
                                left: 30,
                                right: 30,
                                bottom: 15,
                              ),
                              child: field(
                                  false,
                                  MultiValidator([
                                    RequiredValidator(errorText: "Required *"),
                                    EmailValidator(
                                        errorText: "Enter a valid email")
                                  ]),
                                  emailController,
                                  'Email',
                                  Icons.email)),
                          Padding(
                              padding: const EdgeInsets.only(
                                left: 30,
                                right: 30,
                                bottom: 15,
                              ),
                              child: field(
                                  false,
                                  MultiValidator([
                                    RequiredValidator(errorText: "Required *"),
                                    EmailValidator(
                                        errorText: "Enter your location")
                                  ]),
                                  locationController,
                                  'town/county',
                                  Icons.location_city)),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 30, right: 30, bottom: 15),
                            child: TextFormField(
                              obscureText: isObscure,
                              validator: pass.validatePass,
                              controller: passwordController,
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey[330],
                                  labelText: 'Password',
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.cyan),
                                  ),
                                  labelStyle: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                  prefixIcon: const Icon(Icons.password),
                                  suffixIcon: TextButton(
                                      onPressed: pressed,
                                      child: Text(
                                        isObscure ? "view" : "hide",
                                        style: const TextStyle(
                                            color: Colors.blue, fontSize: 16),
                                      ))),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 30, right: 30, bottom: 15),
                            child: TextFormField(
                              obscureText: isObscure,
                              validator: confirmPass,
                              controller: confirmCont,
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey[330],
                                  labelText: 'Confirm Password',
                                  labelStyle: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue),
                                  ),
                                  prefixIcon: const Icon(Icons.password),
                                  suffixIcon: TextButton(
                                      onPressed: pressed,
                                      child: Text(
                                        isObscure ? "view" : "hide",
                                        style: const TextStyle(
                                            color: Colors.blue, fontSize: 16),
                                      ))),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: Row(
                              children: [
                                const Icon(Icons.image_outlined),
                                ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const MyWidget()));
                                    },
                                    child: const Text("upload id images"))
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, bottom: 15),
                            child: Row(
                                // crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Checkbox(
                                    value: agree,
                                    // onChanged: (value) {
                                    //   setState(() {
                                    //     agree = value ?? false;
                                    //   });
                                    // },
                                    onChanged: setAgreedToTOS,
                                  ),
                                  GestureDetector(
                                    onTap: () => setAgreedToTOS(agree),
                                    child: const Text(
                                        'I agree to terms of service.'),
                                  ),
                                ]),
                          ),
                          Container(
                            padding: const EdgeInsets.only(
                                left: 30, right: 30, bottom: 15),
                            height: 50,
                            width: MediaQuery.of(context).size.width / 1.0,
                            child: ElevatedButton(
                              onPressed: signup,
                              child: const Text(
                                'Sign Up',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          'Already have an account?',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                              letterSpacing: .5),
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginPage()),
                              );
                            },
                            child: const Text(
                              'Sign In Here.',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ))
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
