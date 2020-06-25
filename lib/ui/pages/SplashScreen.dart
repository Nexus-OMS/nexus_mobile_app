import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
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
