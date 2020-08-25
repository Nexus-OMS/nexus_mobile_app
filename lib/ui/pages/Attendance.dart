import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_mobile_app/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:nexus_mobile_app/models/models.dart';
import 'package:nexus_mobile_app/providers/AttendanceProvider.dart';
import 'package:nexus_mobile_app/providers/AttendanceTypeProvider.dart';
import 'package:nexus_mobile_app/providers/TermProvider.dart';
import 'package:nexus_mobile_app/providers/UserProvider.dart';
import 'package:nexus_mobile_app/services/APIRoutes.dart';
import 'package:nexus_mobile_app/ui/components/ProfileAvatar.dart';
import 'package:flutter/material.dart';
import 'package:nexus_mobile_app/services/AuthorizedClient.dart';
import 'package:intl/intl.dart';
import 'package:nexus_mobile_app/ui/theme.dart';
import 'package:provider/provider.dart';
import 'package:flushbar/flushbar.dart';
import 'dart:async';

class AttendancePage extends StatefulWidget {
  int event_id;
  String date;
  String event_type;
  AttendancePage(this.event_id, this.date, this.event_type, {Key key})
      : super(key: key);

  @override
  _AttendancePageState createState() => new _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage>
    with TickerProviderStateMixin {
  BuildContext _scaffoldContext;
  TabController tabController;
  AttendanceProvider attendanceProvider;
  AttendanceTypeProvider attendanceTypeProvider;
  TermProvider termProvider;

  ///
  /// Returns pages for all the tabs
  List<Widget> _getAttendanceList() {
    UserProvider userProvider = Provider.of<UserProvider>(context);

    List<Widget> list = [];
    attendanceProvider.attendance
        .where((record) => record.event_id == widget.event_id)
        .forEach((record) {
      try {
        User user =
            userProvider.users.firstWhere((user) => user.id == record.user_id);
        list.add(new ListTile(
          leading: new ProfileAvatar(
              initials: user.getInitials(), route: user.image_uri),
          title: new Text(user.getFullName()),
          subtitle: new Text(attendanceTypeProvider.attendance_types
              .firstWhere((type) => type.id == record.attendance_type)
              .name),
        ));
      } catch (error) {
        print('User ' + record.user_id.toString() + ' is hidden.');
      }
    });
    return list;
  }

  _addRecordBatch(List<int> ids) async {
    Map<String, String> att = new Map();
    att['event_id'] = widget.event_id.toString();
    ids.forEach((id) {
      att['attendance[' + id.toString() + ']'] = 4.toString();
    });

    await AuthorizedClient.post(
            route: '/api/attendance/batchupdate', content: att)
        .then((value) {
      print('batchatt');
      print(value);
      //Add Attendance to list and database
      for (var val in value) {
        attendanceProvider.attendance.add(new Attendance.fromMap(val));
      }
      Scaffold.of(_scaffoldContext).showSnackBar(new SnackBar(
        content: new Text("Attendance records added."),
      ));
    }).catchError((error) {
      print(error);
      Scaffold.of(_scaffoldContext).showSnackBar(new SnackBar(
        content: new Text("Error adding attendance"),
      ));
    });
  }

  _addRecord(int id) async {
    await AuthorizedClient.post(
        route: '/api/attendance',
        content: <String, String>{
          'attendance_type': 4.toString(),
          'user_id': id.toString(),
          'event_id': widget.event_id.toString()
        }).then((value) {
      //Add Attendance to list and database
      attendanceProvider.attendance.add(new Attendance.fromMap(value));
      Scaffold.of(_scaffoldContext).showSnackBar(new SnackBar(
        content: new Text("Record for " +
            value.user.firstName +
            ' ' +
            value.user.lastName +
            " added."),
      ));
    }).catchError((error) {
      Scaffold.of(_scaffoldContext).showSnackBar(new SnackBar(
        content: new Text("Error adding attendance"),
      ));
    });
  }

  ///
  /// Returns a widget for the entire page
  Widget _getContents() {
    if (attendanceProvider.attendance
            .where((record) => record.event_id == widget.event_id)
            .length ==
        0) {
      return new Center(
        child: new GestureDetector(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Icon(Icons.refresh),
              new Text('No Attendance Records',
                  style: new TextStyle(fontSize: 16.0)),
              new Text('Tap to Reload', style: new TextStyle(fontSize: 12.0)),
            ],
          ),
          onTap: () async {
            return attendanceProvider.all();
          },
        ),
      );
    }
    return new RefreshIndicator(
      onRefresh: () async {
        return attendanceProvider.all();
      },
      child: new ListView(
        children: _getAttendanceList(),
      ),
    );
  }

  ///
  /// Shows a DatePicker and creates a new attendance if ok is selected
  void _showAddAttendanceDialog() {
    DateTime current = new DateTime.now();
    showDatePicker(
            context: context,
            initialDate: current,
            firstDate: new DateTime(current.year - 1),
            lastDate: new DateTime(current.year + 1))
        .then((date) async {
      // Submit request for attendance
      var formatter = new DateFormat('yyyy-MM-dd');
      String formatted = formatter.format(date);

      AuthorizedClient.post(
          route: '/api/attendances',
          content: <String, String>{
            'attendance_type': attendanceTypeProvider
                .attendance_types[tabController.index].id
                .toString(),
            'date': formatted,
            'term': termProvider.terms[0].term.toString()
          }).then((value) {
        //Add Attendance to list and database
        Attendance attendance = new Attendance.fromMap(value);
        Scaffold.of(_scaffoldContext).showSnackBar(new SnackBar(
          content: new Text(attendanceTypeProvider.attendance_types
                  .firstWhere((type) => type.id == attendance.attendance_type)
                  .name +
              " on " +
              formatted +
              " added."),
        ));
      }).catchError((error) {
        Scaffold.of(_scaffoldContext).showSnackBar(new SnackBar(
          content: new Text("Error adding attendance"),
        ));
      });
    }).catchError((error) {
      debugPrint(error.toString());
      Scaffold.of(_scaffoldContext).showSnackBar(new SnackBar(
        content: new Text("Error adding attendance"),
      ));
    });
  }

  @override
  void initState() {
    super.initState();
  }

  showScanner(BuildContext context) async {
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return new GestureDetector(
            child: new Stack(
              alignment: FractionalOffset.center,
              children: <Widget>[
                new Positioned.fill(child: Container()),
                new Positioned.fill(
                    child: new IgnorePointer(
                  child: new ClipPath(
                    clipper: new RectangleClipper(),
                    child: new Container(
                      color: new Color.fromRGBO(0, 0, 0, 0.5),
                    ),
                  ),
                )),
              ],
            ),
            onTap: () => scanID(),
          );
        });
  }

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  Future<List<dynamic>> scanID() async {
    String ppath = "";

    File file = File(ppath);
    //final List<Barcode> results =
    //await detector.detectInImage(visionImage) ?? <Barcode>[];
    List<String> results;
    if (results.length != 0) {
      await AuthorizedClient.post(
          route: APIRoutes.routes[Attendance] + '/storebyuid',
          content: <String, String>{
            'attendance_type': 4.toString(),
            //'rit_uid': results.first.displayValue.substring(0, 9),
            'event_id': widget.event_id.toString()
          }).then((value) {
        print(value);
        Attendance attendance = new Attendance.fromMap(value);
        attendanceProvider.attendance.add(attendance);
        Flushbar(
          message: "Attendance Record Updated",
          title: value.user.firstName + ' ' + value.user.lastName,
          flushbarPosition: FlushbarPosition.TOP, //Immutable
          isDismissible: true,
          duration: Duration(seconds: 4),
          showProgressIndicator: false,
        )..show(context);
      }).catchError((error) {
        print(error);
        Flushbar(
          title: "There was an error.",
          message: "Something went wrong when sending the request.",
          flushbarPosition: FlushbarPosition.TOP, //Immutable
          isDismissible: true,
          duration: Duration(seconds: 4),
          backgroundColor: NexusTheme.danger,
          showProgressIndicator: false,
        )..show(context);
      });
    } else {
      Flushbar(
        title: "No Barcode Found",
        message: "Try holding the card further from the device.",
        flushbarPosition: FlushbarPosition.TOP, //Immutable
        isDismissible: true,
        duration: Duration(seconds: 4),
        showProgressIndicator: false,
      )..show(context);
    }

    return results;
  }

  @override
  Widget build(BuildContext context) {
    attendanceProvider = Provider.of<AttendanceProvider>(context);
    attendanceTypeProvider = Provider.of<AttendanceTypeProvider>(context);
    termProvider = Provider.of<TermProvider>(context);

    return new Scaffold(
      appBar: new AppBar(
        title: const Text('Attendance'),
      ),
      body: new Builder(builder: (BuildContext context) {
        _scaffoldContext = context;
        return _getContents();
      }),
    );
  }
}

class RectangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return new Path()
      ..addRect(new Rect.fromLTWH(0.0, 0.0, size.width, size.height))
      ..addRect(new Rect.fromLTWH(
          .1 * size.width, .3 * size.height, .8 * size.width, .4 * size.height))
      ..fillType = PathFillType.evenOdd;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
