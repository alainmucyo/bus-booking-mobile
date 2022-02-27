import 'package:flutter/material.dart';

class EmptyContainer extends StatelessWidget {
  final String content;

  const EmptyContainer(this.content);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(22.0),
        child: Text(
          content,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
