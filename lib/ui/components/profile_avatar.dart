import 'package:nexus_mobile_app/extensions.dart';
import 'package:flutter/material.dart';

class ProfileAvatar extends StatefulWidget {
  final String initials;
  final String route;
  final double size;

  ProfileAvatar(
      {Key key, @required this.initials, @required this.route, this.size})
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
    child = await context.client.getProfileAvatar(widget.route, widget.initials,
        size: widget.size ?? 24);
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
          radius: widget.size ?? 24,
        );
  }
}
