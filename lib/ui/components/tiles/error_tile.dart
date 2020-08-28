import 'package:flutter/material.dart';

class NErrorTile extends StatelessWidget {
  final String error_name;

  NErrorTile({this.error_name});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1))),
        child: Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.error_outline,
              ),
              error_name != null
                  ? Text(
                      'There was an issue loading this ' + error_name + '.',
                    )
                  : Container(),
            ],
          ),
        ));
  }
}
