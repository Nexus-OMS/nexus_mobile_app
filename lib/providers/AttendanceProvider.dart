import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nexus_mobile_app/models/Attendance.dart';
import 'package:nexus_mobile_app/services/APIRoutes.dart';
import 'package:nexus_mobile_app/services/AuthorizedClient.dart';
import 'package:nexus_mobile_app/services/PaginateService.dart';

class AttendanceProvider with ChangeNotifier {
  PaginateService pager;
  List<Attendance> attendance = [];

  AttendanceProvider() {
    pager = PaginateService(route: APIRoutes.routes[Attendance]);
  }

  Future page() async {
    var completer = Completer();
    var raw_values = await pager.page();
    for (var item in raw_values) {
      attendance.removeWhere((sitem) => sitem.id == item.o_id);
      attendance.add(Attendance.fromMap(item));
    }
    return completer.future;
  }

  Future<Attendance> get(int id) async {
    var event = Attendance.fromMap(await AuthorizedClient.get(
        route: APIRoutes.routes[Attendance] + '/' + id.toString()));
    attendance.add(event);
    return event;
  }

  Future all() async {
    var completer = Completer();
    var raw_levels =
        await AuthorizedClient.get(route: APIRoutes.routes[Attendance]);
    for (var item in raw_levels) {
      attendance.removeWhere((sitem) => sitem.id == item.o_id);
      attendance.add(Attendance.fromMap(item));
    }
    return completer.future;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
