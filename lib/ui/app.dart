import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_mobile_app/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:nexus_mobile_app/services/AuthorizedClient.dart';
import 'package:nexus_mobile_app/ui/pages/AuthPage.dart';
import 'package:nexus_mobile_app/ui/pages/BottomNavWidget.dart';
import 'package:nexus_mobile_app/ui/pages/SplashScreen.dart';

import 'package:flutter/services.dart';
import 'package:uni_links/uni_links.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

enum UniLinksType { string, uri }

class _AppState extends State<App> {
  StreamSubscription _sub;
  Uri _latestUri;

  @override
  initState() {
    super.initState();
    initPlatformState();
  }

  initPlatformState() async {
    await initPlatformStateForUriUniLinks();
  }

  /// An implementation using the [Uri] convenience helpers
  initPlatformStateForUriUniLinks() async {
    // Attach a listener to the Uri links stream
    _sub = getUriLinksStream().listen((Uri uri) {
      if (!mounted) return;
      setState(() {
        _latestUri = uri;
      });
    }, onError: (err) {
      if (!mounted) return;
      setState(() {
        _latestUri = null;
      });
    });

    // Attach a second listener to the stream
    getUriLinksStream().listen((Uri uri) async {
      final host = await AuthorizedClient.getDomain();
      final authed = await BlocProvider.of<AuthenticationBloc>(context)
          .repository
          .isAuthenticated;
      if (uri?.host == "login.nexus.barnstorm" && host != null && !authed) {
        final client = uri.queryParameters;
        await AuthorizedClient.setClient(client['client_id'], client['secret']);
        BlocProvider.of<AuthenticationBloc>(context)
            .add(AuthenticationEventReceivedClient());
      }
      print('got uri: ${uri?.path} ${uri?.queryParametersAll}');
    }, onError: (err) {
      print('got err: $err');
    });

    // Get the latest Uri
    Uri initialUri;
    String initialLink;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      initialUri = await getInitialUri();
      print('initial uri: ${initialUri?.path}'
          ' ${initialUri?.queryParametersAll}');
      initialLink = initialUri?.toString();
    } on PlatformException {
      initialUri = null;
      initialLink = 'Failed to get initial uri.';
    } on FormatException {
      initialUri = null;
      initialLink = 'Bad parse the initial link as Uri.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _latestUri = initialUri;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        if (state is AuthenticationStateUninitialized) {
          BlocProvider.of<AuthenticationBloc>(context)
              .add(AuthenticationEventAppStarted());
          return SplashScreen();
        }
        if (state is AuthenticationStateAuthenticated) {
          // Home Page
          return BottomNavWidget();
        } else {
          return AuthPage();
        }
      },
    );
  }
}
