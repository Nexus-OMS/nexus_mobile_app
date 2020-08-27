import 'dart:async';

import 'package:nexus_mobile_app/enum/SearchTypes.dart';
import 'package:nexus_mobile_app/models/models.dart';
import 'package:nexus_mobile_app/services/AuthorizedClient.dart';

class SearchRepository {
  final StreamController<List<User>> _searchUserStream = StreamController();
  final StreamController<List<Update>> _searchUpdateStream = StreamController();
  Stream<List<User>> get userStream => _searchUserStream.stream;
  Stream<List<Update>> get updateStream => _searchUpdateStream.stream;

  Future<void> search(String query, {List<SearchTypes> types}) async {
    for (var type in types) {
      await _search(query, type);
    }
  }

  Future<void> _search(String query, SearchTypes type) async {
    switch (type) {
      case SearchTypes.users:
        try {
          var l = [];
          _searchUserStream.add(l);
          var raws = await AuthorizedClient.get(
              route: '/api/v1/search?query=${query}&scope=users');
          for (var raw in raws) {
            l.add(User.fromMap(raw));
          }
          _searchUserStream.add(l);
        } catch (e) {
          _searchUserStream.addError('There was an error.');
        }
        break;
      case SearchTypes.updates:
        try {
          var l = [];
          var raws = await AuthorizedClient.get(
              route: '/api/v1/search?query=${query}&scope=updates');
          for (var raw in raws) {
            l.add(Update.fromMap(raw));
          }
          _searchUpdateStream.add(l);
        } catch (e) {
          _searchUpdateStream.addError('There was an error.');
        }
        break;
      default:
    }
  }
}
