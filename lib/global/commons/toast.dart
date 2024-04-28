import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showToast({required String message}) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 15,
    backgroundColor: Colors.black,
    textColor: Colors.white,
    fontSize: 16.0,
    webShowClose: true, // Show close button on web
    webBgColor: "#e74c3c", // Background color on web
    webPosition: "center",
  ); // Position on web
}
