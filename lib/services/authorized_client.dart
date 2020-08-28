import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:nexus_mobile_app/enum/task_status.dart';
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';

class AuthorizedClient {
  final BuildContext context;
  AuthorizedClient(this.context);
  //Constants
  static String TOKEN_KEY = 'NEXUS_ACCESS_TOKEN';
  static String USERNAME_KEY = 'NEXUS_USERNAME';
  static String DOMAIN_KEY = 'NEXUS_DOMAIN';
  static String CLIENT_ID_KEY = 'NEXUS_CLIENT_ID';
  static String CLIENT_SECRET_KEY = 'NEXUS_CLIENT_SECRET';

  static FlutterSecureStorage get secure_storage => FlutterSecureStorage();

  static Future<String> get token async =>
      await secure_storage.read(key: TOKEN_KEY);
  static Future<String> get username async =>
      await secure_storage.read(key: USERNAME_KEY);
  static Future<String> get domain async =>
      await secure_storage.read(key: DOMAIN_KEY);
  static Future<String> get client_id async =>
      await secure_storage.read(key: CLIENT_ID_KEY);
  static Future<String> get client_secret async =>
      await secure_storage.read(key: CLIENT_SECRET_KEY);

  static Future<String> get uri async =>
      'https://${await secure_storage.read(key: DOMAIN_KEY)}';

  static Future<Map<String, String>> get headers async =>
      {HttpHeaders.authorizationHeader: 'Bearer ' + await token};
  static Future<Map<String, String>> get json_headers async => {
        ...(await headers),
        ...{HttpHeaders.acceptHeader: 'application/json'}
      };

  StreamController authDoneController = StreamController.broadcast();
  Stream get authDone => authDoneController.stream;
  StreamController authErrorController = StreamController();
  Stream get authError => authErrorController.stream;

  static Future<void> deauthorize() async {
    await Future.wait<TaskStatus>([
      secureDelete(TOKEN_KEY),
      secureDelete(USERNAME_KEY),
      secureDelete(CLIENT_ID_KEY),
      secureDelete(CLIENT_SECRET_KEY)
    ]);
  }

  static Future<TaskStatus> secureDelete(String key) async {
    try {
      await secure_storage.delete(key: key);
    } catch (e) {
      print(e);
      return TaskStatus.FAILURE;
    }
    return TaskStatus.SUCCESS;
  }

  static Future<void> setDomain(_domain) async {
    await secure_storage.write(key: DOMAIN_KEY, value: _domain);
  }

  static Future<void> setClient(String id, String secret) async {
    await secure_storage.write(key: CLIENT_ID_KEY, value: id);
    await secure_storage.write(key: CLIENT_SECRET_KEY, value: secret);
  }

  static Future<void> openSignIn() async {
    final url = '${await uri}/mobile/login';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<TaskStatus> authenticate({String username, String password}) async {
    var client = Client();
    debugPrint(' - Authentication Request - ');
    debugPrint('\tBase URI: ' + await uri);

    var response = await client.post(await uri + '/oauth/token', headers: {
      HttpHeaders.acceptHeader: 'application/json'
    }, body: {
      'username': username,
      'password': password,
      'grant_type': 'password',
      'client_id': await client_id,
      'client_secret': await client_secret,
      'scope': ''
    }).catchError((e) {
      print(e);
      return TaskStatus.FAILURE;
    }).timeout(Duration(seconds: 6));

    debugPrint(response.body.toString());
    debugPrint('\tStatus Code: ' + response.statusCode.toString());
    if (response.statusCode == HttpStatus.ok) {
      Map parsedMap = json.decode(response.body);
      await Future.wait([
        secureStore(TOKEN_KEY, parsedMap['access_token']),
        secureStore(USERNAME_KEY, username)
      ]);
      authDoneController.add('AuthSuccess');
      return TaskStatus.SUCCESS;
    } else {
      return TaskStatus.FAILURE;
    }
  }

  Future<Widget> getImageWidget(String route, Widget placeholder) async {
    try {
      return CachedNetworkImage(
        imageUrl: await uri + route,
        httpHeaders: {HttpHeaders.authorizationHeader: 'Bearer ' + await token},
        placeholder: (context, url) => placeholder,
        errorWidget: (context, url, error) => CircleAvatar(
          backgroundColor: Color(0xFFEEEEEE),
          child: Text('Error loading image.'),
          radius: 24,
        ),
      );
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future<Widget> getProfileAvatar(String route, String initials,
      {double size = 24}) async {
    return CachedNetworkImage(
      imageUrl: await uri + route,
      httpHeaders: {HttpHeaders.authorizationHeader: 'Bearer ' + await token},
      imageBuilder: (context, imageProvider) => CircleAvatar(
        backgroundColor: Color(0xFFEEEEEE),
        backgroundImage: imageProvider,
        radius: size,
      ),
      placeholder: (context, url) => CircularProgressIndicator(),
      errorWidget: (context, url, error) => CircleAvatar(
        backgroundColor: Color(0xFFEEEEEE),
        child: Text(initials),
        radius: size,
      ),
    );
  }

  dynamic processResponse(Response response) {
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
          return _handleAuthErrorResp(response);
        }
        break;
      case HttpStatus.forbidden:
        {
          return _handleAuthErrorResp(response);
        }
        break;
      default:
        {
          print(response.request);
          throw HttpRequestError(response.statusCode);
        }
    }
  }

  dynamic _handleAuthErrorResp(Response response) {
    showDialog(
        context: context,
        builder: (_context) {
          return AlertDialog(
            title: Text('Signed Out'),
            content: Text(
                'An authorization error has occurred and you have been logged out.\nIf this is a reoccuring issue please contact the developers.'),
          );
        });
    authErrorController.add(response.body);
    deauthorize();
    return response.body;
  }

  // Should have a catchError block whenever this is called.
  Future<dynamic> get({String route}) async {
    var client = Client();
    return client
        .get(await uri + route, headers: await json_headers)
        .then((response) {
      return processResponse(response);
    }).timeout(Duration(seconds: 6));
  }

  // Should have a catchError block whenever this is called.
  Future<dynamic> post({String route, Map<String, dynamic> content}) async {
    var client = Client();
    var _content = <String, dynamic>{};
    content.forEach((key, value) {
      if (value != null && value != 'null') _content[key] = value;
    });
    return client
        .post(await uri + route, headers: await json_headers, body: _content)
        .then((response) {
      print(response.body);
      return processResponse(response);
    }).timeout(Duration(seconds: 6));
  }

  Future<bool> checkConnection() async {
    return null != await (Connectivity().checkConnectivity());
  }

  // KeyChain Functions

  static Future<TaskStatus> secureStore(String key, String value) async {
    try {
      await secureDelete(key);
      await secure_storage.write(key: key, value: value);
    } catch (e) {
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
