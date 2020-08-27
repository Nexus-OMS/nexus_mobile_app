import 'package:nexus_mobile_app/models/model.dart';

class Announcement extends Model {
  @override
  int id;
  String title;
  String text;

  Announcement();

  Announcement.fromMap(Map map) {
    id = map['o_id'] is String ? int.parse(map['o_id']) : map['o_id'];
    title = map['title'];
    text = map['text'];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'o_id': id,
      'title': title,
      'text': text,
    };
    return map;
  }

  @override
  String toString() {
    return 'Announcement: {id: $id, title: $title, text: $text }';
  }
}
