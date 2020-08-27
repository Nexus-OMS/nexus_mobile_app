import 'package:nexus_mobile_app/services/AuthorizedClient.dart';
import 'package:flutter/material.dart';

class ProfileAvatar extends StatefulWidget {
  final String initials;
  final String route;

  ProfileAvatar({Key key, @required this.initials, @required this.route})
      : super(key: key);
  @override
  _ProfileAvatarState createState() => _ProfileAvatarState();
}

class _ProfileAvatarState extends State<ProfileAvatar> {
  String access_token;
  Map<String, String> constants;
  @override
  void initState() {
    super.initState();
    asyncInit();
  }

  void asyncInit() async {
    constants = await AuthorizedClient.getConstants();
    access_token = await AuthorizedClient.retrieveAccessToken();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.route == null || access_token == null || constants == null) {
      return CircleAvatar(
        backgroundColor: Color(0xFFEEEEEE),
        child: Text(widget.initials),
        radius: 24,
      );
    }
    return CircleAvatar(
      backgroundImage: AuthorizedClient.getImageProvider(
          route: widget.route,
          constants: constants,
          access_token: access_token),
      radius: 24,
    );
  }
}
