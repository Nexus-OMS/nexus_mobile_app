import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_mobile_app/bloc/repositories/event_repository.dart';
import 'package:nexus_mobile_app/bloc/repositories/update_repository.dart';
import 'package:nexus_mobile_app/bloc/update_bloc/update_bloc.dart';
import 'package:nexus_mobile_app/ui/pages/main/organization/OrganizationPage.dart';
import 'package:nexus_mobile_app/ui/theme.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:nexus_mobile_app/extensions.dart';

import 'DashboardPage.dart';
import 'EventsPage.dart';
import 'main/UpdatesPage.dart';

class BottomNavWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BottomNavWidgetState();
}

class _BottomNavWidgetState extends State<BottomNavWidget> {
  PageController _pageController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
    _pageController.addListener(() {
      if (mounted) {
        setState(() {
          _selectedIndex = _pageController.page.toInt();
        });
      }
    });
  }

  void _onItemTapped(int index) {
    _pageController.animateToPage(index,
        duration: Duration(microseconds: 500), curve: Curves.easeInCubic);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageView(
          controller: _pageController,
          children: List<Widget>.from([
            DashboardPage(),
            OrganizationPage(),
            RepositoryProvider(
              create: (context) => EventRepository(context.client),
              child: EventsPage(),
            ),
            BlocProvider(
                create: (context) =>
                    UpdateBloc(repository: UpdateRepository(context.client)),
                child: UpdatesPage())
          ]),
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
