import 'package:flutter/material.dart';

class NErrorTile extends StatelessWidget {
  final String error_name;

  NErrorTile({this.error_name});

  @override
  Widget build(BuildContext context) {
    return new Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
            color: Colors.white,
            border: new Border(bottom: BorderSide(color: Colors.black12, width: 1 ))
        ),
        child: new Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Color.fromARGB(70, 220, 220, 220),
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.error_outline, color: Colors.grey,),
              Text('There was an issue loading this '+error_name+'.', style: new TextStyle(color: Colors.grey),),
            ],
          ),
        )
    );
  }
}
