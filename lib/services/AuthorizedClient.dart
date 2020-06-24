import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:nexus_mobile_app/enum/TaskStatus.dart';
import 'package:http/http.dart';

class AuthorizedClient {
  //Constants
  static String TOKEN_KEY = "AFSABRE_ACCESS_TOKEN";
  static String USERNAME_KEY = "AFSABRE_USERNAME";

  static StreamController authDoneController = new StreamController.broadcast();

  static Stream get authDone => authDoneController.stream;

  static Future<TaskStatus> deauthorize() async {
    await deleteAccessToken();
    await deleteUsername();
    return TaskStatus.SUCCESS;
  }

  static Future<TaskStatus> authenticate(
      {String username, String password}) async {
    Client client = new Client();
    var cst = await GetConstants(username);
    debugPrint(' - Authentication Request - ');
    debugPrint('\tBase URI: ' + cst['BASE_URI']);

    var response =
        await client.post(cst['BASE_URI'] + '/oauth/token', headers: {
      HttpHeaders.acceptHeader: 'application/json'
    }, body: {
      'username': username,
      'password': password,
      'grant_type': cst["GRANT_TYPE"],
      'client_id': cst["CLIENT_ID"],
      'client_secret': cst["CLIENT_SECRET"],
      'scope': cst["SCOPE"]
    }).catchError((e) {
      print(e);
      return TaskStatus.FAILURE;
    }).timeout(new Duration(seconds: 6));

    debugPrint(response.body.toString());
    debugPrint('\tStatus Code: ' + response.statusCode.toString());
    if (response.statusCode == HttpStatus.ok) {
      Map parsedMap = json.decode(response.body);
      await storeAccessToken(parsedMap['access_token']);
      await storeUsername(username);
      authDoneController.add('AuthSuccess');
      return TaskStatus.SUCCESS;
    } else {
      return TaskStatus.FAILURE;
    }
  }

  static Image getImageWidget(
      {@required String route,
      @required Map<String, String> constants,
      @required String access_token}) {
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: 'Bearer ' + access_token
    };
    try {
      NetworkImage net =
          new NetworkImage(constants['BASE_URI'] + route, headers: headers);
      return new Image(
        image: net,
        fit: BoxFit.fitWidth,
        alignment: Alignment(0, -1),
      );
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  static ImageProvider getImageProvider(
      {@required String route,
      @required Map<String, String> constants,
      @required String access_token}) {
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: 'Bearer ' + access_token
    };
    try {
      NetworkImage net =
          new NetworkImage(constants['BASE_URI'] + route, headers: headers);
      return net;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  static dynamic processResponse(Response response) {
    switch (response.statusCode) {
      case HttpStatus.ok:
        {
          return json.decode(response.body);
        }
        break;
      case HttpStatus.unauthorized:
        {
          debugPrint('== Unauthorized ==');
          deauthorize();
        }
        break;
      default:
        {
          print(response.request);
          throw new HttpRequestError(response.statusCode);
        }
    }
  }

  // Should have a catchError block whenever this is called.
  static Future<dynamic> get({String route}) async {
    Client client = new Client();
    String token = await retrieveAccessToken();
    if (token == null) return null;
    var cst = await GetConstants();
    Map<String, String> headers = {
      HttpHeaders.acceptHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer ' + token
    };
    return client
        .get(cst['BASE_URI'] + route, headers: headers)
        .then((response) {
      return processResponse(response);
    }).timeout(new Duration(seconds: 6));
  }

  // Should have a catchError block whenever this is called.
  static Future<dynamic> post(
      {String route, Map<String, dynamic> content}) async {
    Client client = new Client();
    String token = await retrieveAccessToken();
    print('got token');
    if (token == null) return null;
    print('tokennotnull');
    var cst = await GetConstants();
    print('gotconstants');
    Map<String, String> headers = {
      HttpHeaders.acceptHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer ' + token
    };
    return client
        .post(cst['BASE_URI'] + route, headers: headers, body: content)
        .then((response) {
      return processResponse(response);
    }).timeout(new Duration(seconds: 6));
  }

  static Future<Map<String, String>> GetConstants([String username]) async {
    Map<String, String> DevConstants = {
      "BASE_URI": "http://10.0.2.2",
      "CLIENT_ID": "2",
      "CLIENT_SECRET": "",
      "GRANT_TYPE": "password",
      "SCOPE": ""
    };
    Map<String, String> ProdConstants = {
      "BASE_URI": "",
      "CLIENT_ID": "",
      "CLIENT_SECRET": "",
      "GRANT_TYPE": "password",
      "SCOPE": ""
    };
    if (username == null) {
      username = await retrieveUsername();
    }
    if (username.contains("dev", 2)) {
      return DevConstants;
    }
    return ProdConstants;
  }

  static Future<bool> checkConnection() async {
    return null != await (new Connectivity().checkConnectivity());
  }

  // KeyChain Functions
  static FlutterSecureStorage _getSecureStorage() {
    return new FlutterSecureStorage();
  }

  static Future<String> retrieveUsername() async {
    return await _getSecureStorage().read(key: USERNAME_KEY);
  }

  static Future<TaskStatus> storeUsername(String username) async {
    debugPrint('\tStoring Username: ' + username);
    try {
      await _getSecureStorage().write(key: USERNAME_KEY, value: username);
    } catch (e) {
      print(e);
      return TaskStatus.FAILURE;
    }
    return TaskStatus.SUCCESS;
  }

  static Future<TaskStatus> deleteUsername() async {
    try {
      await _getSecureStorage().delete(key: USERNAME_KEY);
    } catch (e) {
      print(e);
      return TaskStatus.FAILURE;
    }
    return TaskStatus.SUCCESS;
  }

  static Future<String> retrieveAccessToken() async {
    return await _getSecureStorage().read(key: TOKEN_KEY);
  }

  static Future<TaskStatus> storeAccessToken(String accessToken) async {
    debugPrint('\tStoring Access Token: ' + accessToken);
    try {
      await _getSecureStorage().write(key: TOKEN_KEY, value: accessToken);
    } catch (e) {
      print(e);
      return TaskStatus.FAILURE;
    }
    return TaskStatus.SUCCESS;
  }

  static Future<TaskStatus> deleteAccessToken() async {
    try {
      await _getSecureStorage().delete(key: TOKEN_KEY);
    } catch (e) {
      print(e);
      return TaskStatus.FAILURE;
    }
    return TaskStatus.SUCCESS;
  }
}

class HttpRequestError {
  int status;
  HttpRequestError(this.status);
  @override
  String toString() {
    return "HTTP Status: " + status.toString();
  }
}
