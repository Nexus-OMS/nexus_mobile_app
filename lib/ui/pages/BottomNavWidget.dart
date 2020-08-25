import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_mobile_app/bloc/organization_bloc/organization_bloc.dart';
import 'package:nexus_mobile_app/bloc/repositories/organization_repository.dart';
import 'package:nexus_mobile_app/bloc/repositories/update_repository.dart';
import 'package:nexus_mobile_app/bloc/update_bloc/update_bloc.dart';
import 'package:nexus_mobile_app/ui/pages/main/organization/OrganizationPage.dart';
import 'package:nexus_mobile_app/ui/theme.dart';
import 'package:outline_material_icons/outline_material_icons.dart';

import 'DashboardPage.dart';
import 'EventsPage.dart';
import 'main/UpdatesPage.dart';

class BottomNavWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BottomNavWidgetState();
}

class _BottomNavWidgetState extends State<BottomNavWidget> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;
  final _widgetOptions = [
    DashboardPage(),
    OrganizationPage(),
    EventsPage(),
    BlocProvider(
        create: (context) => UpdateBloc(repository: UpdateRepository()),
        child: UpdatesPage())
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
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(canvasColor: NexusTheme.primary),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: Icon(OMIcons.home), title: Text('Home')),
              BottomNavigationBarItem(
                  icon: Icon(OMIcons.accountCircle),
                  title: Text('Organization')),
              BottomNavigationBarItem(
                  icon: Icon(OMIcons.calendarToday), title: Text('Events')),
              BottomNavigationBarItem(
                  icon: Icon(OMIcons.allInbox), title: Text('Updates')),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
          ),
        ));
  }
}
