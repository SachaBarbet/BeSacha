import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../assets/app_colors.dart';


void showErrorToast(BuildContext context, String errorMessage) {
  Fluttertoast.showToast(
    msg: errorMessage,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    webShowClose: true,
    timeInSecForIosWeb: 3,
    backgroundColor: kRedColor,
    textColor: kWhiteColor,
    fontSize: 18,
  );
}

void showShortErrorToast(BuildContext context, String errorMessage) {
  Fluttertoast.showToast(
    msg: errorMessage,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    webShowClose: true,
    timeInSecForIosWeb: 3,
    backgroundColor: kRedColor,
    textColor: kWhiteColor,
    fontSize: 18,
  );
}

void showSuccessToast(BuildContext context, String successMessage) {
  Fluttertoast.showToast(
    msg: successMessage,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    webShowClose: true,
    timeInSecForIosWeb: 3,
    backgroundColor: kGreenColor,
    textColor: kWhiteColor,
    fontSize: 18,
  );
}

void showInfoToast(BuildContext context, String infoMessage) {
  Fluttertoast.showToast(
    msg: infoMessage,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    webShowClose: true,
    timeInSecForIosWeb: 3,
    backgroundColor: const Color(0xFF2787D6),
    textColor: kWhiteColor,
    fontSize: 18,
  );
}

void showShortInfoToast(BuildContext context, String infoMessage) {
  Fluttertoast.showToast(
    msg: infoMessage,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    webShowClose: true,
    timeInSecForIosWeb: 3,
    backgroundColor: const Color(0xFF2787D6),
    textColor: kWhiteColor,
    fontSize: 18,
  );
}
