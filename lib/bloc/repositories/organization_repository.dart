import 'dart:async';

import 'package:nexus_mobile_app/models/models.dart';
import 'package:nexus_mobile_app/services/APIRoutes.dart';
import 'package:nexus_mobile_app/services/AuthorizedClient.dart';
import 'package:nexus_mobile_app/services/PaginateService.dart';

class OrganizationRepository {
  PaginateService userPager;
  List<User> users = List();
  List<Level> levels = List();
  List<Unit> units = List();
  Position positions = null;

  OrganizationRepository() {
    this.userPager = new PaginateService(route: APIRoutes.routes[User]);
  }

  bool nullEmpty(dynamic obj) {
    return (obj == null || obj.length == 0);
  }

  Future<List<User>> pageUsers({String query, bool refresh}) async {
    if (refresh ?? false) {
      this.userPager = new PaginateService(route: APIRoutes.routes[User]);
      users = List();
    }
    var raw_values = query != null
        ? await userPager.page(query: query)
        : await userPager.page();
    for (var item in raw_values) {
      User user = User.fromMap(item);
      users.removeWhere((sitem) => sitem.id == user.id);
      users.add(user);
    }
    return users;
  }

  Future<User> getUser(int id) async {
    var user = User.fromMap(await AuthorizedClient.get(
        route: APIRoutes.routes[User] + '/' + id.toString()));
    users.add(user);
    return user;
  }

  Future<List<User>> getUsersByPosition(int id) async {
    var raw_value =
        await AuthorizedClient.get(route: APIRoutes.routes[Position] + '/$id');
    List<User> _users = List();
    for (var item in raw_value['user']) {
      if (item['level'] is int && !nullEmpty(levels)) {
        item['level'] =
            this.levels.firstWhere((element) => element.id == item['level']);
      }
      _users.add(User.fromMap(item));
    }
    return _users;
  }

  Future<Position> getPositions() async {
    var raw_value =
        await AuthorizedClient.get(route: APIRoutes.routes[Position]);
    positions = Position.fromMap(raw_value[0]);
    return positions;
  }

  Future<Position> getPosition(int id) async {
    var raw_value =
        await AuthorizedClient.get(route: APIRoutes.routes[Position] + '/$id');
    var unit = Position.fromMap(raw_value);
    return unit;
  }

  Future<List<Unit>> getUnits() async {
    var raw_values = await AuthorizedClient.get(route: APIRoutes.routes[Unit]);
    units = List();
    for (var item in raw_values) {
      var unit = Unit.fromMap(item);
      units.add(unit);
    }
    return units;
  }

  Future<Unit> getUnit(int id) async {
    var raw_value =
        await AuthorizedClient.get(route: APIRoutes.routes[Unit] + '/$id');
    var unit = Unit.fromMap(raw_value);
    return unit;
  }

  Future<List<Level>> getLevels() async {
    var raw_values = await AuthorizedClient.get(route: APIRoutes.routes[Level]);
    this.levels = List();
    for (var item in raw_values) {
      var level = Level.fromMap(item);
      this.levels.add(level);
    }
    return this.levels;
  }

  Future<Level> getLevel(int id) async {
    var raw_value =
        await AuthorizedClient.get(route: APIRoutes.routes[Level] + '/$id');
    var unit = Level.fromMap(raw_value);
    return unit;
  }
}
