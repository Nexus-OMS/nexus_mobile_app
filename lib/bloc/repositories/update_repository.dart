import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nexus_mobile_app/models/Update.dart';
import 'package:nexus_mobile_app/services/APIRoutes.dart';
import 'package:nexus_mobile_app/services/AuthorizedClient.dart';
import 'package:nexus_mobile_app/services/PaginateService.dart';

class UpdateRepository {
  PaginateService pager;
  List<Update> updates = [];

  UpdateRepository() {
    pager = PaginateService(route: APIRoutes.routes[Update] + '/published');
  }

  Future<List<Update>> page() async {
    var raw_values = await pager.page();
    for (var item in raw_values) {
      var update = Update.fromMap(item);
      updates.removeWhere((sitem) => sitem.id == update.id);
      updates.add(update);
    }
    return updates;
  }

  Future<Update> get(int id) async {
    var update = Update.fromMap(await AuthorizedClient.get(
        route: APIRoutes.routes[Update] + '/' + id.toString()));
    updates.add(update);
    return update;
  }

  Future<List<Update>> all() async {
    try {
      var _updates = [];
      var raw_levels = await AuthorizedClient.get(
          route: APIRoutes.routes[Update] + '/published');
      for (var item in raw_levels) {
        _updates.removeWhere((sitem) => sitem.id == item['o_id']);
        _updates.add(Update.fromMap(item));
      }
      return _updates;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }
}
