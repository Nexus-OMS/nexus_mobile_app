import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nexus_mobile_app/models/Level.dart';
import 'package:nexus_mobile_app/services/APIRoutes.dart';
import 'package:nexus_mobile_app/services/AuthorizedClient.dart';

class LevelProvider with ChangeNotifier {
  List<Level> levels;

  LevelProvider();

  Future retreive() async {
    var completer = Completer();
    var raw_levels = await AuthorizedClient.get(route: APIRoutes.routes[Level]);
    levels ??= [];
    for (var item in raw_levels) {
      levels.add(Level.fromMap(item));
    }
    return completer.future;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
