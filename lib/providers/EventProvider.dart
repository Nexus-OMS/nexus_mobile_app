import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nexus_mobile_app/models/Event.dart';
import 'package:nexus_mobile_app/services/APIRoutes.dart';
import 'package:nexus_mobile_app/services/AuthorizedClient.dart';
import 'package:nexus_mobile_app/services/PaginateService.dart';

class EventProvider with ChangeNotifier {
  PaginateService pager;
  List<Event> events = [];

  EventProvider() {
    pager = PaginateService(route: APIRoutes.routes[Event]);
  }

  Future page() async {
    var completer = Completer();
    var raw_values = await pager.page();
    for (var item in raw_values) {
      events.removeWhere((sitem) => sitem.id == item.o_id);
      events.add(Event.fromMap(item));
    }
    return completer.future;
  }

  Future<Event> get(int id) async {
    var event = Event.fromMap(await AuthorizedClient.get(
        route: APIRoutes.routes[Event] + '/' + id.toString()));
    events.add(event);
    return event;
  }

  Future all() async {
    var completer = Completer();
    var raw_levels = await AuthorizedClient.get(route: APIRoutes.routes[Event]);
    for (var item in raw_levels) {
      events.removeWhere((sitem) => sitem.id == item.o_id);
      events.add(Event.fromMap(item));
    }
    return completer.future;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
