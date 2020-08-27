import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_mobile_app/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:nexus_mobile_app/bloc/repositories/event_repository.dart';
import 'package:nexus_mobile_app/models/Event.dart';
import 'package:nexus_mobile_app/models/EventType.dart';
import 'package:nexus_mobile_app/ui/components/tiles/NErrorTile.dart';
import 'package:nexus_mobile_app/ui/components/tiles/SkeletonTile.dart';
import 'package:nexus_mobile_app/ui/pages/main/events/attendance_page.dart';
import 'package:nexus_mobile_app/ui/theme.dart';

class EventsList extends StatefulWidget {
  final EventType type;
  final Stream<Event> stream;
  EventsList(this.type, this.stream);
  @override
  _EventsListState createState() => _EventsListState();
}

enum _EventListState { loading, error, data }

class _EventsListState extends State<EventsList>
    with AutomaticKeepAliveClientMixin {
  List<Event> events = [];
  _EventListState _state = _EventListState.loading;

  @override
  void initState() {
    super.initState();
    _getEvents();
    widget.stream.listen((event) {
      if (event.event_type == widget.type.id) {
        events.add(event);
        events.sort((a, b) => a.date.isAfter(b.date) ? 1 : 0);
      }
    });
  }

  Future<void> _getEvents() async {
    setState(() {
      _state = _EventListState.loading;
    });
    var temp = await EventRepository.getEvents(widget.type);
    if (temp != null) {
      setState(() {
        temp.sort((a, b) => a.date.isAfter(b.date) ? 1 : 0);
        events = temp;
        _state = _EventListState.data;
      });
      return;
    }
    setState(() {
      _state = _EventListState.error;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      onRefresh: () async {
        await _getEvents();
      },
      child: ListView(
        children: _buildList(),
      ),
    );
  }

  List<Widget> _buildList() {
    switch (_state) {
      case _EventListState.loading:
        return List(12).map<Widget>((idx) {
          return SkeletonTile(
            height: 60,
          );
        }).toList();
        break;
      case _EventListState.error:
        return [NErrorTile()];
        break;
      default:
        return events.map<Widget>((event) => EventTile(event)).toList();
    }
  }

  @override
  bool get wantKeepAlive => true;
}

class EventTile extends StatelessWidget {
  final Event event;
  EventTile(this.event);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        child: Container(
            padding: EdgeInsets.only(left: 12.0, right: 12.0, bottom: 16.0),
            child: Row(
              children: <Widget>[
                Flexible(
                  child: Padding(
                      padding: EdgeInsets.only(left: 16.0, right: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(1),
                            child: Text(
                              event.formattedDate,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .copyWith(fontSize: 22),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Row(
                            children: [
                              Padding(
                                  padding: EdgeInsets.all(1),
                                  child: Text(
                                    event.name ?? 'N/A',
                                    style: Theme.of(context).textTheme.caption,
                                    maxLines: 1,
                                  )),
                              Spacer(),
                              Padding(
                                padding: EdgeInsets.all(1),
                                child: Icon(Icons.fiber_manual_record,
                                    size: 16,
                                    color: _getAttendanceColor(context)),
                              )
                            ],
                          )
                        ],
                      )),
                )
              ],
            )),
        onTap: () {
          var user = (BlocProvider.of<AuthenticationBloc>(context).state
                  as AuthenticationStateAuthenticated)
              .user;
          if (user.canManageRecords()) {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => AttendancePage(event)));
          }
        });
  }

  Color _getAttendanceColor(BuildContext context) {
    final user_id =
        BlocProvider.of<AuthenticationBloc>(context).repository.user.id;
    final att =
        event.attendance.firstWhere((element) => element.user_id == user_id);
    if (att != null) {
      final type = att.attendance_type;
      if ([2, 5].contains(type)) {
        return NexusTheme.danger;
      }
      if (type == 6) {
        return NexusTheme.warning;
      }
      if ([1, 3, 4].contains(type)) {
        return NexusTheme.success;
      }
    }
    return Colors.grey.withAlpha(157);
  }
}
