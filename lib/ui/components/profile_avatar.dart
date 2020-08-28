import 'package:nexus_mobile_app/extensions.dart';
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
  Widget child;
  @override
  void initState() {
    super.initState();
    asyncInit();
  }

  void asyncInit() async {
    child =
        await context.client.getProfileAvatar(widget.route, widget.initials);
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return child ??
        CircleAvatar(
          backgroundColor: Color(0xFFEEEEEE),
          child: Text(widget.initials),
          radius: 24,
        );
  }
}
