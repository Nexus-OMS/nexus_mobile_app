import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nexus_mobile_app/models/User.dart';
import 'package:nexus_mobile_app/services/APIRoutes.dart';
import 'package:nexus_mobile_app/services/AuthorizedClient.dart';

class AuthProvider with ChangeNotifier {
  User user;
  bool isAuthenticated;

  AuthProvider() {
    isAuthenticated = null;
    _init();
  }

  void _init() async {
    var token = await AuthorizedClient.retrieveAccessToken();
    if (token == null) {
      isAuthenticated = false;
      notifyListeners();
      return;
    }
    this.user = User.fromMap(
        await AuthorizedClient.get(route: APIRoutes.routes[User] + '/self'));
    isAuthenticated = true;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void signOut(BuildContext context) {
    AuthorizedClient.deauthorize();
    notifyListeners();
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
  }
}
