import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  // Our primary button widget [to be reused]
  final Function onPressed;
  final String text;
  final bool isLoading;
  final bool block;
  final Color color;
  final Color textColor;

  PrimaryButton(
      {@required this.text,
      @required this.onPressed,
      this.isLoading = false,
      this.block = false,
      this.color,
      this.textColor});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: block ? double.infinity : null,
      child: FlatButton(
        onPressed: onPressed,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
        child: isLoading
            ? Center(
                child: SizedBox(
                  height: 25,
                  width: 25,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  ),
                ),
              )
            : FittedBox(
                child: Text(
                  text,
                  style: TextStyle(
                      color: textColor ?? Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2),
                ),
              ),
        color: color ?? Theme.of(context).primaryColor,
      ),
    );
  }
}
