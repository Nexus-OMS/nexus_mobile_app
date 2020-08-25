import 'model.dart';

class Attendance extends Model {
  int id;
  int user_id;
  int event_id;
  int attendance_type;

  Attendance();

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
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
    attendance_type = map['attendance_type'] is String
        ? int.parse(map['attendance_type'])
        : map['attendance_type'];
  }

  @override
  String toString() {
    return 'Attendance($id): event-' +
        event_id.toString() +
        ', user-' +
        user_id.toString();
  }
}
