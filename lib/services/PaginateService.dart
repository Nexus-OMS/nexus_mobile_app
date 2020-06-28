import 'dart:async';
import 'package:flutter/material.dart';
import 'package:nexus_mobile_app/services/AuthorizedClient.dart';

class PaginateService<APIModel> {
  int next_page;
  int last_page;
  int size;
  String route;
  Map<String, String> arguments;

  PaginateService({this.arguments, @required this.route, this.next_page = 1});

  Future<dynamic> page({int size = 15, String query}) async {
    String url = route + '?page=' + next_page.toString();
    if (query != null) {
      url += "&$query";
    }
    var response = await AuthorizedClient.get(route: url);
    // Increase page numbers, return data
    this.last_page = response["last_page"];
    if (this.last_page < response["current_page"])
      this.next_page = response["current_page"]++;

    return response["data"];
  }
}
