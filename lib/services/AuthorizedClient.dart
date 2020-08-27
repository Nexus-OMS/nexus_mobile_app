import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:nexus_mobile_app/enum/TaskStatus.dart';
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';

class AuthorizedClient {
  //Constants
  static String TOKEN_KEY = 'NEXUS_ACCESS_TOKEN';
  static String USERNAME_KEY = 'NEXUS_USERNAME';
  static String DOMAIN_KEY = 'NEXUS_DOMAIN';
  static String CLIENT_ID_KEY = 'NEXUS_CLIENT_ID';
  static String CLIENT_SECRET_KEY = 'NEXUS_CLIENT_SECRET';

  static StreamController authDoneController = StreamController.broadcast();

  static Stream get authDone => authDoneController.stream;

  static Future<TaskStatus> deauthorize() async {
    await deleteAccessToken();
    await deleteUsername();
    await _getSecureStorage().delete(key: CLIENT_ID_KEY);
    await _getSecureStorage().delete(key: CLIENT_SECRET_KEY);
    return TaskStatus.SUCCESS;
  }

  static Future<String> getDomain() async {
    return await _getSecureStorage().read(key: DOMAIN_KEY);
  }

  static Future<void> setDomain(_domain) async {
    await _getSecureStorage().write(key: DOMAIN_KEY, value: _domain);
  }

  static Future<void> setClient(String id, String secret) async {
    await _getSecureStorage().write(key: CLIENT_ID_KEY, value: id);
    await _getSecureStorage().write(key: CLIENT_SECRET_KEY, value: secret);
  }

  static Future<void> openSignIn() async {
    final domain = await getDomain();
    final url = 'https://$domain/mobile/login';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  static Future<TaskStatus> authenticate(
      {String username, String password}) async {
    var client = Client();
    var cst = await getConstants(username);
    debugPrint(' - Authentication Request - ');
    debugPrint('\tBase URI: ' + cst['BASE_URI']);

    var response =
        await client.post(cst['BASE_URI'] + '/oauth/token', headers: {
      HttpHeaders.acceptHeader: 'application/json'
    }, body: {
      'username': username,
      'password': password,
      'grant_type': cst['GRANT_TYPE'],
      'client_id': cst['CLIENT_ID'],
      'client_secret': cst['CLIENT_SECRET'],
      'scope': cst['SCOPE']
    }).catchError((e) {
      print(e);
      return TaskStatus.FAILURE;
    }).timeout(Duration(seconds: 6));

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
    var headers = <String, String>{
      HttpHeaders.authorizationHeader: 'Bearer ' + access_token
    };
    try {
      var net =
          NetworkImage(constants['BASE_URI'] + route, headers: headers);
      return Image(
        image: net,
        fit: BoxFit.cover,
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
    var headers = <String, String>{
      HttpHeaders.authorizationHeader: 'Bearer ' + access_token
    };
    try {
      var net =
          NetworkImage(constants['BASE_URI'] + route, headers: headers);
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
      case HttpStatus.created:
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
          throw HttpRequestError(response.statusCode);
        }
    }
  }

  // Should have a catchError block whenever this is called.
  static Future<dynamic> get({String route}) async {
    var client = Client();
    var token = await retrieveAccessToken();
    if (token == null) return null;
    var cst = await getConstants();
    var headers = <String, String>{
      HttpHeaders.acceptHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer ' + token
    };
    return client
        .get(cst['BASE_URI'] + route, headers: headers)
        .then((response) {
      return processResponse(response);
    }).timeout(Duration(seconds: 6));
  }

  // Should have a catchError block whenever this is called.
  static Future<dynamic> post(
      {String route, Map<String, dynamic> content}) async {
    var client = Client();
    var token = await retrieveAccessToken();
    if (token == null) return null;
    var cst = await getConstants();
    var headers = <String, String>{
      HttpHeaders.acceptHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer ' + token
    };
    var _content = <String, dynamic>{};
    content.forEach((key, value) {
      if (value != null && value != 'null') _content[key] = value;
    });
    return client
        .post(cst['BASE_URI'] + route, headers: headers, body: _content)
        .then((response) {
      print(response.body);
      return processResponse(response);
    }).timeout(Duration(seconds: 6));
  }

  static Future<Map<String, String>> getConstants([String username]) async {
    final clientId = await _getSecureStorage().read(key: CLIENT_ID_KEY);
    final secret = await _getSecureStorage().read(key: CLIENT_SECRET_KEY);
    var headers = <String, String>{
      'BASE_URI': 'https://' + await getDomain(),
      'CLIENT_ID': clientId,
      'CLIENT_SECRET': secret,
      'GRANT_TYPE': 'password',
      'SCOPE': ''
    };
    return headers;
  }

  static Future<Map<String, String>> getHeaders() async {
    return {
      HttpHeaders.authorizationHeader: 'Bearer ' + await retrieveAccessToken()
    };
  }

  static Future<bool> checkConnection() async {
    return null != await (Connectivity().checkConnectivity());
  }

  // KeyChain Functions
  static FlutterSecureStorage _getSecureStorage() {
    return FlutterSecureStorage();
  }

  static Future<String> retrieveUsername() async {
    return await _getSecureStorage().read(key: USERNAME_KEY);
  }

  static Future<TaskStatus> storeUsername(String username) async {
    debugPrint('\tStoring Username: ' + username);
    try {
      await deleteUsername();
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
    var ret = await _getSecureStorage().read(key: TOKEN_KEY);
    return ret;
  }

  static Future<TaskStatus> storeAccessToken(String accessToken) async {
    debugPrint('\tStoring Access Token: ' + accessToken);
    try {
      await deleteAccessToken();
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
    return 'HTTP Status: ' + status.toString();
  }
}
