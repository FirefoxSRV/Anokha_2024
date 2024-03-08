//MyDelightToastBar

import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


class MyDelightToastBar {
  void success(BuildContext context, String? s) {
    DelightToastBar(
      autoDismiss: true,
      snackbarDuration: Duration(seconds: 2),
      builder: (context) => ToastCard(
        color: Colors.green,
        leading: Icon(
          Icons.check_circle,
          //add success color,
          color: Colors.white,
        ),
        title: Text(
          s ?? "Success",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 14,
            color: Colors.white,
          ),
        ),
      ),
    ).show(context);
  }

  void error(BuildContext context, [String? s]) {
    DelightToastBar(
      autoDismiss: true,
      builder: (context) => ToastCard(
        color: Colors.red,
        leading: Icon(
          Icons.error,
          //add success color,
          color: Colors.white,
        ),
        title: Text(
          s ?? "Error",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 14,
            color: Colors.white,
          ),
        ),
      ),
    ).show(context);
  }

  void warning(BuildContext context, String s) {
    DelightToastBar(
      autoDismiss: true,
      builder: (context) => ToastCard(
        color: Colors.yellow,
        leading: Icon(
          Icons.warning,
          //add success color,
          color: Colors.white,
        ),
        title: Text(
          "Warning",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 14,
            color: Colors.white,
          ),
        ),
      ),
    ).show(context);
  }
}



void showToast(String message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.SNACKBAR,
      timeInSecForIosWeb: 1,
      fontSize: 16.0);
}