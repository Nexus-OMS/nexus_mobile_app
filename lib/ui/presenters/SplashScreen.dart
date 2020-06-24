import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:nexus_mobile_app/providers/AuthProvider.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      AuthProvider authProvider = Provider.of<AuthProvider>(context);
      if (authProvider.isAuthenticated != null) {
        if (authProvider.isAuthenticated == false) {
          // Navigate to signin
          debugPrint('== Not Authenticated ==');
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/login', (Route<dynamic> route) => false);
        } else {
          // Navigate to home page
          debugPrint('== Authenticated ==');
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/home', (Route<dynamic> route) => false);
        }
      }
    });
    return Scaffold(
      body: Center(
        child: Hero(
          tag: 'app_icon',
          child: Image.asset(
            'assets/icon/icon_transparent.png',
            width: 100.0,
            height: 100.0,
          ),
        ),
      ),
    );
  }
}
