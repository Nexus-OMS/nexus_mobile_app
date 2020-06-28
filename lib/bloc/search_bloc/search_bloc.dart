import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:nexus_mobile_app/models/APIModel.dart';
import 'package:nexus_mobile_app/services/APIRoutes.dart';
import 'package:nexus_mobile_app/services/PaginateService.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  PaginateService pager;

  SearchBloc(this.pager);

  @override
  SearchState get initialState => SearchStateUninitialized();

  @override
  Stream<SearchState> mapEventToState(
    SearchEvent event,
  ) async* {
    if (event is SearchEventRefresh) {
      yield* _mapRefreshAPIModeloState(event.completer, event.query);
    } else if (event is SearchEventPage) {
      yield* _mapPageAPIModeloState(event.query);
    }
  }

  Stream<SearchState> _mapRefreshAPIModeloState(
      Completer completer, String query) async* {
    try {
      List results;
      if (state is SearchStateHasData) {
        results = (state as SearchStateHasData).results;
      }
      yield SearchStateLoading(results);
      results = await this.pageAPIModel(query: query, refresh: true);
      completer.complete();
      yield SearchStateHasData(results);
    } catch (err, stacktrace) {
      print(err);
      print(stacktrace);
      yield SearchStateError();
    }
  }

  Stream<SearchState> _mapPageAPIModeloState(String query) async* {
    try {
      List results;
      if (state is SearchStateHasData) {
        results = (state as SearchStateHasData).results;
      }
      yield SearchStateLoading(results);
      results = await this.pageAPIModel(query: query);
      yield SearchStateHasData(results);
    } catch (err, stacktrace) {
      print(err);
      print(stacktrace);
      yield SearchStateError();
    }
  }

  Future<List> pageAPIModel({String query, bool refresh, List results}) async {
    if (refresh ?? false) {
      this.pager = new PaginateService(route: APIRoutes.routes[APIModel]);
      results = List();
    }
    if (results == null) results = List();
    var raw_values =
        query != null ? await pager.page(query: query) : await pager.page();
    for (var item in raw_values) {
      APIModel model = APIModel.fromMap(item);
      results.removeWhere((sitem) => sitem.id == model.id);
      results.add(model);
    }
    return results;
  }
}
