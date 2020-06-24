import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:nexus_mobile_app/NColors.dart';

class NSliverIconButton extends IconButton {
  Color get color => Colors.grey;
  Color get highlightColor => NColors.blue;
  Color get splashColor => NColors.blue;

  NSliverIconButton({@required VoidCallback onPressed, @required Widget icon})
      : super(onPressed: onPressed, icon: icon);
}
