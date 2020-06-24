import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nexus_mobile_app/providers/AttendanceProvider.dart';
import 'package:nexus_mobile_app/providers/AttendanceTypeProvider.dart';
import 'package:nexus_mobile_app/providers/AuthProvider.dart';
import 'package:nexus_mobile_app/providers/EventProvider.dart';
import 'package:nexus_mobile_app/providers/EventTypeProvider.dart';
import 'package:nexus_mobile_app/providers/LevelProvider.dart';
import 'package:nexus_mobile_app/providers/TermProvider.dart';
import 'package:nexus_mobile_app/providers/UserProvider.dart';
import 'package:nexus_mobile_app/ui/presenters/BottomNavWidget.dart';
import 'package:nexus_mobile_app/ui/presenters/LoginPage.dart';
import 'package:nexus_mobile_app/ui/presenters/SplashScreen.dart';
import 'package:nexus_mobile_app/ui/theme.dart';
import 'package:provider/provider.dart';

void main() => runApp(new NexusApp());

class NexusApp extends StatelessWidget {
  NexusApp();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider<AttendanceProvider>(
          create: (_) => AttendanceProvider(),
        ),
        ChangeNotifierProvider<AttendanceTypeProvider>(
          create: (_) => AttendanceTypeProvider(),
        ),
        ChangeNotifierProvider<EventProvider>(
          create: (_) => EventProvider(),
        ),
        ChangeNotifierProvider<EventTypeProvider>(
          create: (_) => EventTypeProvider(),
        ),
        ChangeNotifierProvider<UserProvider>(
          create: (_) => UserProvider(),
        ),
        ChangeNotifierProvider<TermProvider>(
          create: (_) => TermProvider(),
        ),
        ChangeNotifierProvider<LevelProvider>(
          create: (_) => LevelProvider(),
        )
      ],
      child: new MaterialApp(
        title: 'Nexus',
        initialRoute: '/',
        routes: {
          '/': (context) => SplashScreen(),
          '/login': (context) => LoginPage(),
          '/home': (context) => BottomNavWidget(),
        },
        theme: NexusTheme.getTheme(context),
      ),
    );
  }
}
