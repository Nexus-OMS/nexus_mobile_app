import 'model.dart';

class EventType extends Model {
  EventType.fromMap(Map map) {
    id = map['o_id'];
    name = map['name'];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{'o_id': id, 'name': name};
    return map;
  }
}
