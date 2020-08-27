import 'package:intl/intl.dart';

import 'APIModel.dart';
import 'Attendance.dart';

class Event extends APIModel {
  @override
  int id;
  DateTime date;
  int term;
  @override
  String name;
  int event_type;
  List<Attendance> attendance;

  Event() {
    date = DateTime.now();
    name = '';
  }

  Event.fromMap(Map map) {
    id = map['o_id'] is String ? int.parse(map['o_id']) : map['o_id'];
    date = DateTime.parse(map['date']);
    term = map['term'] is String ? int.parse(map['term']) : map['term'];
    name = map['name'];
    attendance = [];
    for (var att in map['attendance'] ?? <Attendance>[]) {
      attendance.add(Attendance.fromMap(att));
    }
    event_type = map['event_type'] is String
        ? int.parse(map['event_type'])
        : map['event_type'];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'o_id': id.toString(),
      'date': DateFormat('y-MM-d').format(date),
      'term': term.toString(),
      'name': name,
      'event_type': event_type.toString()
    };
    return map;
  }

  String get formattedDate {
    return DateFormat('E, MMM d').format(date);
  }
}
