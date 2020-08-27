import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nexus_mobile_app/models/EventType.dart';
import 'package:nexus_mobile_app/services/APIRoutes.dart';
import 'package:nexus_mobile_app/services/AuthorizedClient.dart';

class EventTypeProvider with ChangeNotifier {
  List<EventType> event_types = [];

  EventTypeProvider();

  Future<EventType> get(int id) async {
    var event = EventType.fromMap(await AuthorizedClient.get(
        route: APIRoutes.routes[EventType] + '/' + id.toString()));
    event_types.add(event);
    return event;
  }

  Future all() async {
    var completer = Completer();
    var raw_levels =
        await AuthorizedClient.get(route: APIRoutes.routes[EventType]);
    for (var item in raw_levels) {
      event_types.removeWhere((sitem) => sitem.id == item.o_id);
      event_types.add(EventType.fromMap(item));
    }
    return completer.future;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
