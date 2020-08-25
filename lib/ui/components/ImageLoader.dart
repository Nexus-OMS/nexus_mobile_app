import 'package:nexus_mobile_app/services/AuthorizedClient.dart';
import 'package:flutter/material.dart';

class ImageLoader extends StatefulWidget {
  String initials;
  String route;
  String access_token;
  Map<String, String> constants;

  ImageLoader({Key key, @required this.route}) : super(key: key);
  @override
  _ImageLoaderState createState() => _ImageLoaderState();
}

class _ImageLoaderState extends State<ImageLoader> {
  @override
  void initState() {
    AuthorizedClient.getConstants().then((constants) {
      setState(() {
        widget.constants = constants;
      });
    });

    AuthorizedClient.retrieveAccessToken().then((token) {
      setState(() {
        widget.access_token = token;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.route == null ||
        widget.access_token == null ||
        widget.constants == null) {
      return null;
    }
    return AuthorizedClient.getImageWidget(
        route: widget.route,
        constants: widget.constants,
        access_token: widget.access_token);
  }
}
