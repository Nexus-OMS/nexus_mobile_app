import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:nexus_mobile_app/NColors.dart';

import 'DashboardPage.dart';
import 'LoginPage.dart';
import 'MembersPage.dart';
import 'EventsPage.dart';
import 'UpdatesPage.dart';

class BottomNavWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BottomNavWidgetState();
}

class _BottomNavWidgetState extends State<BottomNavWidget> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;
  final _widgetOptions = [
    new DashboardPage(),
    new MembersPage(),
    new EventsPage(),
    new UpdatesPage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(OMIcons.home), title: Text('Home')),
          BottomNavigationBarItem(
              icon: Icon(OMIcons.accountCircle), title: Text('Members')),
          BottomNavigationBarItem(
              icon: Icon(OMIcons.calendarToday), title: Text('Events')),
          BottomNavigationBarItem(
              icon: Icon(OMIcons.allInbox), title: Text('Updates')),
        ],
        currentIndex: _selectedIndex,
        iconSize: 24.0,
        selectedItemColor: NColors.dark,
        unselectedItemColor: NColors.dark.withOpacity(0.7),
        backgroundColor: Color.fromARGB(170, 255, 255, 255),
        onTap: _onItemTapped,
      ),
    );
  }
}
