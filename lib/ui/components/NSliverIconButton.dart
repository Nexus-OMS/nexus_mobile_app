import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:nexus_mobile_app/ui/theme.dart';

class NSliverIconButton extends IconButton {
  @override
  Color get color => Colors.grey;
  @override
  Color get highlightColor => NexusTheme.blue;
  @override
  Color get splashColor => NexusTheme.blue;

  NSliverIconButton({@required VoidCallback onPressed, @required Widget icon})
      : super(onPressed: onPressed, icon: icon);
}
