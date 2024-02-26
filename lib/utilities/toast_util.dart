import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../assets/app_colors.dart';

class ToastUtil {

  static void showErrorToast(BuildContext context, String errorMessage) {
    Fluttertoast.showToast(
      msg: errorMessage,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      webShowClose: true,
      timeInSecForIosWeb: 3,
      backgroundColor:  AppColors.red,
      textColor: AppColors.white,
      fontSize: 18,
    );
  }

  static void showShortErrorToast(BuildContext context, String errorMessage) {
    Fluttertoast.showToast(
      msg: errorMessage,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      webShowClose: true,
      timeInSecForIosWeb: 3,
      backgroundColor: AppColors.red,
      textColor: AppColors.white,
      fontSize: 18,
    );
  }

  static void showSuccessToast(BuildContext context, String successMessage) {
    Fluttertoast.showToast(
      msg: successMessage,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      webShowClose: true,
      timeInSecForIosWeb: 3,
      backgroundColor: AppColors.green,
      textColor: AppColors.white,
      fontSize: 18,
    );
  }

  static void showInfoToast(BuildContext context, String infoMessage) {
    Fluttertoast.showToast(
      msg: infoMessage,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      webShowClose: true,
      timeInSecForIosWeb: 3,
      backgroundColor: const Color(0xFF2787D6),
      textColor: AppColors.white,
      fontSize: 18,
    );
  }

  static void showShortInfoToast(BuildContext context, String infoMessage) {
    Fluttertoast.showToast(
      msg: infoMessage,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      webShowClose: true,
      timeInSecForIosWeb: 3,
      backgroundColor: const Color(0xFF2787D6),
      textColor: AppColors.white,
      fontSize: 18,
    );
  }
}
