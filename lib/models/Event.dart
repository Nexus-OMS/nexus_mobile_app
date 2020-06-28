import 'APIModel.dart';

class Event extends APIModel {
  int id;
  DateTime date;
  int term;
  String name;
  int event_type;

  Event();

  Event.fromMap(Map map) {
    id = map['o_id'] is String ? int.parse(map['o_id']) : map['o_id'];
    date = DateTime.parse(map['date']);
    term = map['term'] is String ? int.parse(map['term']) : map['term'];
    name = map['name'];
    event_type = map['event_type'] is String
        ? int.parse(map['event_type'])
        : map['event_type'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'o_id': id,
      'date': date.toString(),
      'term': term,
      'name': name,
      'event_type': event_type
    };
    return map;
  }
}
