import 'model.dart';

class AttendanceType extends Model {
  int id;
  String short;
  String name;

  AttendanceType();

  AttendanceType.fromMap(Map map) {
    id = map['o_id'];
    short = map['short'];
    name = map['name'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {'o_id': id, 'short': short, 'name': name};
    return map;
  }
}
