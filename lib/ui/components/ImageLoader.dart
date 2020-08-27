import 'package:nexus_mobile_app/services/AuthorizedClient.dart';
import 'package:flutter/material.dart';

class ImageLoader extends StatefulWidget {
  final String route;

  ImageLoader({Key key, @required this.route}) : super(key: key);
  @override
  _ImageLoaderState createState() => _ImageLoaderState();
}

class _ImageLoaderState extends State<ImageLoader> {
  String access_token;
  Map<String, String> constants;
  String initials;
  @override
  void initState() {
    super.initState();
    AuthorizedClient.getConstants().then((constants) {
      setState(() {
        constants = constants;
      });
    });

    AuthorizedClient.retrieveAccessToken().then((token) {
      setState(() {
        access_token = token;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.route == null || access_token == null || constants == null) {
      return null;
    }
    return AuthorizedClient.getImageWidget(
        route: widget.route, constants: constants, access_token: access_token);
  }
}
