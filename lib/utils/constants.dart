import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:intl/intl.dart';

class CustomColor {
  static const Color LIGHT_GREY = Color(0xfff7fafc);
  static const Color LIGHT_GREY_2 = Color(0xffe2e8f0);
  static const Color LIGHT_GREY_3 = Color(0xffcbd5e0);
  static const Color DARK_GREY = Color(0xff4a5568);
  static const Color SUPER_DARK_GREY = Colors.black;
  static const Color PRIMARY = Color(0xffeb7c0c);
  static const Color ACCENT_COLOR = Color(0xff0C8444);
}

class Constants {
  static const BASE_URL = "https://horizon-booking.herokuapp.com/api";
}
class Utils {
  static String numberFormat(int num) {
    var formatter = NumberFormat('##,000');
    return formatter.format(num);
  }

  static void showSnackBar({
    @required String title,
    @required BuildContext context,
    Color color = Colors.red,
  }) {
    final snackBar = SnackBar(
      content: Text(title),
      backgroundColor: color,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
