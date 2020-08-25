import 'package:flutter/material.dart';

class PageLoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
            child: CircularProgressIndicator(), padding: EdgeInsets.all(12)));
  }
}
