import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nexus_mobile_app/models/AttendanceType.dart';
import 'package:nexus_mobile_app/services/APIRoutes.dart';
import 'package:nexus_mobile_app/services/AuthorizedClient.dart';

class AttendanceTypeProvider with ChangeNotifier {
  List<AttendanceType> attendance_types = [];

  AttendanceTypeProvider();

  Future<AttendanceType> get(int id) async {
    var event = AttendanceType.fromMap(await AuthorizedClient.get(
        route: APIRoutes.routes[AttendanceType] + '/' + id.toString()));
    attendance_types.add(event);
    return event;
  }

  Future all() async {
    var completer = Completer();
    var raw_levels =
        await AuthorizedClient.get(route: APIRoutes.routes[AttendanceType]);
    for (var item in raw_levels) {
      attendance_types.removeWhere((sitem) => sitem.id == item.o_id);
      attendance_types.add(AttendanceType.fromMap(item));
    }
    return completer.future;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
