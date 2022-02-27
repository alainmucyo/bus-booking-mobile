import 'package:flutter/material.dart';

class SecondaryButton extends StatelessWidget {
  // Our primary button widget [to be reused]
  final Function onPressed;
  final String text;
  final bool isLoading;
  final Color backgroundColor;

  SecondaryButton({
    @required this.text,
    @required this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : SizedBox(
            width: double.infinity,
            child: FlatButton(
              onPressed: onPressed,
              padding: EdgeInsets.all(8.2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3),
              ),
              child: Text(
                text.toUpperCase(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              color: backgroundColor ?? Theme.of(context).accentColor,
            ),
          );
  }
}
