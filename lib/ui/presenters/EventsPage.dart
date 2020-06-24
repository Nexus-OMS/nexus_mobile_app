import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_mobile_app/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:nexus_mobile_app/models/models.dart';
import 'package:nexus_mobile_app/providers/EventProvider.dart';
import 'package:nexus_mobile_app/providers/EventTypeProvider.dart';
import 'package:nexus_mobile_app/providers/TermProvider.dart';
import 'package:nexus_mobile_app/services/APIRoutes.dart';
import 'package:nexus_mobile_app/services/AuthorizedClient.dart';
import 'package:intl/intl.dart';
import 'package:nexus_mobile_app/ui/presenters/Attendance.dart';
import 'package:provider/provider.dart';

class EventsPage extends StatefulWidget {
  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> with TickerProviderStateMixin {
  BuildContext _scaffoldContext;
  TabController tabController;

  ///
  /// Creates and returns the tabs for the tab bar
  List<Widget> _getTabs() {
    EventTypeProvider eventTypeProvider =
        Provider.of<EventTypeProvider>(context);
    List<Widget> tabs = [];
    eventTypeProvider.event_types.forEach((type) {
      tabs.add(new Tab(
        text: type.name,
      ));
    });
    return tabs;
  }

  ///
  /// Returns pages for all the tabs
  List<Widget> _getPages(context) {
    EventTypeProvider eventTypeProvider =
        Provider.of<EventTypeProvider>(context);
    EventProvider eventProvider = Provider.of<EventProvider>(context);
    List<Widget> pages = [];
    eventTypeProvider.event_types.forEach((type) {
      List<Widget> list = [];
      eventProvider.events.sort((a, b) => b.date.compareTo(a.date));
      eventProvider.events
          .where((event) => event.event_type == type.id)
          .forEach((event) {
        var formatter = new DateFormat('yMMMMEEEEd');
        String formatted = formatter.format(event.date);
        if (event.name == null) {
          list.add(new ListTile(
            title: new Text(formatted),
            onTap: () {
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => new AttendancePage(
                          event.id,
                          formatted,
                          eventTypeProvider.event_types
                              .firstWhere((type) => type.id == event.event_type)
                              .name)));
            },
          ));
        } else {
          list.add(new ListTile(
            title: new Text(formatted),
            subtitle: new Text(event.name),
            onTap: () {
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => new AttendancePage(
                          event.id,
                          formatted,
                          eventTypeProvider.event_types
                              .firstWhere((type) => type.id == event.event_type)
                              .name)));
            },
          ));
        }
      });
      pages.add(
        new RefreshIndicator(
          onRefresh: () {
            return eventProvider.all();
          },
          child: new ListView(
            children: list,
          ),
        ),
      );
    });
    return pages;
  }

  ///
  /// Returns a widget for the entire page
  Widget _getTabController(context) {
    return new Scaffold(
      appBar: new AppBar(
        title: const Text('Events'),
        bottom: _getTabBar(),
      ),
      body: new TabBarView(
        controller: tabController,
        children: _getPages(context),
      ),
      floatingActionButton: (BlocProvider.of<AuthenticationBloc>(context).state
                      as AuthenticationStateAuthenticated)
                  .user
                  .permissions
                  .where((permission) =>
                      permission.name.contains('All') ||
                      permission.name.contains('Records'))
                  .length !=
              0
          ? new FloatingActionButton(
              onPressed: () => _showAddEventDialog(),
              child: new Icon(Icons.add))
          : null,
    );
  }

  ///
  /// Gets creates and returns the tab bar widget
  Widget _getTabBar() {
    EventTypeProvider eventTypeProvider =
        Provider.of<EventTypeProvider>(context);
    if (eventTypeProvider.event_types.length > 1) {
      return new TabBar(
        tabs: _getTabs(),
        controller: tabController,
      );
    } else {
      return null;
    }
  }

  ///
  /// Shows a DatePicker and creates a new event if ok is selected
  void _showAddEventDialog() {
    EventProvider eventProvider = Provider.of<EventProvider>(context);
    EventTypeProvider eventTypeProvider =
        Provider.of<EventTypeProvider>(context);
    TermProvider termProvider = Provider.of<TermProvider>(context);

    DateTime current = new DateTime.now();
    showDatePicker(
            context: context,
            initialDate: current,
            firstDate: new DateTime(current.year - 1),
            lastDate: new DateTime(current.year + 1))
        .then((date) async {
      // Submit request for event
      var formatter = new DateFormat('yyyy-MM-dd');
      String formatted = formatter.format(date);
      AuthorizedClient.post(
          route: APIRoutes.routes[Event],
          content: <String, String>{
            'event_type': eventTypeProvider.event_types[tabController.index].id
                .toString(),
            'date': formatted,
            'term': termProvider.terms[0].term.toString()
          }).then((value) {
        eventProvider.events.add(new Event.fromMap(value));
      });
      Scaffold.of(_scaffoldContext).showSnackBar(new SnackBar(
        content: new Text("Event on " + formatted + " added."),
      ));
    }).catchError((error) {
      Scaffold.of(_scaffoldContext).showSnackBar(new SnackBar(
        content: new Text("Error adding event"),
      ));
      debugPrint(error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(body: new Center(child: CircularProgressIndicator()));
    /*
    tabController  = new TabController(length: store.state.eventTypes.length, vsync: this);
    return new Scaffold(
      body: new Builder(
          builder: (BuildContext context) {
            _scaffoldContext = context;
            return _getTabController(store, context);
          }
      ),
    );
    */
  }
}
