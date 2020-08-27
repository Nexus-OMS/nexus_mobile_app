import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:nexus_mobile_app/models/APIModel.dart';
import 'package:nexus_mobile_app/models/models.dart';
import 'package:nexus_mobile_app/services/AuthorizedClient.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(SearchStateUninitialized());

  @override
  Stream<SearchState> mapEventToState(
    SearchEvent event,
  ) async* {
    if (event is SearchEventRefresh) {
      yield* _mapRefreshToState(event.query);
    }
  }

  Stream<SearchState> _mapRefreshToState(String query) async* {
    try {
      yield SearchStateLoading();
      var results = await search(query: query);
      yield SearchStateHasData(results[0], results[1]);
    } catch (err, stacktrace) {
      print(err);
      print(stacktrace);
      yield SearchStateError();
    }
  }

  Future<List<List<APIModel>>> search({String query}) async {
    var raw_values =
        await AuthorizedClient.get(route: '/api/v1/search?query=$query');
    var users = [];
    var updates = [];
    for (var item in raw_values['users']) {
      var model = User.fromMap(item);
      users.add(model);
    }
    for (var item in raw_values['updates']) {
      var model = Update.fromMap(item);
      updates.add(model);
    }
    return [users, updates];
  }
}
