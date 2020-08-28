import 'package:flutter/material.dart';
import 'package:nexus_mobile_app/bloc/repositories/event_repository.dart';
import 'package:nexus_mobile_app/models/attendance.dart';
import 'package:nexus_mobile_app/models/event.dart';
import 'package:nexus_mobile_app/ui/components/tiles/error_tile.dart';
import 'package:nexus_mobile_app/ui/components/tiles/skeleton_tile.dart';
import 'package:nexus_mobile_app/extensions.dart';
import 'package:nexus_mobile_app/ui/theme.dart';

class AttendanceList extends StatefulWidget {
  final Event event;
  final Stream<Attendance> stream;
  AttendanceList(this.event, this.stream);
  @override
  _AttendancesListState createState() => _AttendancesListState();
}

enum _AttendanceListState { loading, error, data }

class _AttendancesListState extends State<AttendanceList>
    with AutomaticKeepAliveClientMixin {
  EventRepository repository;
  List<Attendance> attendances = [];
  _AttendanceListState _state = _AttendanceListState.loading;

  @override
  void initState() {
    super.initState();
    repository = EventRepository(context.client);
    _getAttendances();
    widget.stream.listen((attendance) {
      var idx = attendances.indexWhere((sitem) => sitem.id == attendance.id);
      if (idx != -1) {
        attendances.replaceRange(idx, idx + 1, [attendance]);
      } else {
        attendances.add(attendance);
      }
      if (mounted) setState(() {});
    });
  }

  Future<void> _getAttendances() async {
    setState(() {
      _state = _AttendanceListState.loading;
    });
    var temp = await repository.getEventAttendance(widget.event.id);
    if (mounted) {
      if (temp != null) {
        setState(() {
          attendances = temp;
          _state = _AttendanceListState.data;
        });
      } else {
        setState(() {
          _state = _AttendanceListState.error;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      onRefresh: () async {
        await _getAttendances();
      },
      child: ListView(
        children: _buildList(),
      ),
    );
  }

  List<Widget> _buildList() {
    switch (_state) {
      case _AttendanceListState.loading:
        return List(12).map<Widget>((idx) {
          return SkeletonTile(
            height: 50,
          );
        }).toList();
        break;
      case _AttendanceListState.error:
        return [NErrorTile()];
        break;
      default:
        return attendances
            .map<Widget>((attendance) => AttendanceTile(attendance))
            .toList();
    }
  }

  @override
  bool get wantKeepAlive => true;
}

class AttendanceTile extends StatelessWidget {
  final Attendance attendance;
  AttendanceTile(this.attendance);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Container(
            padding: EdgeInsets.only(
                left: 16.0, right: 16.0, top: 12.0, bottom: 12.0),
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
                              attendance.user.getFullName(),
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
                                    'N/A',
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
        onTap: () {});
  }

  Color _getAttendanceColor(BuildContext context) {
    final type = attendance.attendance_type;
    if ([2, 5].contains(type)) {
      return NexusTheme.danger;
    }
    if (type == 6) {
      return NexusTheme.warning;
    }
    if ([1, 3, 4].contains(type)) {
      return NexusTheme.success;
    }
    return NexusTheme.backgroundDark;
  }
}
