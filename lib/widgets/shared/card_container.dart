import 'package:flutter/material.dart';

class CardContainer extends StatelessWidget {
  final Widget child;

  const CardContainer({this.child});

  @override
  Widget build(BuildContext context) {
    return Ink(
      // padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(3.0),
        boxShadow: [
          BoxShadow(
              color: Colors.grey[200], blurRadius: 4.0, offset: Offset(0, 2))
        ],
      ),
      child: child,
    );
  }
}
