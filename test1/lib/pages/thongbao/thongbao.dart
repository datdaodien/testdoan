import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ThongBao {
  void toastMessage(String message) {
    Future.delayed(Duration(seconds: 1));
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
