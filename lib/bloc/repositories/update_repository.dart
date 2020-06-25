import 'dart:async';

import 'package:nexus_mobile_app/models/Update.dart';
import 'package:nexus_mobile_app/services/APIRoutes.dart';
import 'package:nexus_mobile_app/services/AuthorizedClient.dart';
import 'package:nexus_mobile_app/services/PaginateService.dart';

class UpdateRepository {
  PaginateService pager;
  List<Update> updates = List();

  UpdateRepository() {
    this.pager =
        new PaginateService(route: APIRoutes.routes[Update] + "/published");
  }

  Future<List<Update>> page() async {
    var raw_values = await pager.page();
    for (var item in raw_values) {
      Update update = Update.fromMap(item);
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

  Future all() async {
    var completer = new Completer();
    var raw_levels =
        await AuthorizedClient.get(route: APIRoutes.routes[Update]);
    for (var item in raw_levels) {
      updates.removeWhere((sitem) => sitem.id == item.o_id);
      updates.add(Update.fromMap(item));
    }
    return completer.future;
  }
}
