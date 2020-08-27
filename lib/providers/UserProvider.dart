import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nexus_mobile_app/models/Level.dart';
import 'package:nexus_mobile_app/models/User.dart';
import 'package:nexus_mobile_app/services/APIRoutes.dart';
import 'package:nexus_mobile_app/services/AuthorizedClient.dart';
import 'package:nexus_mobile_app/services/PaginateService.dart';

class UserProvider with ChangeNotifier {
  PaginateService pager;
  List<Level> level_filter = [];
  List<User> users;

  UserProvider() {
    pager = PaginateService(route: APIRoutes.routes[User]);
  }

  Future page() async {
    var completer = Completer();
    var raw_levels = await pager.page();
    users ??= [];
    for (var item in raw_levels) {
      users.removeWhere((user) => user.id == item.o_id);
      users.add(User.fromMap(item));
    }
    return completer.future;
  }

  Future get(int id) async {
    var user = User.fromMap(await AuthorizedClient.get(
        route: APIRoutes.routes[User] + '/' + id.toString()));
    users.add(user);
    return user;
  }

  Future all() async {
    var completer = Completer();
    var raw_levels = await AuthorizedClient.get(route: APIRoutes.routes[User]);
    users = [];
    for (var item in raw_levels) {
      users.add(User.fromMap(item));
    }
    return completer.future;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
