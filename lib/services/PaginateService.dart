import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:nexus_mobile_app/enum/TaskStatus.dart';
import 'package:http/http.dart';
import 'package:nexus_mobile_app/models/APIModel.dart';
import 'package:nexus_mobile_app/models/models.dart';
import 'package:nexus_mobile_app/services/AuthorizedClient.dart';

import 'APIRoutes.dart';

class PaginateService<APIModel> {
  int current_page;
  int total_page;
  int size;
  String route;
  Map<String, String> arguments;

  PaginateService(
      {this.arguments, @required this.route, this.current_page = 1});

  Future<dynamic> page({int size = 15}) async {
    this.current_page++;
    String url = route + '?page=' + current_page.toString();
    var response = await AuthorizedClient.get(route: url);
    // Increase page numbers, return data
    this.total_page = response.body.total;
    this.current_page = response.body.current_page;

    return response.body.data;
  }
}
