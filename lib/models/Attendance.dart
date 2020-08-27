import 'package:nexus_mobile_app/models/AttendanceType.dart';

import 'User.dart';
import 'model.dart';

class Attendance extends Model {
  @override
  int id;
  int user_id;
  int event_id;
  int attendance_type;
  User user;

  Attendance();

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'o_id': id,
      'user_id': user_id,
      'event_id': event_id,
      'attendance_type': attendance_type
    };
    return map;
  }

  Attendance.fromMap(Map map) {
    id = map['o_id'] is String ? int.parse(map['o_id']) : map['o_id'];
    user_id =
        map['user_id'] is String ? int.parse(map['user_id']) : map['user_id'];
    event_id = map['event_id'] is String
        ? int.parse(map['event_id'])
        : map['event_id'];
    attendance_type = _toInt(map['attendance_type']);
    user = map['user'] != null ? User.fromMap(map['user']) : null;
  }

  int _toInt(dynamic item) {
    if (item is String) {
      return int.parse(item);
    } else if (item is Map) {
      return AttendanceType.fromMap(item).id;
    } else {
      return item;
    }
  }

  @override
  String toString() {
    return 'Attendance($id): event-' +
        event_id.toString() +
        ', user-' +
        user_id.toString();
  }
}
