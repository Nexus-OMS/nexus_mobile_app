import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:nexus_mobile_app/ui/theme.dart';

class NSliverIconButton extends IconButton {
  Color get color => Colors.grey;
  Color get highlightColor => NexusTheme.blue;
  Color get splashColor => NexusTheme.blue;

  NSliverIconButton({@required VoidCallback onPressed, @required Widget icon})
      : super(onPressed: onPressed, icon: icon);
}
