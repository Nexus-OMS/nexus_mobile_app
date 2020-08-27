import 'package:nexus_mobile_app/models/APIModel.dart';

class Position extends APIModel {
  @override
  int id;
  @override
  String name;
  String symbol;
  int position_superior;
  String ad_group;
  int unit;
  List<Position> children;

  Position();

  Position.fromMap(Map map) {
    id = map['o_id'];
    name = map['name'];
    symbol = map['symbol'];
    position_superior = map['position_superior'];
    ad_group = map['ad_group'];
    unit = map['unit'];
    children = <Position>[];
    if (map['children'] != null) {
      map['children'].forEach((ent) => children.add(Position.fromMap(ent)));
    }
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'o_id': id,
      'name': name,
      'symbol': symbol,
      'position_superior': position_superior,
      'ad_group': ad_group,
      'unit': unit
    };
    return map;
  }
}
