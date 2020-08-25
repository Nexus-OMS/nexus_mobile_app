import 'model.dart';

class Unit extends Model {
  int id;
  String name;
  String ad_group;

  Unit();

  Unit.fromMap(Map map) {
    id = map['o_id'];
    name = map['name'];
    ad_group = map['ad_group'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'o_id': id,
      'name': name,
      'ad_group': ad_group,
    };
    return map;
  }
}
