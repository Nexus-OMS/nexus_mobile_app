import 'dart:async';
import 'package:flutter/material.dart';
import 'package:nexus_mobile_app/services/authorized_client.dart';

class PaginateService<APIModel> {
  int next_page;
  int last_page;
  int size;
  String route;
  Map<String, String> arguments;
  AuthorizedClient client;

  PaginateService(this.client,
      {this.arguments, @required this.route, this.next_page = 1});

  Future<dynamic> page({int size = 15, String query}) async {
    var url = route + '?page=' + next_page.toString();
    if (query != null) {
      url += '&$query';
    }
    var response = await client.get(route: url);
    // Increase page numbers, return data
    if (response is List) {
      last_page = 1;
      next_page = 1;
      return response;
    }
    last_page = response['last_page'];
    if (last_page < response['current_page']) {
      next_page = response['current_page']++;
    }

    return response['data'] ?? response;
  }
}
