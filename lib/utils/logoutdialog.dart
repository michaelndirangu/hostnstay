import 'package:flutter/cupertino.dart';
import 'package:panara_dialogs/panara_dialogs.dart';

showLogoutDialog(BuildContext context, Function() onTapConfirm, Function() onTapCancel) {
  return PanaraConfirmDialog.showAnimatedGrow(
      context,
      title: 'Sign Out',
      message: 'You will be logged out.',
      confirmButtonText: 'logout',
      cancelButtonText: 'cancel',
      onTapConfirm: onTapConfirm,
      onTapCancel: onTapCancel,
      panaraDialogType: PanaraDialogType.normal);
}
