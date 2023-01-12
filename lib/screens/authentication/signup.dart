
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hostnstay/screens/authentication/login.dart';
import 'package:hostnstay/screens/authentication/register.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 30, right: 30, bottom: 15),
                      child: Text(
                        'Sign Up',
                        style: GoogleFonts.courgette(
                          textStyle: const TextStyle(
                            color: Colors.blue,
                            fontSize: 30,
                            fontWeight: FontWeight.bold
                          )
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.only(
                    left: 30,
                    right: 30,
                    bottom: 15,
                  ),
                  height: 50,
                  width: MediaQuery.of(context).size.width / 1.0,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterPage(),
                          ));
                    },
                    child: const Text(
                      'Email/Password',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 30, right: 30, bottom: 15),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                            margin: const EdgeInsets.only(left: 5, right: 10),
                            child: const Divider(
                              color: Colors.cyan,
                              height: 36,
                              thickness: 2,
                            )),
                      ),
                      const Text('Or'),
                      Expanded(
                        child: Container(
                            margin: const EdgeInsets.only(left: 10, right: 5),
                            child: const Divider(
                              color: Colors.cyan,
                              height: 36,
                              thickness: 2,
                            )),
                      ),
                    ],
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.only(left: 30, right: 30, bottom: 20),
                //   child: SizedBox(
                //     width: MediaQuery.of(context).size.width / 1.0,
                //     child: SignInButton(
                //       Buttons.Google,
                //       onPressed: () {},
                //     ),
                //   ),
                // ),
                // Padding(
                //   padding: const EdgeInsets.only(left: 30, right: 30, bottom: 15),
                //   child: SizedBox(
                //     width: MediaQuery.of(context).size.width / 1.0,
                //     child: SignInButton(
                //       Buttons.Apple,
                //       onPressed: () {},
                //     ),
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        'Already have an account?',
                        style: TextStyle(
                            color: Colors.black,
                            letterSpacing: .5,
                            fontSize: 16,
                            fontStyle: FontStyle.italic
                        ),
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
                          ))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }
}