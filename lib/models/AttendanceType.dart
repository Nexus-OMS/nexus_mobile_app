import 'model.dart';

class AttendanceType extends Model {
  @override
  int id;
  String short;
  @override
  String name;

  AttendanceType();

  AttendanceType.fromMap(Map map) {
    id = map['o_id'];
    short = map['short'];
    name = map['name'];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{'o_id': id, 'short': short, 'name': name};
    return map;
  }
}
