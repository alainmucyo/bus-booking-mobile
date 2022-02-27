import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ErrorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Center(
        child: Text(
          "Something went wrong!",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
