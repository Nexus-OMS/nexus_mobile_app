import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nexus_mobile_app/models/Term.dart';
import 'package:nexus_mobile_app/services/APIRoutes.dart';
import 'package:nexus_mobile_app/services/AuthorizedClient.dart';

class TermProvider with ChangeNotifier {
  List<Term> terms = [];

  TermProvider();

  Future<Term> get(int id) async {
    var event = Term.fromMap(await AuthorizedClient.get(
        route: APIRoutes.routes[Term] + '/' + id.toString()));
    terms.add(event);
    return event;
  }

  Future all() async {
    var completer = Completer();
    var raw_levels = await AuthorizedClient.get(route: APIRoutes.routes[Term]);
    for (var item in raw_levels) {
      terms.removeWhere((sitem) => sitem.term == item.term);
      terms.add(Term.fromMap(item));
    }
    return completer.future;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
