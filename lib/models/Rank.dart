import 'model.dart';

class Rank extends Model {
  @override
  int id;
  @override
  String name;

  Rank();

  Rank.fromMap(Map map) {
    id = map['o_id'];
    name = map['name'];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{'o_id': id, 'name': name};
    return map;
  }
}
