import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_mobile_app/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:nexus_mobile_app/bloc/repositories/event_repository.dart';
import 'package:nexus_mobile_app/models/models.dart';
import 'package:nexus_mobile_app/extensions.dart';
import 'package:nexus_mobile_app/ui/components/tiles/error_tile.dart';
import 'package:nexus_mobile_app/ui/decorators/bubble_tab_decorator.dart';
import 'package:nexus_mobile_app/ui/pages/main/events/events_list.dart';
import 'package:nexus_mobile_app/ui/pages/main/events/new_event_page.dart';

class EventsPage extends StatefulWidget {
  @override
  _EventsPageState createState() => _EventsPageState();
}

enum _TypesState { loading, data, error }

class _EventsPageState extends State<EventsPage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  TabController tabController;

  StreamController<Event> controller = StreamController<Event>.broadcast();
  Stream eventAdded;

  List<EventType> types = [];
  _TypesState _typesState = _TypesState.loading;

  ///
  /// Creates and returns the tabs for the tab bar
  List<Widget> _getTabs() {
    var tabs = <Widget>[];
    types.forEach((type) {
      tabs.add(Tab(text: type.name));
    });
    return tabs;
  }

  ///
  /// Returns a widget for the entire page
  Widget _getTabController() {
    var user = (context.bloc<AuthenticationBloc>().state
            as AuthenticationStateAuthenticated)
        .user;
    return CustomScrollView(slivers: <Widget>[
      SliverAppBar(
        actions: user.canManageRecords()
            ? [
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () async {
                    var event = await Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (_context) =>
                                context.clientProvider(NewEventPage(types))));
                    controller.add(event);
                  },
                )
              ]
            : [],
        snap: true,
        floating: true,
        bottom: TabBar(
          indicator: BubbleTabDecorator(Theme.of(context).accentColor),
          tabs: _getTabs(),
          controller: tabController,
        ),
      ),
      SliverFillRemaining(
          child: TabBarView(
        controller: tabController,
        children: types.map<Widget>((type) {
          return EventsList(type, eventAdded);
        }).toList(),
      )),
    ]);
  }

  Future<void> _getTypes() async {
    var temp = await context.repository<EventRepository>().getEventTypes();
    if (temp is List) {
      if (mounted) {
        setState(() {
          types = temp;
          tabController = TabController(length: temp.length, vsync: this);
          _typesState = _TypesState.data;
        });
      }
      return;
    }
    if (mounted) {
      setState(() {
        _typesState = _TypesState.error;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getTypes();
    eventAdded = controller.stream;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Widget child;
    switch (_typesState) {
      case _TypesState.data:
        return _getTabController();
        break;
      case _TypesState.loading:
        child = Center(
            child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator()));
        break;
      case _TypesState.error:
        child = NErrorTile();
        break;
      default:
    }
    return Scaffold(
      body: child,
    );
  }

  @override
  bool get wantKeepAlive => true;
}
