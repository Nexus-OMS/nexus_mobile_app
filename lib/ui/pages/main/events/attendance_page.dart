import 'dart:async';

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:nexus_mobile_app/bloc/repositories/event_repository.dart';
import 'package:nexus_mobile_app/enum/search_types.dart';
import 'package:nexus_mobile_app/models/attendance.dart';
import 'package:nexus_mobile_app/models/event.dart';
import 'package:nexus_mobile_app/models/user.dart';
import 'package:nexus_mobile_app/ui/pages/main/events/attendance_list.dart';
import 'package:nexus_mobile_app/ui/pages/main/events/scanner_page.dart';
import 'package:nexus_mobile_app/ui/pages/search/search_page.dart';
import 'package:nexus_mobile_app/extensions.dart';

class AttendancePage extends StatefulWidget {
  final Event event;
  AttendancePage(this.event);
  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  EventRepository repository;
  final StreamController<Attendance> _controller =
      StreamController<Attendance>();

  @override
  void initState() {
    super.initState();
    repository = EventRepository(context.client);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AttendanceList(widget.event, _controller.stream),
      appBar: AppBar(
        title: Text(widget.event.name ?? widget.event.formattedDate),
        automaticallyImplyLeading: false,
        leading: Container(),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(MdiIcons.qrcode),
        onPressed: () async {
          var att = await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ScannerPage((Attendance att) {
              if (att != null && att is Attendance) {
                _controller.add(att);
              }
            }, widget.event),
          ));
          if (att != null && att is Attendance) {
            _controller.add(att);
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
          notchMargin: 8,
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.chevron_left, size: 32),
                onPressed: () => Navigator.of(context).pop(),
              ),
              Spacer(),
              IconButton(
                  icon: Icon(Icons.keyboard),
                  onPressed: () async {
                    var user =
                        await Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SearchPage(
                        context.client,
                        filters: [SearchTypes.users],
                      ),
                    ));
                    if (user != null) {
                      _addAttendance(user);
                    }
                  }),
            ],
          )),
    );
  }

  Future<void> _addAttendance(User user) async {
    Attendance record;
    record = await repository.saveAttendance(widget.event.id, user_id: user.id);
    if (record != null) {
      _controller.add(record);
    }
  }
}
