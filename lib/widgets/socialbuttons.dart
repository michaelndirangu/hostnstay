import 'package:flutter/cupertino.dart';
import 'package:sign_button/constants.dart';
import 'package:sign_button/create_button.dart';

Widget otherSignUp(ButtonType btn, Function()? onPressed) {
  return SignInButton.mini(
    buttonType: btn,
    onPressed: onPressed,
    elevation: 4.0,
  );
}
