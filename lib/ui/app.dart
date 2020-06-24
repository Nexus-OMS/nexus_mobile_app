import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_mobile_app/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:nexus_mobile_app/ui/presenters/AuthPage.dart';
import 'package:nexus_mobile_app/ui/presenters/BottomNavWidget.dart';
import 'package:nexus_mobile_app/ui/presenters/SplashScreen.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
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
