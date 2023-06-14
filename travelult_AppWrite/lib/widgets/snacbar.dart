import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void customSnacBar(
    BuildContext context, String message, SnackBarAction snackBarAction) {
  ScaffoldMessenger.of(context)
    ..removeCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(
          message,
        ),
        action: snackBarAction,
      ),
    );
}

void flutterToast(String message) {
  Fluttertoast.showToast(
    msg: message,
    webBgColor: "linear-gradient(90deg, rgba(0,0,0,1) 0%, rgba(0,0,0,1) 0%)",
    webShowClose: true,
    webPosition: "center",
  );
}
