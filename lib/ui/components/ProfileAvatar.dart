import 'package:nexus_mobile_app/services/AuthorizedClient.dart';
import 'package:flutter/material.dart';

class ProfileAvatar extends StatefulWidget {
  String initials;
  String route;
  String access_token;
  Map<String, String> constants;

  ProfileAvatar({Key key, @required this.initials, @required this.route})
      : super(key: key);
  @override
  _ProfileAvatarState createState() => _ProfileAvatarState();
}

class _ProfileAvatarState extends State<ProfileAvatar> {
  @override
  void initState() {
    AuthorizedClient.GetConstants().then((constants) {
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
      return new CircleAvatar(
        backgroundColor: new Color(0xFFEEEEEE),
        child: new Text(widget.initials),
        radius: 24,
      );
    }
    return CircleAvatar(
      backgroundImage: AuthorizedClient.getImageProvider(
          route: widget.route,
          constants: widget.constants,
          access_token: widget.access_token),
      radius: 24,
    );
  }
}
